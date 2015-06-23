//
//  ComposeToolbar.h
//  WeiBo
//
//  Created by qianfeng on 15/6/19.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    ComposeToolbarButtonTypeCamera, // 拍照
    ComposeToolbarButtonTypePicture, // 相册
    ComposeToolbarButtonTypeMention, // @
    ComposeToolbarButtonTypeTrend, // #
    ComposeToolbarButtonTypeEmotion // 表情

} ComposeToolbarButtonType;

@class ComposeToolbar;

@protocol ComposeToolbarDelegate <NSObject>

@optional

- (void)composeToolbar:(ComposeToolbar *)toolbar didCilckBtn:(ComposeToolbarButtonType)buttonType;

@end

@interface ComposeToolbar : UIView

@property (nonatomic, weak) id <ComposeToolbarDelegate> delegate;

@property (nonatomic ,assign) BOOL showKeyboarBarButton;

@end
