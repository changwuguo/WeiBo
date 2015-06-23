//
//  StatusFrame.h
//  WeiBo
//
//  Created by qianfeng on 15/6/16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

// 昵称字体
#define StatusCellNameFont [UIFont systemFontOfSize:13]
// 时间字体
#define StatusCellTimeFont [UIFont systemFontOfSize:11]
// 来源字体
#define StatusCellSourceFont [UIFont systemFontOfSize:11]
// 正文字体
#define StatusCellContentFont [UIFont systemFontOfSize:14]

// 被转发微博的正文字体
#define StatusCellRetweetContentFont [UIFont systemFontOfSize:13]

// cell的边框宽度
#define StatusCellBorderW 10
#define StatusCellMargin 10

@class Status;

@interface StatusFrame : NSObject

/** 微博数据模型*/
@property (nonatomic, strong) Status *status;

/** 原创微博整体*/
@property (nonatomic, assign) CGRect originalViewF;
/** 头像*/
@property (nonatomic, assign) CGRect iconViewF;
/** 会员头像*/
@property (nonatomic, assign) CGRect VIPViewF;
/** 配图*/
@property (nonatomic, assign) CGRect photosViewF;
/** 昵称*/
@property (nonatomic, assign) CGRect nameLabelF;
/** 时间*/
@property (nonatomic, assign) CGRect timeLabelF;
/** 来源*/
@property (nonatomic, assign) CGRect sourceLabelF;
/** 正文*/
@property (nonatomic, assign) CGRect contentLabelF;

// 转发微博
/** 转发微博整体*/
@property (nonatomic, assign) CGRect retweetViewF;
/** 转发微博的配图*/
@property (nonatomic, assign) CGRect retweetPhotosViewF;
/** 转发微博的正文 + 昵称*/
@property (nonatomic, assign) CGRect retweetContentLabelF;

// 工具条
@property (nonatomic, assign) CGRect toolBarViewF;

/** cell的高度*/
@property (nonatomic ,assign) CGFloat cellHeight;

@end
