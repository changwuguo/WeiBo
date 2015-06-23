//
//  TabBarViewController.m
//  WeiBo
//
//  Created by qianfeng on 15/6/12.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "TabBarViewController.h"
#import "HomeViewController.h"
#import "MessageCenterViewController.h"
#import "DiscoverViewController.h"
#import "ProfileViewController.h"
#import "NavigationController.h"
#import "TabBar.h"
#import "ComposeViewController.h"

@interface TabBarViewController () <TabBarDelegate>

@end

@implementation TabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    HomeViewController *home = [[HomeViewController alloc] init];
    [self addChildVc:home title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
    MessageCenterViewController *messageCenter = [[MessageCenterViewController alloc] init];
    [self addChildVc:messageCenter title:@"消息" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    
    DiscoverViewController *discover = [[DiscoverViewController alloc] init];
    [self addChildVc:discover title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];

    ProfileViewController *proFile = [[ProfileViewController alloc] init];
    [self addChildVc:proFile title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    
    TabBar *tabBar = [[TabBar alloc] init];
    tabBar.delegate = self;
    [self setValue:tabBar forKey:@"tabBar"];
    
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    childVc.tabBarItem.title = title;
    childVc.navigationItem.title = title;
    
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = WBColor(100, 100, 100);
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    NavigationController *nac = [[NavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nac];
}

- (void)tabBarDidClickPlusBtn:(TabBar *)tabBar
{
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
