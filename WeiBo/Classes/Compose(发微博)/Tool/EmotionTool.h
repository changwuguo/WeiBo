//
//  EmotionTool.h
//  WeiBo
//
//  Created by qianfeng on 15/6/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Emotion;

@interface EmotionTool : NSObject

/**
 *  取出沙盒中的最近表情数组
 */
+ (NSArray *)recentEmotions;
/**
 *  把最近的表情存入到沙盒中
 */
+ (void)addRecentEmotion:(Emotion *)emotion;

@end
