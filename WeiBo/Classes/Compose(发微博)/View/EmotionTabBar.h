//
//  EmotionTabBar.h
//  WeiBo
//
//  Created by qianfeng on 15/6/20.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    EmotionTabBarButtonTypeRetent, // 最近
    EmotionTabBarButtonTypeDefault, // 默认
    EmotionTabBarButtonTypeEmoji, // Emoji
    EmotionTabBarButtonTypeLxh, // 浪小花
    
}EmotionTabBarButtonType;

@class EmotionTabBar;

@protocol EmotionTabBarDelegate <NSObject>

@optional
- (void)emotionTabBar:(EmotionTabBar *)emotionTabBar didSelectBtn:(EmotionTabBarButtonType)buttonType;

@end

@interface EmotionTabBar : UIView

@property (nonatomic, weak) id <EmotionTabBarDelegate> delegate;

@end
