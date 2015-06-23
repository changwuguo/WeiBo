//
//  AccountTool.h
//  WeiBo
//
//  Created by qianfeng on 15/6/15.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

@interface AccountTool : NSObject

/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+(void)saveAccount:(Account *)account;

/**
 *  返回账号信息
 *
 *  @return 账号信息(如果账号信息过期,返回nil)
 */
+(Account *)account;

@end
