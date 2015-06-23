//
//  NewfeatureViewController.m
//  WeiBo
//
//  Created by qianfeng on 15/6/14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "NewfeatureViewController.h"
#import "TabBarViewController.h"

#define NewfeatureCount 4

@interface NewfeatureViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) UIPageControl *pageControl;
@end

@implementation NewfeatureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    
    CGFloat scrollW = scrollView.width;
    CGFloat scrollH = scrollView.height;
    for (int i = 0 ; i < NewfeatureCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.x = i * scrollW;
        imageView.y = 0;
        imageView.width = scrollW;
        imageView.height = scrollH;
        
        NSString *imageName = [NSString stringWithFormat:@"new_feature_%d", i + 1];
        imageView.image = [UIImage imageNamed:imageName];
        [scrollView addSubview:imageView];
        
        if (NewfeatureCount - 1 == i) {
            [self setupLastImageView:imageView];
        }
    }
    
    scrollView.contentSize = CGSizeMake(scrollW * NewfeatureCount, 0);
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = NewfeatureCount;
    pageControl.currentPageIndicatorTintColor = WBColor(253, 98, 42);
    pageControl.pageIndicatorTintColor = WBColor(189, 189, 189);
    pageControl.centerX = scrollW * 0.5;
    pageControl.centerY = scrollH - 50;
    [self.view addSubview:pageControl];
    
    self.pageControl = pageControl;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double page = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = (int)(page + 0.5);
}

- (void)setupLastImageView:(UIImageView *)imageView
{
    imageView.userInteractionEnabled = YES;
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.width = 200;
    shareBtn.height = 30;
    shareBtn.centerX = imageView.width * 0.5;
    shareBtn.centerY = imageView.height * 0.65;
    
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    [shareBtn setTitle:@"分享给大家" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    
    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:shareBtn];
    
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    
    startBtn.size = startBtn.currentBackgroundImage.size;
    startBtn.centerX = shareBtn.centerX;
    startBtn.centerY = imageView.height * 0.75;
    [startBtn setTitle:@"开始微博" forState:UIControlStateNormal];
    
    [startBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startBtn];
    
}

- (void)shareBtnClick:(UIButton *)shareBtn
{
    shareBtn.selected = !shareBtn.isSelected;
}

- (void)startBtnClick
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[TabBarViewController alloc] init];
}

@end
