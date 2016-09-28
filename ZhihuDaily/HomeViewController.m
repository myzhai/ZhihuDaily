//
//  HomeViewController.m
//  ZhihuDaily
//
//  Created by zhaimengyang on 9/2/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeRootViewController.h"
#import "Macro.h"

#define TitleTextAttributes @{NSForegroundColorAttributeName : [UIColor whiteColor]}
#define TintColor [UIColor whiteColor]
#define BarTintColor RGBColor(147, 212, 247)

@interface HomeViewController ()

@end

@implementation HomeViewController

+ (instancetype)homeViewController {
    HomeRootViewController *root = [[UIStoryboard storyboardWithName:@"HomeRootViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"HomeRootViewController"];
    HomeViewController *homeVC = [[self alloc]initWithRootViewController:root];
    
    homeVC.navigationBar.titleTextAttributes = TitleTextAttributes;
    homeVC.navigationBar.tintColor = TintColor;
    homeVC.navigationBar.barTintColor = BarTintColor;
    
    return homeVC;
}

@end
