//
//  EmotionTabBar.m
//  WeiBo
//
//  Created by qianfeng on 15/6/20.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "EmotionTabBar.h"
#import "EmotionTabBarButton.h"

@interface EmotionTabBar()

@property (nonatomic, weak) EmotionTabBarButton *selectedBtn;

@end

@implementation EmotionTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupButton:@"最近" didSelectButton:EmotionTabBarButtonTypeRetent];// 最近
        [self setupButton:@"默认" didSelectButton:EmotionTabBarButtonTypeDefault];// 默认
        [self setupButton:@"Emoji" didSelectButton:EmotionTabBarButtonTypeEmoji];// Emoji
        [self setupButton:@"浪小花" didSelectButton:EmotionTabBarButtonTypeLxh];// 浪小花
    }
    return self;
}

- (void)setupButton:(NSString *)title didSelectButton:(EmotionTabBarButtonType)buttonType
{
    EmotionTabBarButton *btn = [[EmotionTabBarButton alloc] init];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    btn.tag = buttonType;
    [btn setTitle:title forState:UIControlStateNormal];
    [self addSubview:btn];
    
    // 设置背景图片
    NSString *image = @"compose_emotion_table_mid_normal";
    NSString *selectImage = @"compose_emotion_table_mid_selected";
    
    if (self.subviews.count == 1) {
        image = @"compose_emotion_table_left_normal";
        selectImage = @"compose_emotion_table_left_selected";
    } else if (self.subviews.count == 4) {
        image = @"compose_emotion_table_right_normal";
        selectImage = @"compose_emotion_table_right_selected";
    }
    
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateDisabled];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置按钮的frame
    NSUInteger btnCount = self.subviews.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    for (int i = 0; i<btnCount; i++) {
        EmotionTabBarButton *btn = self.subviews[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x = i * btnW;
        btn.height = btnH;
    }
}

/**
 *  按钮点击
 */
- (void)btnClick:(EmotionTabBarButton *)btn
{
    // 切换"按钮"的点击状态
    self.selectedBtn.enabled = YES;
    btn.enabled = NO;
    self.selectedBtn = btn;
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(emotionTabBar:didSelectBtn:)]) {
        [self.delegate emotionTabBar:self didSelectBtn:btn.tag];
    }
}

// 重新delegate的setter方法,保证在self.delegate不为空时,调用btnClick方法,让默认的defaultListView有内容
- (void)setDelegate:(id<EmotionTabBarDelegate>)delegate
{
    _delegate = delegate;
    
    // 选中"默认"按钮
    [self btnClick:(EmotionTabBarButton *)[self viewWithTag:EmotionTabBarButtonTypeDefault]];
}

@end
