//
//  UIBarButtonItem+Extension.m
//  ZhihuDaily
//
//  Created by zhaimengyang on 9/5/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"

#pragma mark - interface BarButton : UIButton

/**********************************************
 Note 1: If I just use UIButton when I call the method
           addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents,
         the target won't invoke the action after I click the button.
         But the button is highlighted.
 Note 2: In the method of
           itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action,
         the target is NOT nil.
         But when the instance of UIButton executes the method
           addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents ,
         the target is nil.
 Note 3: This is just a temporary way to solve this problem.
         Maybe it's a bug of Xcode.
 ***********************************************/
@interface BarButton : UIButton
@property (strong, nonatomic) id target;
@end

@implementation BarButton

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    self.target = target;
    
    [super addTarget:target action:action forControlEvents:controlEvents];
}

@end

#pragma mark - implementation UIBarButtonItem (Extension)

@implementation UIBarButtonItem (Extension)

+ (instancetype)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action{
    BarButton *button = [[BarButton alloc]init];
    
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted",imageName]] forState:UIControlStateHighlighted];
    button.size = button.currentImage.size;
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

//+ (instancetype)itemWithImageName:(NSString *)imageName title:(NSString *)title target:(id)target action:(SEL)action{
//    UIButton *button = [[UIButton alloc]init];
//    
//    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted",imageName]] forState:UIControlStateHighlighted];
//    
//    [button setTitle:title forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1] forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
//    
//    [button sizeToFit];
//    
//    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    
//    return [[UIBarButtonItem alloc]initWithCustomView:button];
//}

//+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action{
//    UIButton *button = [[UIButton alloc]init];
//    
//    [button setTitle:title forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
//    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
//    [button sizeToFit];
//    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    
//    return [[UIBarButtonItem alloc]initWithCustomView:button];
//}

@end
