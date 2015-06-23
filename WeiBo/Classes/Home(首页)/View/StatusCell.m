//
//  StatusCell.m
//  WeiBo
//
//  Created by qianfeng on 15/6/16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "StatusCell.h"
#import "Status.h"
#import "User.h"
#import "StatusFrame.h"
#import "UIImageView+WebCache.h"
#import "Photo.h"
#import "StatusToolbar.h"
#import "StatusPhotosView.h"
#import "IconView.h"

@interface StatusCell ()
// 原创微博
/** 原创微博整体*/
@property (nonatomic, weak) UIView *originalView;
/** 头像*/
@property (nonatomic, weak) IconView *iconView;
/** 会员头像*/
@property (nonatomic, weak) UIImageView *VIPView;
/** 配图*/
@property (nonatomic, weak) StatusPhotosView *photosView;
/** 昵称*/
@property (nonatomic, weak) UILabel *nameLabel;
/** 时间*/
@property (nonatomic, weak) UILabel *timeLabel;
/** 来源*/
@property (nonatomic, weak) UILabel *sourceLabel;
/** 正文*/
@property (nonatomic, weak) UILabel *contentLabel;

// 转发微博
/** 转发微博整体*/
@property (nonatomic, weak) UIView *retweetView;
/** 转发微博的配图*/
@property (nonatomic, weak) StatusPhotosView *retweetPhotosView;
/** 转发微博的正文 + 昵称*/
@property (nonatomic, weak) UILabel *retweetContentLabel;

// 底部工具条
/** 底部工具条 */
@property (nonatomic, weak) StatusToolbar *toolBarView;

@end

@implementation StatusCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"status";
    StatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[StatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

// 只创建添加cell中的子控件(不设置大小)
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // cell的背景颜色
        self.backgroundColor = [UIColor clearColor];
        // 点击cell不变颜色
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 初始化原创微博
        [self setupOriginal];
        // 初始化转发微博
        [self setupRetweet];
        // 初始化工具条
        [self setupToolBar];
    }
    return self;
}

/**
 *  初始化原创微博
 */
- (void)setupOriginal
{
    /** 原创微博整体*/
    UIView *originalView = [[UIView alloc] init];
    originalView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:originalView];
    self.originalView = originalView;
    
    /** 头像*/
    IconView *iconView = [[IconView alloc] init];
    [originalView addSubview:iconView];
    self.iconView = iconView;
    
    /** 会员图标*/
    UIImageView *VIPView= [[UIImageView alloc] init];
    VIPView.contentMode = UIViewContentModeCenter;
    [originalView addSubview:VIPView];
    self.VIPView = VIPView;
    
    /** 配图*/
    StatusPhotosView *photosView= [[StatusPhotosView alloc] init];
    [originalView addSubview:photosView];
    self.photosView = photosView;
    
    /** 昵称*/
    UILabel *nameLabel= [[UILabel alloc] init];
    nameLabel.font = StatusCellNameFont;
    [originalView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    /** 时间*/
    UILabel *timeLabel= [[UILabel alloc] init];
    timeLabel.font = StatusCellTimeFont;
    timeLabel.textColor = [UIColor orangeColor];
    [originalView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    /** 来源*/
    UILabel *sourceLabel= [[UILabel alloc] init];
    sourceLabel.font = StatusCellSourceFont;
    [originalView addSubview:sourceLabel];
    self.sourceLabel = sourceLabel;
    
    /** 正文*/
    UILabel *contentLabel= [[UILabel alloc] init];
    contentLabel.font = StatusCellContentFont;
    contentLabel.numberOfLines = 0;
    [originalView addSubview:contentLabel];
    self.contentLabel = contentLabel;
}
/**
 *  初始化被转发微博
 */
- (void)setupRetweet
{
    /** 转发微博整体*/
    UIView *retweetView = [[UIView alloc] init];
    retweetView.backgroundColor = WBColor(248, 248, 248);
    [self.contentView addSubview:retweetView];
    self.retweetView = retweetView;
    
    /** 转发微博正文*/
    UILabel *retweetContentLabel = [[UILabel alloc] init];
    retweetContentLabel.numberOfLines = 0;
    retweetContentLabel.font = StatusCellRetweetContentFont;
    [self.retweetView addSubview:retweetContentLabel];
    self.retweetContentLabel = retweetContentLabel;
    
    /** 转发微博配图*/
    StatusPhotosView *retweetPhotosView = [[StatusPhotosView alloc] init];
    [self.retweetView addSubview:retweetPhotosView];
    self.retweetPhotosView = retweetPhotosView;
}

/**
 * 初始化底部工具条
 */
- (void)setupToolBar
{
    StatusToolbar *toolBarView = [StatusToolbar toolbar];
    [self.contentView addSubview:toolBarView];
    self.toolBarView = toolBarView;
}

// 在给statusFrame数据模型赋值的 同时 给cell中的子控件设置大小和内容
- (void)setStatusFrame:(StatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    /** 原创微博数据模型 */
    Status *status = statusFrame.status;
    /** 原创微博作者数据模型 */
    User *user = status.user;
    
    /** 原创微博整体 */
    self.originalView.frame = statusFrame.originalViewF;
    
    /** 头像 */
    self.iconView.frame = statusFrame.iconViewF;
    self.iconView.user = user;
    
    /** VIP图标 */
    if (user.isVip) {
        self.VIPView.hidden = NO;
        self.VIPView.frame = statusFrame.VIPViewF;
        NSString *vipName = [NSString stringWithFormat:@"common_icon_membership_level%d", user.mbrank];
        self.VIPView.image = [UIImage imageNamed:vipName];
        self.nameLabel.textColor = [UIColor orangeColor];
    } else {
        self.VIPView.hidden = YES;
        self.nameLabel.textColor = [UIColor blackColor];
    }
    
    /** 配图 */
    if (status.pic_urls.count) {
        self.photosView.frame = statusFrame.photosViewF;
        
        self.photosView.photos = status.pic_urls;
        
        self.photosView.hidden = NO;
    } else {
        self.photosView.hidden = YES;
    }
    
    /** 昵称*/
    self.nameLabel.text = user.name;
    self.nameLabel.frame = statusFrame.nameLabelF;
    
    /** 重新计算"时间"的大小 */
    NSString *time = status.created_at;
    CGFloat timeX = statusFrame.nameLabelF.origin.x;
    CGFloat timeY = CGRectGetMaxY(statusFrame.nameLabelF) + StatusCellBorderW;
    CGSize timeSize = [time sizeWithFont:StatusCellTimeFont];
    self.timeLabel.frame = (CGRect){{timeX, timeY}, timeSize};
    self.timeLabel.text = time;
    
    /** 重新计算"来源"的大小 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabel.frame) + StatusCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:StatusCellSourceFont];
    self.sourceLabel.frame = (CGRect){{sourceX, sourceY}, sourceSize};
    self.sourceLabel.text = status.source;
    
    /** 正文 */
    self.contentLabel.frame = statusFrame.contentLabelF;
    self.contentLabel.text = status.text;
    
    /** 被转发的微博 */
    if (status.retweeted_status) {
        /** 被转发微博数据模型 */
        Status *retweet_status = status.retweeted_status;
        /** 被转发用户数据模型 */
        User *retweet_status_user = retweet_status.user;
        
        /** 被转发的微博整体 */
        // 显示被转发的微博整体
        self.retweetView.hidden = NO;
        self.retweetView.frame = statusFrame.retweetViewF;
        
        /** 被转发的微博正文 */
        NSString *retweetContent = [NSString stringWithFormat:@"@%@:%@", retweet_status_user.name, retweet_status.text];
        self.retweetContentLabel.text = retweetContent;
        self.retweetContentLabel.frame = statusFrame.retweetContentLabelF;
        
        /** 被转发的微博配图 */
        if (retweet_status.pic_urls.count) {
            // 设置retweetPhotoView的frame
            self.retweetPhotosView.frame = statusFrame.retweetPhotosViewF;
            
            self.retweetPhotosView.photos = retweet_status.pic_urls;
            
            // 显示被转发微博的配图
            self.retweetPhotosView.hidden = NO;
        } else {
            // 隐藏被转发的微博配图
            self.retweetPhotosView.hidden = YES;
        }
    } else {
        // 隐藏被转发的微博整体(cell的复用机制,必须成对的出现!!!)
        self.retweetView.hidden = YES;
    }
    
    // 工具条
    self.toolBarView.frame = statusFrame.toolBarViewF;
    self.toolBarView.status = status;
}

@end
