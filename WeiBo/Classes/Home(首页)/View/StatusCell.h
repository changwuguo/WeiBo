//
//  StatusCell.h
//  WeiBo
//
//  Created by qianfeng on 15/6/16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StatusFrame;

@interface StatusCell : UITableViewCell

@property (nonatomic, strong) StatusFrame *statusFrame;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
