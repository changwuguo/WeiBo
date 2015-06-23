//
//  EmotionAttachment.m
//  WeiBo
//
//  Created by qianfeng on 15/6/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "EmotionAttachment.h"
#import "Emotion.h"

@implementation EmotionAttachment

- (void)setEmotion:(Emotion *)emotion
{
    _emotion = emotion;
    
    self.image = [UIImage imageNamed:emotion.png];
}

@end
