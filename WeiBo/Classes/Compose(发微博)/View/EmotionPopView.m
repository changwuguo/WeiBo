//
//  EmotionPopView.m
//  WeiBo
//
//  Created by qianfeng on 15/6/21.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "EmotionPopView.h"
#import "EmotionButton.h"

@interface EmotionPopView ()

@property (weak, nonatomic) IBOutlet EmotionButton *emotionBtn;

@end

@implementation EmotionPopView
/**
 *  创建popView的类方法
 */
+(instancetype)popView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"EmotionPopView" owner:nil options:nil] lastObject];
}

- (void)showFrom:(EmotionButton *)btn
{
    if(btn == nil) return;
    
    // 给popView传递数据模型
    self.emotionBtn.emotion = btn.emotion;
    
    // 取得最上面的window,保证"放大镜"在最上面
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    
    // 转换坐标系,计算出被点击的按钮在window中的frame
    CGRect btnFrame = [btn convertRect:btn.bounds toView:nil];
    self.y = CGRectGetMidY(btnFrame) - self.height;
    self.centerX = CGRectGetMidX(btnFrame);
}

@end
