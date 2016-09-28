//
//  BannerView.h
//  ZhihuDaily
//
//  Created by zhaimengyang on 9/6/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopStoryModel;

@interface BannerView : UIView

+ (instancetype)loadView;
@property (assign, nonatomic) CGFloat delta;
@property (copy, nonatomic) NSArray<TopStoryModel *> *topStories;

- (void)postNotificationWhenAStoryIsSelectedWithStoryID:(NSNumber *)story_id;

@end

UIKIT_EXTERN NSString *const BannerViewDidChangeFrameNotification;
UIKIT_EXTERN NSString *const BannerViewDidSelectAStory;
