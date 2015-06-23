//
//  TextView.h
//  WeiBo
//
//  Created by qianfeng on 15/6/19.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextView : UITextView
/**
 *  占位文字
 */
@property (nonatomic, copy) NSString *placeholderText;
/**
 *  占位文字颜色
 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end
