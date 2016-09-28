//
//  LaunchImageModel.h
//  ZhihuDaily
//
//  Created by zhaimengyang on 9/2/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LaunchImageModel : NSObject

@property (copy, nonatomic) NSString *text;
@property (copy, nonatomic) NSString *img;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)launchImageModelWithDictionary:(NSDictionary *)dict;

@end
