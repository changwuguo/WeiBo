//
//  ComposePhotosView.h
//  WeiBo
//
//  Created by qianfeng on 15/6/19.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposePhotosView : UIView
/**
 *  添加图片
 */
- (void)addPhoto:(UIImage *)photo;
/**
 *  存储图片的数组
 */
@property (nonatomic, strong, readonly) NSMutableArray *photos;
@end
