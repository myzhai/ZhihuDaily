//
//  TopStoryModel.m
//  ZhihuDaily
//
//  Created by zhaimengyang on 9/5/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "TopStoryModel.h"

@implementation TopStoryModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}

+ (instancetype)topStoryWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}

@end
