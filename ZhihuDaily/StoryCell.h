//
//  StoryCell.h
//  ZhihuDaily
//
//  Created by zhaimengyang on 9/12/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define STORY_CELL_ID @"StoryCell"

@class StoryModel;

@interface StoryCell : UITableViewCell

@property(nonatomic,strong) StoryModel *storyModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)cellHeight;

@end
