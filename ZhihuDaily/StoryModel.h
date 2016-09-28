//
//  StoryModel.h
//  ZhihuDaily
//
//  Created by zhaimengyang on 9/5/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
  {
    "images": ["http://pic4.zhimg.com/be66e4e690ab72b935e5ab4dc308cf57.jpg"],
    "type": 0,
    "id": 8760463,
    "ga_prefix": "090512",
    "title": "大误 · 跳出时间循环的方法，就四个字"
 
    "multipic": true,
  }
*/

@interface StoryModel : NSObject

@property (copy, nonatomic) NSArray *images;
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) BOOL multipic;
@property (strong, nonatomic) NSNumber *type;
@property (strong, nonatomic) NSNumber *id;
@property (copy, nonatomic) NSString *ga_prefix;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)storyWithDictionary:(NSDictionary *)dict;

@end
