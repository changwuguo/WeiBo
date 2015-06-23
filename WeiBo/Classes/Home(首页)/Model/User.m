//
//  User.m
//  WeiBo
//
//  Created by qianfeng on 15/6/15.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "User.h"

@implementation User

- (void)setMbtype:(int)mbtype
{
    _mbtype = mbtype;
    
    self.vip = mbtype > 2;
}

@end
