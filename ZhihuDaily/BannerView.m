//
//  BannerView.m
//  ZhihuDaily
//
//  Created by zhaimengyang on 9/6/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "BannerView.h"
#import "BannerScrollView.h"
#import "UIView+Extension.h"

@interface BannerView () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet BannerScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (assign, nonatomic) NSInteger currentPage;
@property (strong, nonatomic) NSTimer *timer;

@end

NSString *const BannerViewDidChangeFrameNotification = @"BannerViewDidChangeFrameNotification";
NSString *const BannerViewDidSelectAStory = @"BannerViewDidSelectAStory";

@implementation BannerView

static CGFloat const stdTopLayoutConstant = 0;

#pragma mark - initializer

+ (instancetype)loadView{
    return [[[NSBundle mainBundle]loadNibNamed:@"BannerView" owner:nil options:nil]lastObject];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        //
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.scrollView.delegate = self;
    
    [self bringSubviewToFront:self.pageControl];
    self.pageControl.numberOfPages = [self.scrollView pageCount];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor = [[UIColor whiteColor]colorWithAlphaComponent:0.2];
    self.pageControl.userInteractionEnabled = NO;
    
    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self addTimer];
}

#pragma mark - KVO

- (void)didChangeValueForKey:(NSString *)key {
    if ([key isEqualToString:@"frame"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:BannerViewDidChangeFrameNotification object:self];
    }
}

#pragma mark - public methods

- (void)postNotificationWhenAStoryIsSelectedWithStoryID:(NSNumber *)story_id {
    [self invalidateTimer];
    [[NSNotificationCenter defaultCenter]postNotificationName:BannerViewDidSelectAStory object:self userInfo:[NSDictionary dictionaryWithObject:story_id forKey:@"key"]];
}

#pragma mark - private methods

- (void)addTimer {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    self.timer = timer;
}

- (void)invalidateTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - selectors

- (void)nextPage {
    [self.scrollView next];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self invalidateTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self addTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollViewW = self.scrollView.width;
    CGFloat offSetX = self.scrollView.contentOffset.x;
    self.currentPage = (offSetX + 0.5 * scrollViewW - scrollViewW)/scrollViewW;
}

#pragma mark - getters and setters

- (void)setDelta:(CGFloat)delta {
    _delta = delta;
    _topLayout.constant = stdTopLayoutConstant - delta;
    [self layoutIfNeeded];
    
    for (UIView *view in self.scrollView.subviews) {
        if (view.tag >= 1000) {
            view.height = 200 + delta;
        }
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    self.pageControl.currentPage = _currentPage;
}

- (void)setTopStories:(NSArray<TopStoryModel *> *)topStories {
    _topStories = topStories;
    
    self.scrollView.topStories = _topStories;
}

@end
