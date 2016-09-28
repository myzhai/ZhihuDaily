//
//  NetworkingManager.m
//  ZhihuDaily
//
//  Created by zhaimengyang on 9/27/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "NetworkingManager.h"

@implementation NetworkingManager

+ (instancetype)sharedManager {
    static NetworkingManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NetworkingManager alloc]init];
    });
    
    return manager;
}

@end
