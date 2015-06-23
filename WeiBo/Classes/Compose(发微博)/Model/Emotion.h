//
//  Emotion.h
//  WeiBo
//
//  Created by qianfeng on 15/6/20.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Emotion : NSObject
/**
 * 表情的文字描述
 */
@property (nonatomic, copy) NSString *chs;
/**
 *  表情的png图片名
 */
@property (nonatomic, copy) NSString *png;
/**
 *  Emoji表情的16进制编码
 */
@property (nonatomic, copy) NSString *code;

@end
