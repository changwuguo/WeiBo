//
//  EmotionTabBarButton.m
//  WeiBo
//
//  Created by qianfeng on 15/6/20.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "EmotionTabBarButton.h"

@implementation EmotionTabBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置文字颜色
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        // 设置文字字体
        self.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return self;
}

// 按钮高亮所做的一切操作都不在了
- (void)setHighlighted:(BOOL)highlighted
{
    
}

@end
