//
//  Emotion.m
//  WeiBo
//
//  Created by qianfeng on 15/6/20.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "Emotion.h"

@interface Emotion () <NSCoding>

@end

@implementation Emotion

/**
 *  从文件中解析对象时调用
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.chs = [decoder decodeObjectForKey:@"chs"];
        self.png = [decoder decodeObjectForKey:@"png"];
        self.code = [decoder decodeObjectForKey:@"code"];
    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.chs forKey:@"chs"];
    [encoder encodeObject:self.png forKey:@"png"];
    [encoder encodeObject:self.code forKey:@"code"];
}

/**
 *  常用来比较两个HWEmotion对象是否一样(比较的是内存地址,并不是内容),重写之后把它改为比较的是内容是否相等
 *
 *  @param other 另外一个HWEmotion对象
 *
 *  @return YES : 代表2个对象是一样的，NO: 代表2个对象是不一样
 */
- (BOOL)isEqual:(Emotion *)other
{
    return [self.chs isEqualToString:other.chs] || [self.code isEqualToString:other.code];
}

@end
