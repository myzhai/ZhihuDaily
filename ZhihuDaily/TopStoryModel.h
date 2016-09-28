//
//  TopStoryModel.h
//  ZhihuDaily
//
//  Created by zhaimengyang on 9/5/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 {
   "image": "http://pic3.zhimg.com/05773a1916cb0a7b818ef0b832d91dee.jpg",
   "type": 0,
   "id": 8762336,
   "ga_prefix": "090507",
   "title": "大夏天的还要穿一身龙袍，皇上不怕起痱子吗？"
 
   "multipic": true,
 }
 */

@interface TopStoryModel : NSObject

@property (copy, nonatomic) NSString *image;
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) BOOL multipic;
@property (strong, nonatomic) NSNumber *type;
@property (strong, nonatomic) NSNumber *id;
@property (copy, nonatomic) NSString *ga_prefix;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)topStoryWithDictionary:(NSDictionary *)dict;

@end
