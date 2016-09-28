//
//  BannerButton.m
//  ZhihuDaily
//
//  Created by zhaimengyang on 9/12/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "BannerButton.h"
#import "UIView+Extension.h"
#import "UIButton+RemoveHighlightedEffect.h"

static CGFloat const MARGIN = 20;
static CGFloat const titleLabelHeight = 80;

@implementation BannerButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.removeHighlightedEffect = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.x = MARGIN;
    self.titleLabel.y = self.height - titleLabelHeight;
    self.titleLabel.width = self.width - 2 * MARGIN;
    self.titleLabel.height = titleLabelHeight;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    [self layoutIfNeeded];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    [super setImage:image forState:state];
    [self layoutIfNeeded];
}

@end
