//
//  RootViewControllerFlowLayout.m
//  ZhihuDaily
//
//  Created by zhaimengyang on 9/2/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "RootViewControllerFlowLayout.h"

@implementation RootViewControllerFlowLayout

- (instancetype)init {
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumInteritemSpacing = 0;
    }
    
    return self;
}

@end
