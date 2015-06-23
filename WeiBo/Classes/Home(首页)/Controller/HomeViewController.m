//
//  HomeViewController.m
//  WeiBo
//
//  Created by qianfeng on 15/6/12.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HomeViewController.h"
#import "DropdownMenu.h"
#import "TitleMenuViewController.h"
#import "TitleButton.h"
#import "AccountTool.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "User.h"
#import "Status.h"
#import "MJExtension.h"
#import "LoadMoreFooter.h"
#import "StatusCell.h"
#import "StatusFrame.h"

@interface HomeViewController () <DropdownMenuDelegate>
/**
 *  微博数组（里面放的都是HWStatus模型，一个HWStatus对象就代表一条微博）
 */
@property (nonatomic, strong) NSMutableArray *statusFrames;

@end

@implementation HomeViewController

// statuses数组的懒加载
- (NSMutableArray *)statusFrames
{
    if (!_statusFrames) {
        self.statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 设置tableview的背景色
    self.view.backgroundColor = WBColor(211, 211, 211);
    
    // 设置导航栏内容
    [self setupNav];
    
    // 获得用户信息(昵称)
    [self setupUserInfo];
    
    // 集成下拉刷新控件
    [self setupDownRefresh];
    
    // 集成上拉加载控件
    [self setupUpRefresh];
    
    NSTimer *time = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(setupUnreadCount) userInfo:nil repeats:YES];
    // 主线程也会抽时间处理一下timer（不管主线程是否正在其他事件）
    [[NSRunLoop mainRunLoop] addTimer:time forMode:NSRunLoopCommonModes];
}

// 获得未读取数
- (void)setupUnreadCount
{
    //网络请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 拼接请求参数
    Account *account = [AccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    [manager GET:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 将responseObject[@"status"]返回的对象转成字符串
        NSString *status = [responseObject[@"status"] description];
        if ([status isEqualToString:@"0"]) {
            self.tabBarItem.badgeValue = nil;
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        } else {
            self.tabBarItem.badgeValue = status;
            [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        WBLog(@"网络请求失败 -- %@", error);
    }];
}

// 集成上拉加载控件
- (void)setupUpRefresh
{
    LoadMoreFooter *footer = [LoadMoreFooter footer];
    footer.hidden = YES;
    self.tableView.tableFooterView = footer;
}
// 集成下拉刷新控件
- (void)setupDownRefresh
{
    // 1.创建刷新控件refresh
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    // 只有用户通过手动下拉刷新，才会触发UIControlEventValueChanged事件
    [refresh addTarget:self action:@selector(loadNewStatus:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refresh];
    
    // 2.马上进入刷新状态(仅仅是显示刷新状态，并不会触发UIControlEventValueChanged事件)
    [refresh beginRefreshing];
    // 3.马上加载数据
    [self loadNewStatus:refresh];
}
/**
 *  将Status模型转为StatusFrame模型
 */
- (NSArray *)stausFramesWithStatuses:(NSArray *)statuses
{
    NSMutableArray *frames = [NSMutableArray array];
    for (Status *status in statuses) {
        StatusFrame *f = [[StatusFrame alloc] init];
        f.status = status;
        [frames addObject:f];
    }
    return frames;
}
/**
 *  加载更多的微博数据
 */
- (void)loadMoreStatus
{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    Account *account = [AccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 取出最后面的微博（最新的微博，ID最大的微博）
    StatusFrame *lastStatusF = [self.statusFrames lastObject];
    if (lastStatusF) {
        // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型
        long long maxId = lastStatusF.status.idstr.longLongValue - 1;
        params[@"max_id"] = @(maxId);
    }
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [Status objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        // 将 Status数组 转为 newFrames数组
        NSArray *newFrames = [self stausFramesWithStatuses:newStatuses];
        
        // 将更多的微博数据，添加到总数组的最后面
        [self.statusFrames addObjectsFromArray:newFrames];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新(隐藏footer)
        self.tableView.tableFooterView.hidden = YES;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        WBLog(@"请求失败-%@", error);
        // 结束刷新
        self.tableView.tableFooterView.hidden = YES;
    }];
}

// 下拉刷新事件
- (void)loadNewStatus:(UIRefreshControl *)control
{
    // 网络请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    Account *account = [AccountTool account];
    params[@"access_token"] = account.access_token;
    
    // 取出最前面的微博（最新的微博，ID最大的微博）
    StatusFrame *firstStatusF = [self.statusFrames firstObject];
    if (firstStatusF) {
        // 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
        params[@"since_id"] = firstStatusF.status.idstr;
    }
    
    [manager GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 获得最新的微博数据(字典数组转成模型数组)
        NSArray *newStatuses = [Status objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        // 将 Status模型数组 转为 StatusFrame模型数组
        NSArray *newFrames = [self stausFramesWithStatuses:newStatuses];
        
        // 把最新的微博的数据插入到statuses数组的最前面
        NSRange range = NSMakeRange(0, newFrames.count);
        NSIndexSet *set = [[NSIndexSet alloc] initWithIndexesInRange:range];
        [self.statusFrames insertObjects:newFrames atIndexes:set];
        
        // 刷新tableView的Data
        [self.tableView reloadData];
        // 结束刷新
        [control endRefreshing];
        // 显示最新微博的数量
        [self showNewStatusCount:newStatuses.count];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 网络请求错误
        WBLog(@"请求失败%@", error);
        // 结束刷新
        [control endRefreshing];
    }];
}
/**
 *  显示最新的微博数量
 *  @param count 微博数量
 */
- (void)showNewStatusCount:(int)count
{
    self.tabBarItem.badgeValue = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.width = [UIScreen mainScreen].bounds.size.width;
    label.height = 33;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    
    if (count) {
        label.text = [NSString stringWithFormat:@"共有%d最新的微博数据", count];
    } else {
        label.text = @"没有最新的微博数据";
    }
    
    // 导航栏的高度
    CGFloat navigationBarHeight = 64;
    // label的y值
    label.y = navigationBarHeight - label.height;
    // 将label添加到self.navigationController.view(不能添加到window或者tableView上)
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    // 动画持续时间1.0s
    CGFloat duration = 1.0;
    [UIView animateWithDuration:duration animations:^{
        // 设置label的transfrom
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
    } completion:^(BOOL finished) {
        // 延迟时间1.3s
        CGFloat delay = 1.0;
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            // 将transform清零
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
            // 显示完毕之后将label从父视图中移除
            [label removeFromSuperview];
        }];
    }];
    
}
/**
 *  获得用户信息(昵称)
 */
- (void)setupUserInfo
{
    // 网络请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    Account *account = [AccountTool account];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    [manager GET:@"https://api.weibo.com/2/users/show.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 获得navigationItem的头部标题按钮
        UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
        // 字典转成模型
        User *user = [User objectWithKeyValues:responseObject];
        [titleButton setTitle:user.name forState:UIControlStateNormal];
        // 将昵称存入到沙盒中
        account.name = user.name;
        [AccountTool saveAccount:account];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        WBLog(@"网络请求错误 - %@", error);
    }];
}
/**
 *  设置导航栏内容
 */
- (void)setupNav
{
    // 设置导航栏左右按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(friendSearch) image:@"navigationbar_friendsearch" highlightedImage:@"navigationbar_friendsearch_highlighted"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pop) image:@"navigationbar_pop" highlightedImage:@"navigationbar_pop_highlighted"];
    
    TitleButton *titleButton = [[TitleButton alloc] init];
    // 取出沙盒中的昵称
    NSString *name = [AccountTool account].name;
    [titleButton setTitle:name?name:@"首页" forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleButton;
}
/**
 * 导航栏标题Btn的点击事件
 */
- (void)titleBtnClick:(UIButton *)titleButton
{
    DropdownMenu *menu = [DropdownMenu menu];
    menu.delegate = self;
    TitleMenuViewController *vc = [[TitleMenuViewController alloc] init];
    vc.view.height = 150;
    vc.view.width = 150;
    menu.contentController = vc;
    
    [menu showFrom:titleButton];
}

- (void)friendSearch
{
    WBLog(@"friendSearch");
}

- (void)pop
{
    WBLog(@"pop");
}

#pragma mark - DropdownMenuDelegate
- (void)DropdownMenuDidShow:(DropdownMenu *)Menu
{
    UIButton *titleBtn = (UIButton *)self.navigationItem.titleView;
    titleBtn.selected = YES;
}

- (void)DropdownMenuDidDismiss:(DropdownMenu *)Menu
{
    UIButton *titleBtn = (UIButton *)self.navigationItem.titleView;
    titleBtn.selected = NO;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusFrames.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatusFrame *frame = self.statusFrames[indexPath.row];
    return frame.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建cell
    StatusCell *cell = [StatusCell cellWithTableView:tableView];
    // 给cell传数据模型
    cell.statusFrame = self.statusFrames[indexPath.row];
    // 返回cell
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 如果tableView还没有数据，就直接返回
    if (self.statusFrames.count == 0 || self.tableView.tableFooterView.isHidden == NO) return;
    
    CGFloat offsetY = scrollView.contentOffset.y;
    // 当最后一个cell完全显示在眼前时，contentOffset的y值
    CGFloat judgeOffsetY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.height - self.tableView.tableFooterView.height;
    if (offsetY >= judgeOffsetY) { // 最后一个cell完全进入视野范围内
        // 显示footer
        self.tableView.tableFooterView.hidden = NO;
        // 加载更多的微博数据
        [self loadMoreStatus];
    }
}

@end
