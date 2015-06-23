//
//  TitleButton.m
//  WeiBo
//
//  Created by qianfeng on 15/6/15.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "TitleButton.h"
#define Spacing 8

@implementation TitleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    frame.size.width += Spacing;
    [super setFrame:frame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 设置文字的X坐标
    self.titleLabel.x = self.imageView.x;
    // 设置图片的X坐标
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + Spacing;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    [self sizeToFit];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    
    [self sizeToFit];
}

@end
