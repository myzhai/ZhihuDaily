//
//  NewsModel.m
//  ZhihuDaily
//
//  Created by zhaimengyang on 9/5/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "NewsModel.h"
#import "StoryModel.h"
#import "TopStoryModel.h"

@implementation NewsModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        
        NSMutableArray *tempStories = [NSMutableArray array];
        for (NSDictionary *dic in self.stories) {
            StoryModel *story = [StoryModel storyWithDictionary:dic];
            [tempStories addObject:story];
        }
        self.stories = tempStories;
        
        NSMutableArray *tempTopStories = [NSMutableArray array];
        for (NSDictionary *dic in self.top_stories) {
            TopStoryModel *topStory = [TopStoryModel topStoryWithDictionary:dic];
            [tempTopStories addObject:topStory];
        }
        self.top_stories = tempTopStories;
    }
    
    return self;
}

+ (instancetype)newsModelWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}

@end
