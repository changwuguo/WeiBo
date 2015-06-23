//
//  Status.m
//  WeiBo
//
//  Created by qianfeng on 15/6/15.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "Status.h"
#import "Photo.h"
#import "MJExtension.h"

@implementation Status

// MJExtension中的数组中存放的对象类型
- (NSDictionary *)objectClassInArray
{
    return @{@"pic_urls":[Photo class]};
}

// "创建时间"的getter方法
- (NSString *)created_at
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 如果是真机调试,转换这种欧美实际,需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    // 设置日期格式（声明字符串里面每个数字和单词的含义）E:星期几 M:月份 d:几号(这个月的第几天) H:24小时制的小时 m:分钟 s:秒 y:年
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    
    // 微博的创建日期
    NSDate *createDate = [fmt dateFromString:_created_at];
    // 现在的时间
    NSDate *now = [NSDate date];
    
    // 日历对象(方便比较2个日期之间的差距)
    NSCalendar *caledar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour |NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算2个日期之间的差值
    NSDateComponents *cmps = [caledar components:unit fromDate:createDate toDate:now options:0];
    
    if ([createDate isThisYear]) { // 今年
        if ([createDate isYesterday]) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createDate];
        } else if ([createDate isToday]) { // 今天
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%d小时前", cmps.hour];
            } else if (cmps.minute >= 1) {
                return [NSString stringWithFormat:@"%d分钟前", cmps.minute];
            } else {
                return @"刚刚";
            }
        } else { // 今年的其他日子
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createDate];
    }
}

// "来源"的setter方法
// "source": "<a href="http://weibo.com" rel="nofollow">新浪微博</a>",
- (void)setSource:(NSString *)source
{
//    NSRange range;
//    range.location = [source rangeOfString:@">"].location + 1;
// // range.length = [source rangeOfString:@"</"].location - range.location;
//    range.length = [source rangeOfString:@"<" options:NSBackwardsSearch].location - range.location;
//    _source = [NSString stringWithFormat:@"来自%@", [source substringWithRange:range]];
//
      _source = @"来自 iPhone 6 Plus";
}

@end
