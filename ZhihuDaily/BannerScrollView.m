//
//  BannerScrollView.m
//  ZhihuDaily
//
//  Created by zhaimengyang on 9/10/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "BannerScrollView.h"
#import "BannerView.h"
#import "UIView+Extension.h"
#import "NSString+Extension.h"
#import "TopStoryModel.h"
#import "BannerButton.h"
#import "UIButton+WebCache.h"

#define PLACEHOLDERIMAGE [UIImage imageNamed:@"0"]
#define BACKGROUND_COLOR [UIColor lightGrayColor]

@interface BannerScrollView ()

@end

@implementation BannerScrollView

static NSInteger const stdImageViewCount = 5;
static NSInteger const stdTag = 1000;

#pragma mark - initializer

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = BACKGROUND_COLOR;
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadSubViews) name:BannerViewDidChangeFrameNotification object:nil];
}

#pragma mark - public methods

- (void)next {
    CGPoint offset = CGPointMake(self.contentOffset.x + self.width, 0);
    [self setContentOffset:offset animated:YES];
}

- (NSInteger)pageCount {
    return stdImageViewCount;
}

#pragma mark - KVO

- (void)didChangeValueForKey:(NSString *)key {
    if ([key isEqualToString:@"contentOffset"]) {
        [self scrollViewDidChangeContentOffset];
    }
}

#pragma mark - private methods

- (void)reloadSubViews {
    for (UIView *view in self.subviews) {
        if (view.tag >= stdTag) {
            [view removeFromSuperview];
        }
    }
    
    for (NSInteger i = 0; i < stdImageViewCount + 2; i++) {
        BannerButton *bannerButton = [[BannerButton alloc]init];
        bannerButton.tag = stdTag + i;
        
        CGFloat bannerButtonW = self.superview.width;
        CGFloat bannerButtonH = self.superview.height;
        CGFloat bannerButtonX = i * bannerButtonW;
        CGFloat bannerButtonY = 0;
        bannerButton.frame = CGRectMake(bannerButtonX, bannerButtonY, bannerButtonW, bannerButtonH);
        
        [bannerButton setImage:PLACEHOLDERIMAGE forState:UIControlStateNormal];
        
        [bannerButton addTarget:self action:@selector(bannerButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:bannerButton];
    }
    
    self.contentSize = CGSizeMake(self.superview.width * (stdImageViewCount + 2), 0);
}

- (void)scrollViewDidChangeContentOffset {
    if (self.contentOffset.x == 0) {
        CGPoint toDisplay = CGPointMake(self.width * stdImageViewCount, 0);
        [self setContentOffset:toDisplay animated:NO];
    }
    if (self.contentOffset.x == self.width * (stdImageViewCount + 1)) {
        CGPoint toDisplay = CGPointMake(self.width, 0);
        [self setContentOffset:toDisplay animated:NO];
    }
}

- (NSURL *)URLForBannerButtonWithIndex:(NSInteger)index {
    NSString *urlString = _topStories[index].image;
    return [NSURL URLWithString:[NSString convertToHttpsStringWithHttpString:urlString]];
}

- (NSString *)titleForBannerButtonWithIndex:(NSInteger)index {
    return _topStories[index].title;
}

#pragma mark - actions

- (void)bannerButtonDidClick:(BannerButton *)bannerButton {
    if (!_topStories || _topStories.count == 0) {
        NSLog(@"No Internet Connection [%s]", __func__);
        return;
    }
    
    NSInteger index;
    if ((bannerButton.tag - stdTag) == 0) {
        index = _topStories.count - 1;
    } else if ((bannerButton.tag - stdTag) == (stdImageViewCount + 1)) {
        index = 0;
    } else {
        index = bannerButton.tag - stdTag - 1;
    }
    
    NSNumber *story_id = _topStories[index].id;
    if ([self.superview isKindOfClass:[BannerView class]]) {
        [(BannerView *)self.superview postNotificationWhenAStoryIsSelectedWithStoryID:story_id];
    }
}

#pragma mark - getters and setters

- (void)setTopStories:(NSArray<TopStoryModel *> *)topStories {
    _topStories = topStories;
    
    NSInteger index = 0;
    for (UIView *view in self.subviews) {
        if (view.tag >= stdTag) {
            BannerButton *bannerButton = (BannerButton *)view;
            
            if ((bannerButton.tag - stdTag) == 0) {
                index = topStories.count - 1;
            } else if ((bannerButton.tag - stdTag) == (stdImageViewCount + 1)) {
                index = 0;
            } else {
                index = bannerButton.tag - stdTag - 1;
            }
            
            [bannerButton sd_setImageWithURL:[self URLForBannerButtonWithIndex:index] forState:UIControlStateNormal placeholderImage:PLACEHOLDERIMAGE];
            [bannerButton setTitle:[self titleForBannerButtonWithIndex:index] forState:UIControlStateNormal];
        }
    }
}

@end


