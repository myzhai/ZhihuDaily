//
//  NSDate+Extension.m
//  ZhihuDaily
//
//  Created by zhaimengyang on 9/14/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "NSDate+Extension.h"

static NSTimeInterval const secondsOfOneDay = 24 * 60 * 60;

@implementation NSDate (Extension)

+ (instancetype)dateBeforeTodayWithDays:(NSInteger)days {
    NSDate *today = [NSDate date];
    NSTimeInterval secondsOffset = days * secondsOfOneDay;
    
    return [today dateByAddingTimeInterval:(-1) * secondsOffset];
}

- (NSString *)stringWithDateFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = format;
    
    return [formatter stringFromDate:self];
}

@end
