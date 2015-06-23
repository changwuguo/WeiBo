//
//  TabBar.h
//  WeiBo
//
//  Created by qianfeng on 15/6/13.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TabBar;

@protocol TabBarDelegate <UITabBarDelegate>

@optional
- (void)tabBarDidClickPlusBtn:(TabBar *)tabBar;

@end

@interface TabBar : UITabBar

@property (nonatomic, weak) id <TabBarDelegate> delegate;

@end
