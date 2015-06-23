//
//  ComposeViewController.m
//  WeiBo
//
//  Created by qianfeng on 15/6/19.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ComposeViewController.h"
#import "AccountTool.h"
#import "EmotionTextView.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "ComposeToolbar.h"
#import "ComposePhotosView.h"
#import "EmotionKeyboard.h"
#import "Emotion.h"

@interface ComposeViewController () <UITextViewDelegate, ComposeToolbarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
/**
 *  输入控件
 */
@property (nonatomic, weak) EmotionTextView *textView;
/**
 *  工具条
 */
@property (nonatomic, weak) ComposeToolbar *toolBar;
/**
 *  相册
 */
@property (nonatomic, weak) ComposePhotosView *photosView;

#warning 一定要用strong强引用
/**
 *  表情键盘
 */
@property (nonatomic, strong) EmotionKeyboard *emotionKeyboard;

@property (nonatomic ,assign) BOOL switchingKeybaord;

@end

@implementation ComposeViewController
#pragma mark - 初始化方法
// 只创建一个emotionKeyboard(懒加载)
-(EmotionKeyboard *)emotionKeyboard
{
    if (!_emotionKeyboard) {
        self.emotionKeyboard =[[EmotionKeyboard alloc] init];
        self.emotionKeyboard.width = self.view.width;
        self.emotionKeyboard.height = 216;
    }
    return _emotionKeyboard;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏
    [self setupNav];
    // 添加TextView
    [self setupTextView];
    // 添加工具条
    [self setupToolBar];
    // 创建相册
    [self setupPhotosView];
}
/**
 * 设置导航栏
 */
- (void)setupNav
{
    // 设置"取消"
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancal)];
    // 设置"发送"
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    // 用户的昵称
    NSString *name = [AccountTool account].name;
    NSString *prefix = @"发微博";
    if (name) { // 昵称存在
        UILabel *titleView = [[UILabel alloc] init];
        titleView.width = 200;
        titleView.height = 100;
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.numberOfLines = 0;
        titleView.y = 50;
        
        NSString *str = [NSString stringWithFormat:@"%@\n%@", prefix, name];
        // 创建一个带有属性的字符串
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        // 设置prefix的文字属性
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:[str rangeOfString:prefix]];
        // 设置name的文字属性
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:name]];
        titleView.attributedText = attrStr;
        self.navigationItem.titleView = titleView;
    } else { // 昵称不存在
        self.navigationItem.title = prefix;
    }
}

/**
 *  添加输入控件
 */
- (void)setupTextView
{
    EmotionTextView *textView = [[EmotionTextView alloc] init];
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:15];
    textView.placeholderText = @"分享新鲜事...";
    textView.placeholderColor = [UIColor darkGrayColor];
    // 设置textView一直能垂直滚动
    textView.alwaysBounceVertical = YES;
    textView.delegate = self;
    [self.view addSubview:textView];
    self.textView = textView;
    
    // 监听textView的文字改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
    
    // 监听键盘的升起和退出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 监听表情按钮的点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelect:) name:WBEmotionDidSelectNotification object:nil];
    
    // 监听删除按钮的点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidDelete) name:WBEmotionDidDeleteNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 让textView成为第一响应者
    [self.textView becomeFirstResponder];
}

/**
 *  添加工具条
 */
- (void)setupToolBar
{
    ComposeToolbar *toolBar = [[ComposeToolbar alloc] init];
    toolBar.width = self.view.width;
    toolBar.height = 44;
    toolBar.x = 0;
    toolBar.y = self.view.height - toolBar.height;
    toolBar.delegate = self;
    [self.view addSubview:toolBar];
    self.toolBar = toolBar;
}

/**
 *  创建相册
 */
- (void)setupPhotosView
{
    ComposePhotosView *photosView = [[ComposePhotosView alloc] init];
    photosView.y = 100;
    photosView.width = self.view.width;
    photosView.height = self.view.height;
    [self.textView addSubview:photosView];
    self.photosView = photosView;
}

#pragma mark - 按钮点击事件
/**
 *  取消返回
 */
- (void)cancal
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  发送微博
 */
- (void)send
{
    if (self.photosView.photos.count) {
        [self sendWithImageStatus];
    } else {
        [self sendWithoutimageStatus];
    }
    // dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  没有图片的微博
 */
- (void)sendWithoutimageStatus
{
    // 请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"status"] = self.textView.fullText;
    params[@"access_token"] = [AccountTool account].access_token;
    // 发送请求
    [manager POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD showSuccess:@"微博发布成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"微博发布失败"];
    }];
    
}
/**
 *  有图片的微博
 */
- (void)sendWithImageStatus
{
    // 请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"status"] = self.textView.fullText;
    params[@"access_token"] = [AccountTool account].access_token;
    
    // 发送请求
    [manager POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 拿到相册数组中的图片
        UIImage *image = [self.photosView.photos firstObject];
        // 将拿到的图片转化成NSData
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        [formData appendPartWithFileData:imageData name:@"pic" fileName:@"1.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD showSuccess:@"微博发布成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showSuccess:@"微博发布失败"];
    }];
}

#pragma mark - 监听方法
// 监听textView文字的改变,从而改变rightBarButtonItem的enabled
- (void)textDidChange
{
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}

/**
 *  键盘的frame发生改变时调用（显示、隐藏等)
 */
- (void)keyboardWillChangeFrame:(NSNotification *)noti
{   // 控制工具条不能移动
    if (self.switchingKeybaord) return;
    
    NSDictionary *dict = noti.userInfo;
    // 动画执行的时间
    double duration = [dict[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyBoardF = [dict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        if (keyBoardF.origin.y > self.view.height) {
            self.toolBar.y = self.view.height - self.toolBar.height;
        } else {
            self.toolBar.y = keyBoardF.origin.y - self.toolBar.height;
        }
    }];
}
/**
 *  表情按钮点击后,往textView内插入对应的表情
 */
- (void)emotionDidSelect:(NSNotification *)notification
{
    Emotion *emotion = notification.userInfo[WBSelectEmotionKey];
    
    [self.textView insertEmotion:emotion];
    
}
/**
 *  删除按钮点击后,删除textView内插入对应的表情或文字
 */
- (void)emotionDidDelete
{
    [self.textView deleteBackward];
}

#pragma mark - UITextViewDelegate
/**
 *  textView开始拖拽的时候让键盘退出
 */
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.textView endEditing:YES];
}

// 移除监听者
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// composeToolbarDelegate代理方法
- (void)composeToolbar:(ComposeToolbar *)toolbar didCilckBtn:(ComposeToolbarButtonType)buttonType
{
    switch (buttonType) {
        case ComposeToolbarButtonTypeCamera: // 拍照
            [self openCamera];
            break;
            
        case ComposeToolbarButtonTypePicture: // 相册
            [self openAlbum];
            break;
            
        case ComposeToolbarButtonTypeMention: // @
            WBLog(@"--- @");
            break;
            
        case ComposeToolbarButtonTypeTrend: // #
            WBLog(@"--- #");
            break;
            
        case ComposeToolbarButtonTypeEmotion: // 表情\键盘
            [self setupEmotionKeyboard];
            break;
    }
}
/**
 *  表情\键盘的切换
 */
- (void)setupEmotionKeyboard
{
    // 当self.textView.inputView == nil时,默认就是系统的键盘
    if (self.textView.inputView == nil) {
        self.textView.inputView = self.emotionKeyboard;
        self.toolBar.showKeyboarBarButton = YES;
    } else {
        self.textView.inputView = nil;
        self.toolBar.showKeyboarBarButton = NO;
    }
    // 保证在键盘的frame改变的时候,工具条的位置不变
    self.switchingKeybaord = YES;
    // 退出键盘
    [self.textView endEditing:YES];
    
    self.switchingKeybaord = NO;
    // 延迟调用,0.1s后重新弹出新的键盘
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textView becomeFirstResponder];
    });
}

/**
 *  打开相机
 */
- (void)openCamera
{
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
}
/**
 *  打开相册
 */
- (void)openAlbum
{
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)openImagePickerController:(UIImagePickerControllerSourceType)type
{
    // 判断相机是否可用
    if(![UIImagePickerController isSourceTypeAvailable:type]) return;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = type;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
/**
 *  从UIImagePickerController选择完毕图片调用
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // info中就包含了选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // 添加图片到photosView相册中
    [self.photosView addPhoto:image];
}

@end
