//
//  EmotionKeyboard.m
//  WeiBo
//
//  Created by qianfeng on 15/6/20.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "EmotionKeyboard.h"
#import "EmotionListView.h"
#import "EmotionTabBar.h"
#import "Emotion.h"
#import "MJExtension.h"
#import "EmotionTool.h"

@interface EmotionKeyboard () <EmotionTabBarDelegate>
/**
 *  tabBar
 */
@property (nonatomic, weak) EmotionTabBar *tabBar;
/**
 *  保存正在显示的listView
 */
@property (nonatomic, weak) EmotionListView *showingListView;
/**
 *  表情列表
 */
@property (nonatomic, strong) EmotionListView *recentListView; // 最近
@property (nonatomic, strong) EmotionListView *defaultListView; // 默认
@property (nonatomic, strong) EmotionListView *emojiListView; // Emoji
@property (nonatomic, strong) EmotionListView *lxhListView; // 浪小花

@end

@implementation EmotionKeyboard

- (EmotionListView *)recentListView
{
    if (!_recentListView) {
        self.recentListView = [[EmotionListView alloc] init];
        // 加载沙盒中的表情数组
        self.recentListView.emotions = [EmotionTool recentEmotions];
    }
    return _recentListView;
}

- (EmotionListView *)defaultListView
{
    if (!_defaultListView) {
        self.defaultListView = [[EmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
        self.defaultListView.emotions = [Emotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _defaultListView;
}

- (EmotionListView *)emojiListView
{
    if (!_emojiListView) {
        self.emojiListView = [[EmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        NSArray *emojiEmotion = [NSArray arrayWithContentsOfFile:path];
        self.emojiListView.emotions = [Emotion objectArrayWithKeyValuesArray:emojiEmotion];
    }
    return _emojiListView;
}

- (EmotionListView *)lxhListView
{
    if (!_lxhListView) {
        self.lxhListView = [[EmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
        NSArray *lxhEmotion = [NSArray arrayWithContentsOfFile:path];
        self.lxhListView.emotions = [Emotion objectArrayWithKeyValuesArray:lxhEmotion];
    }
    return _lxhListView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.tabbar
        EmotionTabBar *tabBar = [[EmotionTabBar alloc] init];
        tabBar.delegate = self;
        [self addSubview:tabBar];
        self.tabBar = tabBar;
        
        // 监听表情按钮的点击
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected) name:WBEmotionDidSelectNotification object:nil];
    }
    return self;
}

- (void)emotionDidSelected
{
    // 加载沙盒中的表情数组
    self.recentListView.emotions = [EmotionTool recentEmotions];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 设置控件的frame
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tabBar.x = 0;
    self.tabBar.width = self.width;
    self.tabBar.height = 37;
    self.tabBar.y = self.height - self.tabBar.height;
    
    self.showingListView.x = 0;
    self.showingListView.y = 0;
    self.showingListView.width = self.width;
    self.showingListView.height = self.tabBar.y;
}

#pragma mark - EmotionTabBarDelegate的代理方法
- (void)emotionTabBar:(EmotionTabBar *)emotionTabBar didSelectBtn:(EmotionTabBarButtonType)buttonType
{
    // 移除正在显示的listView
    [self.showingListView removeFromSuperview];
    
    // 根据按钮的类型,切换正在显示的listView
    switch (buttonType) {
        case EmotionTabBarButtonTypeRetent:{ // 最近
            [self addSubview:self.recentListView];
            break;
        }
        case EmotionTabBarButtonTypeDefault:{ // 默认
            [self addSubview:self.defaultListView];
            break;
        }
        case EmotionTabBarButtonTypeEmoji:{ // Emoji
            [self addSubview:self.emojiListView];
            break;
        }
        case EmotionTabBarButtonTypeLxh:{ // 浪小花
            [self addSubview:self.lxhListView];
            break;
        }
    }
    // 设置正在显示的listView
    self.showingListView = [self.subviews lastObject];
    
    // 设置frame(重新调用layoutSubviews)
    [self setNeedsLayout];
}

@end
