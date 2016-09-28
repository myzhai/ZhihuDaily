//
//  NewsModel.h
//  ZhihuDaily
//
//  Created by zhaimengyang on 9/5/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 
 {
   "date": "20160905",
 
   "stories": [
                  {
                       "images": ["http://pic4.zhimg.com/be66e4e690ab72b935e5ab4dc308cf57.jpg"],
                       "type": 0,
                       "id": 8760463,
                       "ga_prefix": "090512",
                       "title": "大误 · 跳出时间循环的方法，就四个字"
                  }
 
                  ......
              ],
 
   "top_stories": [
                       {
                            "image": "http://pic3.zhimg.com/05773a1916cb0a7b818ef0b832d91dee.jpg",
                            "type": 0,
                            "id": 8762336,
                            "ga_prefix": "090507",
                            "title": "大夏天的还要穿一身龙袍，皇上不怕起痱子吗？"
                       }
 
                       ......
                  ]
 }

*/


@interface NewsModel : NSObject

@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) NSArray *stories;
@property (copy, nonatomic) NSArray *top_stories;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)newsModelWithDictionary:(NSDictionary *)dict;

@end
