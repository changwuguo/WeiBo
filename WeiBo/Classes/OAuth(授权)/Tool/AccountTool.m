//
//  AccountTool.m
//  WeiBo
//
//  Created by qianfeng on 15/6/15.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#define AccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

#import "AccountTool.h"
#import "Account.h"

@implementation AccountTool

+(void)saveAccount:(Account *)account
{
    account.created_time = [NSDate date];
    [NSKeyedArchiver archiveRootObject:account toFile:AccountPath];
}

+ (Account *)account
{
    // 加载模型
    Account *account = [NSKeyedUnarchiver unarchiveObjectWithFile:AccountPath];
    
    /* 验证账号是否过期 */
    // 过期的秒数
    long long expires_in = [account.expires_in longLongValue];
    // 获得过期时间
    NSDate *expiresTime = [account.created_time dateByAddingTimeInterval:expires_in];
    // 获得当前时间
    NSDate *now = [NSDate date];
    
    NSComparisonResult result = [expiresTime compare:now];
    if (result != NSOrderedDescending) { // 过期
        return nil;
    }
    return account;
}

@end
