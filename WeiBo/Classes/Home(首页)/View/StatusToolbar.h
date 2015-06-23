//
//  StatusToolbar.h
//  WeiBo
//
//  Created by qianfeng on 15/6/17.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Status;

@interface StatusToolbar : UIView
/**
 *  微博数据模型
 */
@property (nonatomic, strong) Status *status;

/**
 *  初始化底部工具条
 */
+ (instancetype)toolbar;

@end
