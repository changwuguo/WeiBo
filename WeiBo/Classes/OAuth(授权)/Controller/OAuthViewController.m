//
//  OAuthViewController.m
//  WeiBo
//
//  Created by qianfeng on 15/6/14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "OAuthViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "Account.h"
#import "AccountTool.h"
#import "UIWindow+Extension.h"

@interface OAuthViewController () <UIWebViewDelegate>

@end

@implementation OAuthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    NSString *urlStr = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@", WBAppKey, WBRedirectURI];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUD];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showMessage:@"正在加载..."];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUD];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSRange range = [url rangeOfString:@"code="];
    if (range.length != 0) {
        int fromIndex = range.location + range.length;
        NSString *code = [url substringFromIndex:fromIndex];
        [self accessTokenWithCode:code];
        return NO;
    }
    return YES;
}

- (void)accessTokenWithCode:(NSString *)code
{
    /*
     URL：https://api.weibo.com/oauth2/access_token
     
     请求参数：
     client_id：申请应用时分配的AppKey
     client_secret：申请应用时分配的AppSecret
     grant_type：使用authorization_code
     redirect_uri：授权成功后的回调地址
     code：授权成功后返回的code
     */
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = WBAppKey;
    params[@"client_secret"] = WBAppSecret;
    params[@"grant_type"] = @"authorization_code";
    params[@"redirect_uri" ] = WBRedirectURI;
    params[@"code"] = code;
    
    [manager POST:@"https://api.weibo.com/oauth2/access_token" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUD];
        
        // 字典转模型
        Account *account = [Account accountWithDictionary:responseObject];
        // 存储账号信息
        [AccountTool saveAccount:account];
        
        // 更换RootViewController
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window switchRootViewController];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        WBLog(@"请求失败 --- %@", error);
    }];
}

/**
 *  隐藏状态栏
 */
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
