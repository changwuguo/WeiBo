//
//  ComposePhotosView.m
//  WeiBo
//
//  Created by qianfeng on 15/6/19.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ComposePhotosView.h"

@implementation ComposePhotosView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _photos = [NSMutableArray array];
    }
    return self;
}
/**
 *  添加图片
 */
- (void)addPhoto:(UIImage *)photo
{
    UIImageView *photoView = [[UIImageView alloc] init];
    photoView.image = photo;
    [self addSubview:photoView];
    
    [_photos addObject:photo];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片的尺寸和位置
    NSUInteger count = self.subviews.count;
    int maxCol = 3;
    CGFloat imageWH = 100;
    CGFloat imageMargin = 10;
    
    for (int i = 0; i<count; i++) {
        UIImageView *photoView = self.subviews[i];
        
        int col = i % maxCol;
        photoView.x = col * (imageWH + imageMargin);
        
        int row = i / maxCol;
        photoView.y = row * (imageWH + imageMargin);
        photoView.width = imageWH;
        photoView.height = imageWH;
    }
}

@end
