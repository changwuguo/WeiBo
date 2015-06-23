//
//  DropdownMenu.m
//  WeiBo
//
//  Created by qianfeng on 15/6/13.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "DropdownMenu.h"
@interface DropdownMenu()

@property (nonatomic, weak) UIImageView *containerView;

@end

@implementation DropdownMenu

- (UIImageView *)containerView
{
    if (!_containerView) {
        UIImageView *containerView = [[UIImageView alloc] init];
        containerView.image = [UIImage imageNamed:@"popover_background"];
        containerView.userInteractionEnabled = YES;
        [self addSubview:containerView];
        self.containerView = containerView;
    }
    return _containerView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (instancetype)menu
{
    return [[self alloc] init];
}

- (void)showFrom:(UIView *)from
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    self.frame = window.bounds;
    
    CGRect newFrame = [from convertRect:from.bounds toView:window];
    
    self.containerView.centerX = CGRectGetMidX(newFrame);
    self.containerView.y = CGRectGetMaxY(newFrame);
    
    if ([self.delegate respondsToSelector:@selector(DropdownMenuDidShow:)]) {
        [self.delegate DropdownMenuDidShow:self];
    }
}

- (void)setContent:(UIView *)content
{
    _content = content;
    content.x = 10;
    content.y = 15;
    self.containerView.width = CGRectGetMaxX(content.frame) + 10;
    self.containerView.height = CGRectGetMaxY(content.frame) + 11;
    [self.containerView addSubview:content];
}

- (void)setContentController:(UIViewController *)contentController
{
    _contentController = contentController;
    self.content = contentController.view;
}

- (void)dismiss
{
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(DropdownMenuDidDismiss:)]) {
        [self.delegate DropdownMenuDidDismiss:self];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}
@end
