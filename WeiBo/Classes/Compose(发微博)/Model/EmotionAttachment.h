//
//  EmotionAttachment.h
//  WeiBo
//
//  Created by qianfeng on 15/6/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Emotion;

@interface EmotionAttachment : NSTextAttachment

@property (nonatomic, strong) Emotion *emotion;

@end
