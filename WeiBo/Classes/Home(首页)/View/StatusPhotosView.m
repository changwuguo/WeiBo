//
//  StatusPhotosView.m
//  WeiBo
//
//  Created by qianfeng on 15/6/18.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "StatusPhotosView.h"
#import "Photo.h"
#import "StatusPhotoView.h"

#define StatusPhotosWH 60
#define StatusPhotosMargin 5

// 当photos数组中元素个数等于4时,显示成"田"字型
#define StatusPhotosMaxCol(count) ((count == 4)?2:3)

@implementation StatusPhotosView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

/**
 *  根据传进来的photos数组设置photoView的图片
 *  @param photos 存储photo数据模型的数组
 */
-(void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    // 获得photos数组的大小
    NSUInteger photosCount = photos.count;
    
    // 循环创建photoView(在cell复用的时候,如果self.subviews.count < photosCount,就创建photosCount - self.subviews.count个photoView,相反就直接跳过)
    while (self.subviews.count < photosCount) {
        StatusPhotoView *photoView = [[StatusPhotoView alloc] init];
        [self addSubview:photoView];
    }
    
    for (int i = 0; i < self.subviews.count; i++) {
        // 得到所有的photoView
        StatusPhotoView *photoView = self.subviews[i];
        if (i < photosCount) { // 只显示photosCount - 1个photoView(cell复用机制)
            // 取出模型
            photoView.photo = photos[i];
            // 显示photoView
            photoView.hidden = NO;
        } else { // 隐藏剩下的photoView(cell复用机制)
            photoView.hidden = YES;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int photoCount = self.photos.count;
    // 当photos数组中元素个数等于4时,显示成"田"字型
    int maxCol = StatusPhotosMaxCol(photoCount);
    for (int i = 0; i < photoCount; i++) {
        StatusPhotoView *photoView = self.subviews[i];
    
        int col = i % maxCol;
        photoView.x = col * (StatusPhotosWH + StatusPhotosMargin);
        int row = i / maxCol;
        photoView.y = row * (StatusPhotosWH + StatusPhotosMargin);
        photoView.width = StatusPhotosWH;
        photoView.height = StatusPhotosWH;
    }
}

/**
 *  根据图片个数计算相册尺寸
 */
+ (CGSize)sizeWithCount:(int)count
{
    int maxCols = StatusPhotosMaxCol(count);
    // 列数
    int cols = (count > 2) ? maxCols : count;
    CGFloat photosW = cols * StatusPhotosWH + (cols - 1) * StatusPhotosMargin;
    
    // 行数
    int row = (count + maxCols - 1) / maxCols;
    CGFloat photosH = row * StatusPhotosWH + (row - 1) * StatusPhotosMargin;
    
    return CGSizeMake(photosW, photosH);
}


@end
