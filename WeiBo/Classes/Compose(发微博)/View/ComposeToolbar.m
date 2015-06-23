//
//  ComposeToolbar.m
//  WeiBo
//
//  Created by qianfeng on 15/6/19.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ComposeToolbar.h"
@interface ComposeToolbar()

@property (nonatomic, weak) UIButton *emotionButton;

@end

@implementation ComposeToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置ComposeToolbar的背景色
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        // 初始化Btn
        [self setBtn:@"compose_camerabutton_background" highImage:@"compose_camerabutton_background_highlighted"type:ComposeToolbarButtonTypeCamera];// 相机
        
        [self setBtn:@"compose_toolbar_picture" highImage:@"compose_toolbar_picture_highlighted" type:ComposeToolbarButtonTypePicture]; // 相册
        
        [self setBtn:@"compose_mentionbutton_background" highImage:@"compose_mentionbutton_background_highlighted" type:ComposeToolbarButtonTypeMention]; //  @
        
        [self setBtn:@"compose_trendbutton_background" highImage:@"compose_trendbutton_background_highlighted" type:ComposeToolbarButtonTypeTrend]; // #
        
        self.emotionButton = [self setBtn:@"compose_emoticonbutton_background" highImage:@"compose_emoticonbutton_background_highlighted" type:ComposeToolbarButtonTypeEmotion];// 表情
        
    }
    return self;
}

- (void)setShowKeyboarBarButton:(BOOL)showKeyboarBarButton
{
    _showKeyboarBarButton = showKeyboarBarButton;
    
    NSString *image = @"compose_emoticonbutton_background";
    NSString *highImage = @"compose_emoticonbutton_background_highlighted";
    if (self.showKeyboarBarButton) {
        image = @"compose_keyboardbutton_background";
        highImage = @"compose_keyboardbutton_background_highlighted";
    }
    [self.emotionButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [self.emotionButton setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
}

/**
 *  初始化Btn
 */
- (UIButton *)setBtn:(NSString *)image highImage:(NSString *)highImage type:(ComposeToolbarButtonType)type
{
    UIButton *btn = [[UIButton alloc] init];
    btn.tag = type;
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    return btn;
}
/**
 *  布局Btn
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;
    CGFloat btnW = self.width / count;
    CGFloat btnH = self.height;
    for (NSUInteger i = 0; i < count; i++) {
        UIButton *btn = self.subviews[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x = i * btn.width;
        btn.height = btnH;
    }
}
/**
 *  Btn点击事件
 */
- (void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(composeToolbar:didCilckBtn:)]) {
        [self.delegate composeToolbar:self didCilckBtn:btn.tag];
    }
}

@end
