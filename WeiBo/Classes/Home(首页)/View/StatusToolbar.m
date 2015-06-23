//
//  StatusToolbar.m
//  WeiBo
//
//  Created by qianfeng on 15/6/17.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "StatusToolbar.h"
#import "Status.h"

@interface StatusToolbar()
/**
 *  存放按钮的数组
 */
@property (nonatomic, strong) NSMutableArray *btns;
/**
 *  存放分割线的数组
 */
@property (nonatomic, strong) NSMutableArray *dividers;

@property (nonatomic, weak) UIButton *repostBtn;
@property (nonatomic, weak) UIButton *commentBtn;
@property (nonatomic, weak) UIButton *attitudeBtn;

@end

@implementation StatusToolbar

// 初始化btns数组(懒加载)
-(NSMutableArray *)btns
{
    if (!_btns) {
        self.btns = [NSMutableArray array];
    }
    return _btns;
}
// 初始化dividers数组(懒加载)
- (NSMutableArray *)dividers
{
    if (!_dividers) {
        self.dividers = [NSMutableArray array];
    }
    return _dividers;
}
/**
 *  初始化底部工具条(类方法)
 */
+(instancetype)toolbar
{
    return [[self alloc] init];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加背景图片
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_card_bottom_background"]];
        // 添加按钮
        self.repostBtn = [self setupBtn:@"转发" icon:@"timeline_icon_retweet"];
        self.commentBtn = [self setupBtn:@"评论" icon:@"timeline_icon_comment"];
        self.attitudeBtn = [self setupBtn:@"赞" icon:@"timeline_icon_unlike"];
        // 添加分割线
        [self setupDivider];
        [self setupDivider];
    }
    return self;
}

/**
 *  初始化一个按钮
 *
 *  @param title 文字
 *  @param icon  图片地址
 */
- (UIButton *)setupBtn:(NSString *)title icon:(NSString *)icon
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    [self addSubview:btn];
    [self.btns addObject:btn];
    return btn;
}

/**
 *  初始化一条分割线
 */
- (void)setupDivider
{
    UIImageView *divider = [[UIImageView alloc] init];
    divider.image = [UIImage imageNamed:@"timeline_card_bottom_line"];
    [self addSubview:divider];
    
    [self.dividers addObject:divider];
}

/**
 *  布局按钮和分割线
 */
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    int btnCount = self.btns.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    for (int i = 0; i < btnCount; i++) {
        UIButton *btn = self.btns[i];
        btn.y = 0;
        btn.x = i * btnW;
        btn.width = btnW;
        btn.height = btnH;
    }
    
    int dividerCount = self.dividers.count;
    for (int i = 0; i < dividerCount; i++) {
        UIImageView *divider = self.dividers[i];
        divider.width = 1;
        divider.height = self.height;
        divider.x = (i + 1) * btnW;
        divider.y = 0;
    }
}

/**
 *  给Btn上的Label设置数字或者文字
 *
 *  @param status 微博数据模型
 */
- (void)setStatus:(Status *)status
{
    _status = status;
    
    // 转发
    [self setupBtnCount:status.reposts_count button:self.repostBtn title:@"转发"];
    // 评论
    [self setupBtnCount:status.comments_count button:self.commentBtn title:@"评论"];
    // 赞
    [self setupBtnCount:status.attitudes_count button:self.attitudeBtn title:@"赞"];
}

- (void)setupBtnCount:(int)count button:(UIButton *)btn title:(NSString *)title
{
    if (count) { // count不为0;
        if (count < 10000) { // count不足10000,显示实际数字
            title = [NSString stringWithFormat:@"%d", count];
        } else { // count大于或等于10000, 显示近似数字(12345:12.3万, 10234:1万)
            double wan = count / 10000.0;
            title = [NSString stringWithFormat:@"%.1f万", wan];
            // 将title中的".0"替换成"";
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
    }
    [btn setTitle:title forState:UIControlStateNormal];
}

@end
