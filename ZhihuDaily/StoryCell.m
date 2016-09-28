//
//  StoryCell.m
//  ZhihuDaily
//
//  Created by zhaimengyang on 9/12/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "StoryCell.h"
#import "StoryModel.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extension.h"

#define PLACEHOLDERIMAGE [UIImage imageNamed:@"0"]

@interface StoryCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *morepicImageView;

@end

@implementation StoryCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    StoryCell *cell = [tableView dequeueReusableCellWithIdentifier:STORY_CELL_ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"StoryCell" owner:nil options:nil]lastObject];
    }
    
    return cell;
}

+ (CGFloat)cellHeight {
    return 90;
}

- (NSURL *)imageURL {
    return [NSURL URLWithString:[NSString convertToHttpsStringWithHttpString:_storyModel.images.firstObject]];
}

- (void)setStoryModel:(StoryModel *)storyModel {
    _storyModel = storyModel;
    
    self.titleLabel.text = storyModel.title;
    self.morepicImageView.hidden = !storyModel.multipic;
    [self.imgView sd_setImageWithURL:[self imageURL] placeholderImage:PLACEHOLDERIMAGE];
}

@end
