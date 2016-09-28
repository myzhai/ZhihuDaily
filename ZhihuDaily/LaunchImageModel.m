//
//  LaunchImageModel.m
//  ZhihuDaily
//
//  Created by zhaimengyang on 9/2/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "LaunchImageModel.h"

@implementation LaunchImageModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (instancetype)launchImageModelWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}

@end
