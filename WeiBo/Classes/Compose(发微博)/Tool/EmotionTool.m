//
//  EmotionTool.m
//  WeiBo
//
//  Created by qianfeng on 15/6/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

// 最近表情的存储路径
#define WBRecentEmotionsPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"emotions.archive"]

#import "EmotionTool.h"
#import "Emotion.h"

@implementation EmotionTool

static NSMutableArray *_recentEmotions;

+ (void)initialize
{
    _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:WBRecentEmotionsPath];
    if (_recentEmotions == nil) {
        _recentEmotions = [NSMutableArray array];
    }
}
/**
 *  把最近的表情存入到沙盒中
 */
+ (void)addRecentEmotion:(Emotion *)emotion
{
    // 删除重复的"旧"表情
    [_recentEmotions removeObject:emotion];
    
    // 将新表情放到数组的最前面
    [_recentEmotions insertObject:emotion atIndex:0];
    
    // 将所有的表情数据写入沙盒
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:WBRecentEmotionsPath];
}

/**
 *  返回装着Emotion模型的数组
 */
+ (NSArray *)recentEmotions
{
    return _recentEmotions;
}


@end
