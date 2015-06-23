//
//  DropdownMenu.h
//  WeiBo
//
//  Created by qianfeng on 15/6/13.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DropdownMenu;

@protocol DropdownMenuDelegate <NSObject>

@optional

- (void)DropdownMenuDidDismiss:(DropdownMenu *)Menu;
- (void)DropdownMenuDidShow:(DropdownMenu *)Menu;

@end

@interface DropdownMenu : UIView

+ (instancetype)menu;
/**
 *  显示
 */
- (void)showFrom:(UIView *)from;
/**
 *  销毁
 */
- (void)dismiss;
/**
 *  内容
 */
@property (nonatomic, strong) UIView *content;
/**
 *  内容控制器
 */
@property (nonatomic, strong) UIViewController *contentController;

@property (nonatomic, weak) id <DropdownMenuDelegate> delegate;

@end
