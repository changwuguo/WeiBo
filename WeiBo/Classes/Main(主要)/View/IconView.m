//
//  IconView.m
//  WeiBo
//
//  Created by qianfeng on 15/6/18.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "IconView.h"
#import "User.h"
#import "UIImageView+WebCache.h"

@interface IconView()

@property (nonatomic, weak) UIImageView *verifiedView;

@end

@implementation IconView

// 初始化verifiedView(懒加载)
- (UIImageView *)verifiedView
{
    if (!_verifiedView) {
        UIImageView *verifiedView = [[UIImageView alloc] init];
        [self addSubview:verifiedView];
        self.verifiedView = verifiedView;
    }
    return _verifiedView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
// user数据模型的setter方法
- (void)setUser:(User *)user
{
    _user = user;
    
    [self sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    switch (user.verified_type) {
        case UserVerifiedPersonal: // 个人认证
            self.verifiedView.image = [UIImage imageNamed:@"avatar_vip"];
            self.verifiedView.hidden = NO;
            break;
        case UserVerifiedOrgEnterprice:
        case UserVerifiedOrgMedia:
        case UserVerifiedOrgWebsite: // 官方认证
            self.verifiedView.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            self.verifiedView.hidden = NO;
            break;
        case UserVerifiedDaren: // 微博达人
            self.verifiedView.image = [UIImage imageNamed:@"avatar_grassroot"];
            self.verifiedView.hidden = NO;
            break;
        default:
            self.verifiedView.hidden = YES;
            break;
    }
}
// 设置verifiedView的size和x,y(注意:size必须要先设置,因为verifiedView的x,y用到了size)
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat scale = 0.6;
    self.verifiedView.size = self.verifiedView.image.size;
    self.verifiedView.x = self.width - self.verifiedView.width * scale;
    self.verifiedView.y = self.height - self.verifiedView.height * scale;
}

@end
