//
//  EmotionListView.m
//  WeiBo
//
//  Created by qianfeng on 15/6/20.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "EmotionListView.h"
#import "EmotionPageView.h"

@interface EmotionListView() <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;

@end

@implementation EmotionListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // 1.创建UIScrollView
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        // 去除水平方向上的滚动条
        scrollView.showsHorizontalScrollIndicator = NO;
        // 去除垂直方向上的滚动条
        scrollView.showsVerticalScrollIndicator = NO;
        // 打开分页
        scrollView.pagingEnabled = YES;
        // 关闭弹簧效果
        scrollView.bounces = NO;
        // 设置代理
        scrollView.delegate = self;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        // 2.创建UIPageControl
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        // 利用KVC给pageControl设置"圆点"图片
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKeyPath:@"pageImage"];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKeyPath:@"currentPageImage"];
        // 关闭pageControl的交互
        pageControl.userInteractionEnabled = NO;
        // 单页的时候不显示底部的小圆点
        pageControl.hidesForSinglePage = YES;
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    return self;
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSUInteger count = (emotions.count + EmotionPageCount - 1) / EmotionPageCount;
    
    // 1.pageControl分页数
    self.pageControl.numberOfPages = count;
    // 2.创建用来显示每一页表情的控件
    for (int i = 0; i < count; i++) {
        EmotionPageView *pageView = [[EmotionPageView alloc] init];
        
        NSRange range; // 截取的范围
        range.location = i * EmotionPageCount;
        // left:剩余的表情个数(可以截取的)
        NSUInteger left = emotions.count - range.location;
        if (left >= EmotionPageCount) { // 这一页足够20个
            range.length = EmotionPageCount;
        } else { // 这一页不够20个
            range.length = left;
        }
        pageView.emotions = [emotions subarrayWithRange:range];
        [self.scrollView addSubview:pageView];
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.pageControl
    self.pageControl.width = self.width;
    self.pageControl.height = 35;
    self.pageControl.x = 0;
    self.pageControl.y = self.height - self.pageControl.height;
    
    // 2.scrollView
    self.scrollView.width = self.width;
    self.scrollView.height = self.pageControl.y;
    self.scrollView.x = self.scrollView.y = 0;
    
    // 3.设置scrollView内每一页的尺寸
    NSUInteger count = self.scrollView.subviews.count;
    for (int i = 0; i < count; i++) {
        EmotionPageView *pageView = self.scrollView.subviews[i];
        pageView.width = self.scrollView.width;
        pageView.height = self.scrollView.height;
        pageView.x = i * pageView.width;
        pageView.y = 0;
    }
    
    // 4.设置scrollView的contentSize
    self.scrollView.contentSize = CGSizeMake(count * self.scrollView.width, 0);
}

#pragma mark - UIScrollViewDelegate的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double pageNo = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = (int)(pageNo + 0.5);
}

@end
