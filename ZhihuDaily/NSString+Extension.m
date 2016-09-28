//
//  NSString+Extension.m
//  ZhihuDaily
//
//  Created by zhaimengyang on 9/5/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+ (NSString *)convertToHttpsStringWithHttpString:(NSString *)httpString {
    if ([httpString hasPrefix:@"http:"]) {
        NSString *sub = [httpString substringFromIndex:4];
        return [NSString stringWithFormat:@"https%@", sub];
    }
    
    return httpString;
}

@end
