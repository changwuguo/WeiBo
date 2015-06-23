//
//  EmotionButton.h
//  WeiBo
//
//  Created by qianfeng on 15/6/21.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Emotion;

@interface EmotionButton : UIButton
/**
 *  emotion表情模型
 */
@property (nonatomic, strong) Emotion *emotion;

@end
