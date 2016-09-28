//
//  NSDate+Extension.h
//  ZhihuDaily
//
//  Created by zhaimengyang on 9/14/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

+ (instancetype)dateBeforeTodayWithDays:(NSInteger)days;
- (NSString *)stringWithDateFormat:(NSString *)format;

@end
