//
//  TextView.m
//  WeiBo
//
//  Created by qianfeng on 15/6/19.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "TextView.h"

@implementation TextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 注册监听者,监听TextView的文字的改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}
// 重写placeholderText的setter方法,保证当改变了placeholderText的内容时能时时改变
- (void)setPlaceholderText:(NSString *)placeholderText
{
    _placeholderText = [placeholderText copy];
    [self setNeedsDisplay];
}
// 重写placeholderColor的setter方法,保证当改变了placeholderColor的内容时能时时改变
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}
// 重写font的setter方法,保证当改变了font的内容时能时时改变
- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setNeedsDisplay];
}
// 重写text的setter方法,保证当改变了text的内容时能时时改变
- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}
// 重写AttributedText的setter方法,保证当改变了AttributedText的内容时能时时改变
- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

/**
 *  监听文字的改变
 */
- (void)textDidChange
{   // 当TextView的文字发生改变,就重新调用drawRect:(CGRect)rect重新绘制占位文字,当setNeedsDisplay调用drawRect:(CGRect)rect时会把之前绘制的内容清除
    [self setNeedsDisplay];
}
/**
 *  绘制占位文字
 *
 *  @param rect self.bounds
 */
- (void)drawRect:(CGRect)rect
{
    // 如果TextView有占位文字,就直接返回
    if (self.hasText) return;
    // 占位文字的属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholderColor?self.placeholderColor:[UIColor grayColor];
    
    CGFloat x = 5;
    CGFloat width = rect.size.width - 2 * x;
    CGFloat y = 8;
    CGFloat height = rect.size.height - 2 * y;
    CGRect placeholderRect = CGRectMake(x, y, width, height);
    // 绘制文字,并且将占位文字"拘束"在一个矩形框中
    [self.placeholderText drawInRect:placeholderRect withAttributes:attrs];
}

- (void)dealloc
{
    // 移除监听者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
