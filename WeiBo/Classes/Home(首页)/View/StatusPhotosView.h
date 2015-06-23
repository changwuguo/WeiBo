//
//  StatusPhotosView.h
//  WeiBo
//
//  Created by qianfeng on 15/6/18.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//  

#import <UIKit/UIKit.h>

@interface StatusPhotosView : UIView

@property (nonatomic, strong) NSArray *photos;

/**
 *  根据图片个数计算相册尺寸
 */
+ (CGSize)sizeWithCount:(int)count;

@end
