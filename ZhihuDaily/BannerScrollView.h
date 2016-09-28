//
//  BannerScrollView.h
//  ZhihuDaily
//
//  Created by zhaimengyang on 9/10/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopStoryModel;

@interface BannerScrollView : UIScrollView

- (void)next;
- (NSInteger)pageCount;

@property (copy, nonatomic) NSArray<TopStoryModel *> *topStories;

@end
