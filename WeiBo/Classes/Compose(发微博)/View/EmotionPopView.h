//
//  EmotionPopView.h
//  WeiBo
//
//  Created by qianfeng on 15/6/21.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Emotion, EmotionButton;

@interface EmotionPopView : UIView

/**
 *  创建popView的类方法
 */
+(instancetype)popView;

- (void)showFrom:(EmotionButton *)btn;

@end
