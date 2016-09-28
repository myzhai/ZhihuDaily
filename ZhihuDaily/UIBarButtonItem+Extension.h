//
//  UIBarButtonItem+Extension.h
//  ZhihuDaily
//
//  Created by zhaimengyang on 9/5/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (instancetype)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action;

//+ (instancetype)itemWithImageName:(NSString *)imageName title:(NSString *)title target:(id)target action:(SEL)action;

//+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@end
