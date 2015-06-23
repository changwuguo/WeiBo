//
//  EmotionPageView.h
//  WeiBo
//
//  Created by qianfeng on 15/6/21.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
// 一页中最多3行
#define EmotionMaxRows 3
// 一页中最多3列
#define EmotionMaxCols 7
// 一页中的表情个数
#define EmotionPageCount ((EmotionMaxRows * EmotionMaxCols) - 1)

@interface EmotionPageView : UIView
/**
 *  这一页显示的表情(里面全是Emotion模型)
 */
@property (nonatomic, strong) NSArray *emotions;

@end
