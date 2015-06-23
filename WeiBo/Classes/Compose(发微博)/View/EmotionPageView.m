//
//  EmotionPageView.m
//  WeiBo
//
//  Created by qianfeng on 15/6/21.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "EmotionPageView.h"
#import "Emotion.h"
#import "EmotionPopView.h"
#import "EmotionButton.h"
#import "EmotionTool.h"

@interface EmotionPageView ()
/**
 *  点击表情后弹出的放大镜
 */
@property (nonatomic, strong) EmotionPopView *popView;
/**
 *  删除表情的按钮
 */
@property (nonatomic, weak) UIButton *deleteButton;

@end

@implementation EmotionPageView

// 创建放大镜(懒加载)
- (EmotionPopView *)popView
{
    if (!_popView) {
        self.popView = [EmotionPopView popView];
    }
    return _popView;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 创建"删除"按钮
        UIButton *deleteButton = [[UIButton alloc] init];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
        self.deleteButton = deleteButton;
        
        // 增加长按手势
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressPageView:)]];
    }
    return self;
}
/**
 *  根据手势位置所在的表情按钮
 */
- (EmotionButton *)emotionButtonWithLocation:(CGPoint)location
{
    NSUInteger count = self.emotions.count;
    for (int i = 0; i < count; i++) {
        EmotionButton *button = self.subviews[i + 1];
        if (CGRectContainsPoint(button.frame, location)) {
            return button;
        }
    }
    return nil;
}
/**
 *  在这个方法中处理长按手势
 */
- (void)longPressPageView:(UILongPressGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:recognizer.view];
    // 获得手势所在的位子\所在的表情按钮
    EmotionButton *button = [self emotionButtonWithLocation:location];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateCancelled: // 手势取消
        case UIGestureRecognizerStateEnded: // 手势已经不再触摸pageView(手势结束)
            // 移除popView放大镜
            [self.popView removeFromSuperview];
            
            if (button) { // 如果手势还在表情按钮上
                // 发出表情按钮点击的通知
                [self selectEmotion:button.emotion];
            }
            break;
            
        case UIGestureRecognizerStateBegan: // 手势刚检测到长按
        case UIGestureRecognizerStateChanged:{ // 手势的位置发生改变
            // 显示popView
            [self.popView showFrom:button];
            break;
        }
            
        default:
            break;
    }
}

// 重写emotions表情数组的setter方法
- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    // 获得当前页中emotions数组模型中的表情(模型)个数
    NSUInteger count = emotions.count;
    
    for (int i = 0; i < count; i++) {
        EmotionButton *btn = [[EmotionButton alloc] init];
        btn.emotion = emotions[i];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

// CUICatalog: Invalid asset name supplied: (null), or invalid scale factor: 2.000000
// 警告原因：尝试去加载的图片不存在

/**
 *  布局EmotionButton
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 内边距(四周)
    CGFloat inset = 15;
    NSUInteger count = self.emotions.count;
    CGFloat btnW = (self.width - 2 * inset) / EmotionMaxCols;
    CGFloat btnH = (self.height - inset) / EmotionMaxRows;
    for (int i = 0; i < count; i++) {
        EmotionButton *btn = self.subviews[i + 1];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = inset + (i % EmotionMaxCols) * btnW;
        btn.y = inset + (i / EmotionMaxCols) * btnH;
    }
    // 删除按钮
    self.deleteButton.width = btnW;
    self.deleteButton.height = btnH;
    self.deleteButton.x = self.width - inset - btnW;
    self.deleteButton.y = self.height - btnH;
}

// btn的点击事件,监听表情按钮点击
- (void)btnClick:(EmotionButton *)btn
{
    // 显示popView
    [self.popView showFrom:btn];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView removeFromSuperview];
    });
    
    // 发出通知
    [self selectEmotion:btn.emotion];
}

/**
 *  选中表情,发出通知
 *
 *  @param emotion 被选中的表情
 */
- (void)selectEmotion:(Emotion *)emotion
{
    // 将这个表情存进沙盒
    [EmotionTool addRecentEmotion:emotion];
    
    // 发出表情按钮点击的通知
    NSMutableDictionary *emotionInfo = [NSMutableDictionary dictionary];
    emotionInfo[WBSelectEmotionKey] = emotion;
    [[NSNotificationCenter defaultCenter] postNotificationName:WBEmotionDidSelectNotification object:nil userInfo:emotionInfo];
}

// 监听删除按钮点击
- (void)deleteClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WBEmotionDidDeleteNotification object:nil];
}

@end
