//
//  TabBar.m
//  WeiBo
//
//  Created by qianfeng on 15/6/13.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "TabBar.h"
@interface TabBar ()

@property (nonatomic, weak) UIButton *plusBtn;

@end

@implementation TabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        plusBtn.size = plusBtn.currentBackgroundImage.size;
        [plusBtn addTarget:self action:@selector(plusBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.plusBtn.centerX = self.width * 0.5;
    self.plusBtn.centerY = self.height * 0.5;
    
    CGFloat tabbarButtonW = self.width / 5;
    NSInteger tabbarButtonIndex = 0;
    
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            child.width = tabbarButtonW;
            child.x = tabbarButtonIndex * tabbarButtonW;
            tabbarButtonIndex ++;
            if (tabbarButtonIndex == 2) {
                tabbarButtonIndex ++;
            }
        }
    }
}

- (void)plusBtnClick
{
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusBtn:)]) {
        [self.delegate tabBarDidClickPlusBtn:self];
    }
}

@end
