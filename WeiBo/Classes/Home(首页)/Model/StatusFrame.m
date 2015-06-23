//
//  StatusFrame.m
//  WeiBo
//
//  Created by qianfeng on 15/6/16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "StatusFrame.h"
#import "Status.h"
#import "User.h"
#import "StatusPhotosView.h"

@implementation StatusFrame

// status的setter方法
-(void)setStatus:(Status *)status
{
    _status = status;
    User *user = status.user;
    
    // cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /** 头像 */
    CGFloat iconWH = 35;
    CGFloat iconX = StatusCellBorderW;
    CGFloat iconY = StatusCellBorderW;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + StatusCellBorderW;
    CGFloat nameY = iconY;
    CGSize nameSize = [user.name sizeWithFont:StatusCellNameFont];
    self.nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    
    /** 会员图标 */
    if (user.isVip) {
        CGFloat vipX = CGRectGetMaxX(self.nameLabelF) + StatusCellBorderW;
        CGFloat vipY = nameY;
        CGFloat vipH = nameSize.height;
        CGFloat vipW = 15 ;
        self.VIPViewF = CGRectMake(vipX, vipY, vipW, vipH);
    }
    
    /** 时间 */
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelF) + StatusCellBorderW;
    CGSize timeSize = [status.created_at sizeWithFont:StatusCellTimeFont];
    self.timeLabelF = (CGRect){{timeX, timeY}, timeSize};
    
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelF) + StatusCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:StatusCellSourceFont];
    self.sourceLabelF = (CGRect){{sourceX, sourceY}, sourceSize};
    
    /** 正文 */
    CGFloat contentX = iconX;
    CGFloat contentY = MAX(CGRectGetMaxY(self.iconViewF), CGRectGetMaxY(self.timeLabelF)) + StatusCellBorderW;
    CGFloat maxW = cellW - 2 * contentX;
    CGSize contentSize = [status.text sizeWithFont:StatusCellContentFont maxW:maxW];
    self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};
    
    /** 配图 */
    CGFloat originalH = 0;
    if (status.pic_urls.count) {
        CGFloat photosX = contentX;
        CGFloat photosY = CGRectGetMaxY(self.contentLabelF) + StatusCellBorderW;
        CGSize photosSize = [StatusPhotosView sizeWithCount:status.pic_urls.count];
        self.photosViewF =(CGRect){{photosX, photosY}, photosSize};
        
        // 原创微博整体的高度
        originalH = CGRectGetMaxY(self.photosViewF) + StatusCellBorderW;
    } else {
        // 原创微博整体的高度
        originalH = CGRectGetMaxY(self.contentLabelF) + StatusCellBorderW;
    }
    
    /** 原创微博整体 */
    CGFloat originalX = 0;
    CGFloat originalY = StatusCellMargin;
    CGFloat originalW = cellW;
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH);
    
     /** 被转发微博 */
    CGFloat toolBarViewY = 0;
    if (status.retweeted_status) {
        /** 被转发微博数据模型 */
        Status *retweet_status = status.retweeted_status;
        /** 被转发用户数据模型 */
        User *retweet_status_user = retweet_status.user;
        
        /** 被转发微博的正文 */
        CGFloat retweetContentX = StatusCellBorderW;
        CGFloat retweetContentY = StatusCellBorderW;
        NSString *retweetContent = [NSString stringWithFormat:@"@%@:%@", retweet_status_user.name, retweet_status.text];
        CGSize retweetContentSize = [retweetContent sizeWithFont:StatusCellRetweetContentFont maxW:maxW];
        self.retweetContentLabelF = (CGRect){{retweetContentX, retweetContentY},retweetContentSize};
        
        /** 被转发微博的配图 */
        CGFloat retweetViewH = 0;
        if (retweet_status.pic_urls.count) { // 转发的微博有配图
            CGFloat retweetPhotosX = retweetContentX;
            CGFloat retweetPhotosY = CGRectGetMaxY(self.retweetContentLabelF) + StatusCellBorderW;
            CGSize retweetPhotosSize = [StatusPhotosView sizeWithCount:retweet_status.pic_urls.count];
            self.retweetPhotosViewF = (CGRect){{retweetPhotosX, retweetPhotosY}, retweetPhotosSize};
            // 被转发微博整体的height
            retweetViewH = CGRectGetMaxY(self.retweetPhotosViewF) + StatusCellBorderW;
        } else { // 转发的微博没有配图
            // 被转发微博整体的height
            retweetViewH = CGRectGetMaxY(self.retweetContentLabelF) + StatusCellBorderW;
        }
        
        /** 被转发微博整体 */
        CGFloat retweetViewX = 0;
        CGFloat retweetViewY = CGRectGetMaxY(self.originalViewF);
        CGFloat retweetViewW = cellW;
        self.retweetViewF = CGRectMake(retweetViewX, retweetViewY, retweetViewW, retweetViewH);
        toolBarViewY = CGRectGetMaxY(self.retweetViewF);
    } else {
        toolBarViewY = CGRectGetMaxY(self.originalViewF);
    }
    
    /** 工具条的尺寸 */
    CGFloat toolBarViewX = 0;
    CGFloat toolBarViewW = cellW;
    CGFloat toolBarViewH = 35;
    self.toolBarViewF = CGRectMake(toolBarViewX, toolBarViewY, toolBarViewW, toolBarViewH);
    
    // cell的高度
    self.cellHeight = CGRectGetMaxY(self.toolBarViewF);
}

@end
