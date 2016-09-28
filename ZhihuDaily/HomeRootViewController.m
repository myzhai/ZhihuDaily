//
//  HomeRootViewController.m
//  ZhihuDaily
//
//  Created by zhaimengyang on 9/2/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "HomeRootViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "Macro.h"
#import "NSString+Extension.h"

#import "NewsModel.h"
#import "StoryModel.h"

#import "BannerView.h"

#import "UIView+Extension.h"

#import "StoryCell.h"

#import "NSDate+Extension.h"

#import "StoryViewController.h"

#define BACKGROUND_COLOR [UIColor lightGrayColor]

@interface HomeRootViewController () <NSURLSessionDelegate>

@property (weak, nonatomic) IBOutlet UIView *bannerContainer;

@property (weak, nonatomic) BannerView *bannerView;

@property (copy, nonatomic) NSArray<TopStoryModel *> *topStories;

@property (strong, nonatomic) NSMutableArray<StoryModel *> *latestStories;

@property (strong, nonatomic) NSMutableArray<NewsModel *> *previousNews;


@property (strong, nonatomic) UINavigationBar *navBar;
@property (strong, nonatomic) UINavigationController *navCtrl;

@property (strong, nonatomic) UIActivityIndicatorView *loadMoreIndicator;
@property (strong, nonatomic) UIView *loadMoreIndicatorContainer;

@property (assign, nonatomic) BOOL isLoadingMore;


@property (assign, nonatomic) BOOL onceToken;

@end

NSString *const HomeIconBarButtonItemDidClick = @"HomeIconBarButtonItemDidClick";

static CGFloat const stdOffset_y = 0;
static CGFloat const stdBanner_h = 200;
static CGFloat const maxContentOffset_y = stdOffset_y - 80;
static CGFloat const stdHeaderHeight = 40;
static CGFloat const stdloadMoreIndicatorContainerHeight = 50;
static CGFloat const stdLengthWhenNavBarAlphaEqualsOne = stdBanner_h + stdHeaderHeight;


static NSString *const HomeRootVCHeaderViewReuseID = @"HomeRootVCHeaderViewReuseID";

@implementation HomeRootViewController {
    CGFloat _previousOffsetY;
    
    CGFloat _navBarAlpha;
    NSString *_navTitle;
    CGPoint _tableViewContentOffset;
}

#pragma mark - lazy loading

- (NSMutableArray<StoryModel *> *)latestStories {
    if (!_latestStories) {
        _latestStories = [NSMutableArray array];
    }
    
    return _latestStories;
}

- (NSMutableArray<NewsModel *> *)previousNews {
    if (!_previousNews) {
        _previousNews = [NSMutableArray array];
    }
    
    return _previousNews;
}

- (UIActivityIndicatorView *)loadMoreIndicator {
    if (!_loadMoreIndicator) {
        _loadMoreIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_loadMoreIndicator startAnimating];
    }
    
    return _loadMoreIndicator;
}

- (UIView *)loadMoreIndicatorContainer {
    if (!_loadMoreIndicatorContainer) {
        _loadMoreIndicatorContainer = [[UIView alloc]init];
        _loadMoreIndicatorContainer.backgroundColor = BACKGROUND_COLOR;
    }
    
    return _loadMoreIndicatorContainer;
}

#pragma mark - initializer

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"今日热闻";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"Home_Icon" target:self action:@selector(homeIconBarButtonItemDidClick)];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.onceToken = NO;
    
    self.bannerContainer.height = stdBanner_h;
    
    self.tableView.estimatedRowHeight = [StoryCell cellHeight];
    self.tableView.rowHeight = [StoryCell cellHeight];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:HomeRootVCHeaderViewReuseID];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushStoryViewControllerWithInfo:) name:BannerViewDidSelectAStory object:nil];
    
    [self loadLatestStories];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.onceToken == YES) {
        self.navBar.subviews[0].alpha = _navBarAlpha;
        self.navigationItem.title = _navTitle;
        self.tableView.contentOffset = _tableViewContentOffset;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.onceToken == NO) {
        BannerView *bannerView = [BannerView loadView];
        bannerView.frame = self.bannerContainer.bounds;
        [self.bannerContainer addSubview:bannerView];
        self.bannerView = bannerView;
        
        [self.navigationController.navigationBar.subviews[0] setAlpha:0];
        self.navBar = self.navigationController.navigationBar;
        self.navCtrl = self.navigationController;
        
        self.loadMoreIndicatorContainer.width = self.tableView.width;
        self.loadMoreIndicatorContainer.height = stdloadMoreIndicatorContainerHeight;
        [self.loadMoreIndicatorContainer addSubview:self.loadMoreIndicator];
        self.loadMoreIndicator.center = CGPointMake(0.5 * self.loadMoreIndicatorContainer.width, 0.5 * self.loadMoreIndicatorContainer.height);
        self.tableView.tableFooterView = self.loadMoreIndicatorContainer;
        
        self.onceToken = YES;
    }
}

#pragma mark - private methods

- (NSURL *)URLForPreviousNewsWithDayOffset:(NSInteger)offset {
    return [NSURL URLWithString:[NSString convertToHttpsStringWithHttpString:[previousURLPrefix stringByAppendingString:[[NSDate dateBeforeTodayWithDays:offset] stringWithDateFormat:@"yyyyMMdd"]]]];
}

- (void)loadLatestStories {
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[NSString convertToHttpsStringWithHttpString:latestURL]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error && data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NewsModel *news = [NewsModel newsModelWithDictionary:dict];
            
            self.bannerView.topStories = news.top_stories;
            self.topStories = news.top_stories;
            
            [self.latestStories addObjectsFromArray:news.stories];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else {
            NSLog(@"%s : Can not refresh", __func__);
        }
    }] resume];
}

- (void)loadPreviousNews {
    self.isLoadingMore = YES;
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[self URLForPreviousNewsWithDayOffset:self.previousNews.count] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error && data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NewsModel *news = [NewsModel newsModelWithDictionary:dict];
            
            if (![self.previousNews containsObject:news]) {
                [self.previousNews addObject:news];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    self.tableView.tableFooterView.hidden = YES;
                    self.isLoadingMore = NO;
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tableView.tableFooterView.hidden = YES;
                self.isLoadingMore = NO;
                [self.tableView reloadData];
            });
            NSLog(@"%@", error);
            NSLog(@"%s : Can not refresh", __func__);
        }
    }] resume];
}

- (void)changeTitleWhenScrolled:(UIScrollView *)scrollView {
    /*
        946        = 2783       = 4625        = 6556        = 8396
            + 1837       + 1842        + 1931        + 1840
     
        946 = section_0.count * rowH + bannerH - 64
     
        rowH = 90
        rowCount = 20
        totalRowH = 90 * 20 = 1800
        headerH = 40
     */
    CGFloat offsetToChangeToPreviousTitle = self.latestStories.count * [StoryCell cellHeight] + stdBanner_h - 64;
    CGFloat offsetToChangePreviousTitle = [StoryCell cellHeight] * 20;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY > _previousOffsetY) {
        //scroll up
        if (offsetY < offsetToChangeToPreviousTitle) {
            return;
        } else {
            if (self.isLoadingMore) {
                return;
            }
            
            NSInteger count = (NSInteger)((offsetY - offsetToChangeToPreviousTitle) / offsetToChangePreviousTitle);
            NSString *title = self.previousNews[count].date;
            if (![self.navigationItem.title isEqualToString:title]) {
                self.navigationItem.title = title;
            }
        }
        //end scroll up
    } else if (offsetY < _previousOffsetY){
        //scroll down
        if (offsetY < offsetToChangeToPreviousTitle) {
            if (![self.navigationItem.title isEqualToString:@"今日热闻"]) {
                self.navigationItem.title = @"今日热闻";
            }
        } else {
            NSInteger count = (NSInteger)((offsetY - offsetToChangeToPreviousTitle) / offsetToChangePreviousTitle);
            NSString *title = self.previousNews[count].date;
            if (![self.navigationItem.title isEqualToString:title]) {
                self.navigationItem.title = title;
            }
        }
        //end scroll down
    }
    
    _previousOffsetY = offsetY;
}

- (void)homeIconBarButtonItemDidClick {
    [[NSNotificationCenter defaultCenter]postNotificationName:HomeIconBarButtonItemDidClick object:self userInfo:nil];
}

- (void)pushStoryViewControllerWithInfo:(NSNotification *)info {
    [self pushStoryViewControllerWithStoryID:info.userInfo[@"key"]];
}

- (void)pushStoryViewControllerWithStoryID:(NSNumber *)story_id {
    [self saveStatusQuo];
    
    StoryViewController *storyVC = [[StoryViewController alloc]initWithNibName:@"StoryViewController" bundle:[NSBundle mainBundle]];
    storyVC.storyID = story_id;
    [self.navigationController pushViewController:storyVC animated:YES];
}

- (void)saveStatusQuo {
    _navBarAlpha = self.navBar.subviews[0].alpha;
    _navTitle = self.navigationItem.title;
    _tableViewContentOffset = self.tableView.contentOffset;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.latestStories.count > 0 ? 1 :0) + self.previousNews.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.latestStories.count;
    } else {
        return self.previousNews[section - 1].stories.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoryCell *cell = [StoryCell cellWithTableView:tableView];
    
    if (indexPath.section == 0) {
        cell.storyModel = self.latestStories[indexPath.row];
    } else {
        cell.storyModel = self.previousNews[indexPath.section - 1].stories[indexPath.row];
    }
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat delta = 0.0;
    if (scrollView.contentOffset.y < stdOffset_y) {
        if (scrollView.contentOffset.y < maxContentOffset_y) {
            scrollView.contentOffset = CGPointMake(0, maxContentOffset_y);
        }
        delta = ABS(scrollView.contentOffset.y - stdOffset_y);
    }
    self.bannerView.delta = delta;
    
    if (scrollView.contentOffset.y <= 0) {
        [self.navBar.subviews[0] setAlpha:0];
    } else if (scrollView.contentOffset.y >= stdLengthWhenNavBarAlphaEqualsOne) {
        [self.navBar.subviews[0] setAlpha:1];
    } else {
        [self.navBar.subviews[0] setAlpha:scrollView.contentOffset.y / stdLengthWhenNavBarAlphaEqualsOne];
    }
    
    CGFloat y = scrollView.contentSize.height - scrollView.height - self.tableView.tableFooterView.height;
    if (y < scrollView.contentOffset.y && !self.isLoadingMore) {
        self.tableView.tableFooterView.hidden = NO;
        [self loadPreviousNews];
    }
    
    [self changeTitleWhenScrolled:scrollView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return stdHeaderHeight;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.previousNews[section - 1].date;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSNumber *story_id;
    if (indexPath.section == 0) {
        story_id = self.latestStories[indexPath.row].id;
    } else {
        story_id = [self.previousNews[indexPath.section - 1].stories[indexPath.row] id];
    }
    
    [self pushStoryViewControllerWithStoryID:story_id];
}

@end


