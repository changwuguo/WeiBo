//
//  UIWindow+Extension.m
//  WeiBo
//
//  Created by qianfeng on 15/6/15.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "TabBarViewController.h"
#import "NewfeatureViewController.h"

@implementation UIWindow (Extension)
- (void)switchRootViewController
{
    NSString *key = @"CFBundleVersion";
    // 取出沙盒中的版本号
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    // 获取当前版本的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    if ([currentVersion isEqualToString:lastVersion]) {
        // 创建tabBar根窗口
        TabBarViewController *tabBarView = [[TabBarViewController alloc] init];
        self.rootViewController = tabBarView;
    } else {
        // 同步key
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // 创建Newfeature根窗口
        NewfeatureViewController *newfeatureView = [[NewfeatureViewController alloc] init];
        self.rootViewController = newfeatureView;
    }
}
@end
