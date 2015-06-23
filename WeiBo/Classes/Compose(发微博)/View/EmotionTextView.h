//
//  EmotionTextView.h
//  WeiBo
//
//  Created by qianfeng on 15/6/21.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "TextView.h"
@class Emotion;

@interface EmotionTextView : TextView

- (void)insertEmotion:(Emotion *)emotion;
- (NSString *)fullText;

@end
