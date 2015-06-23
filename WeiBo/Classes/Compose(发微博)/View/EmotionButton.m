//
//  EmotionButton.m
//  WeiBo
//
//  Created by qianfeng on 15/6/21.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "EmotionButton.h"
#import "Emotion.h"
#import "NSString+Emoji.h"

@implementation EmotionButton
/**
 *  当控件不是从xib,storyboard中创建就会调用这个方法
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

/**
 *  当控件是从xib,storyboard中创建就会调用这个方法
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setup];
    }
    return self;
}

/**
 *  这个方法在initWithCoder:方法后调用
 */
- (void)awakeFromNib
{
    
}
/**
 *  一般是把所有的初始化方法,放到这个方法中(无论是不是从xib,storyboard创建创建的),然后统一在initWithFrame,initWithCoder中调用
 */
- (void)setup
{
    self.titleLabel.font = [UIFont systemFontOfSize:32];
    // 按钮高亮的时候不会调整图片变灰色
    self.adjustsImageWhenHighlighted = NO;
}

/**
 *  重写emotion表情模型的setter方法
 */
-(void)setEmotion:(Emotion *)emotion
{
    _emotion = emotion;
    
    if (emotion.png) { // Emotion模型中的png存在
        [self setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
    } else if (emotion.code) { // Emotion模型中的code存在(是emoji表情)
        [self setTitle:emotion.code.emoji forState:UIControlStateNormal];
    }
}

@end
