//
//  LoadMoreFooter.m
//  WeiBo
//
//  Created by qianfeng on 15/6/16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "LoadMoreFooter.h"

@implementation LoadMoreFooter

+(instancetype)footer
{
    return [[[NSBundle mainBundle] loadNibNamed:@"LoadMoreFooter" owner:nil options:nil] lastObject];
}
@end
