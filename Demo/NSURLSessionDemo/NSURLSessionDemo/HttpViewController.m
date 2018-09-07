//
//  HttpViewController.m
//  NSURLSessionDemo
//
//  Created by 韦海峰 on 2018/9/7.
//  Copyright © 2018年 seapeak. All rights reserved.
//

#import "HttpViewController.h"

@interface HttpViewController ()

@end

@implementation HttpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatButtonsWithSelNames:@[@"normalRequst"]];
}


- (void)normalRequst
{
    /**
     协议：不同的协议，代表着不同的资源查找方式、资源传输方式，比如常用的http，ftp等
     主机地址：存放资源的主机的IP地址（域名）
     路径：资源在主机中的具体位置
     参数：参数可有可无，也可以多个。如果带参数的话，用“?”号后面接参数，多个参数的话之间用&隔开
     */
    NSURL *url = [NSURL URLWithString:@"协议://主机地址/路径?参数&参数"];
    
    
    NSString *urlStr = [@"https://github.com/HaiFengWei/StudyNotes/blob/master/文档笔记/YYDispatchQueuePool学习.html" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    url = [NSURL URLWithString:urlStr];
    
    /**
     *   NSURLRequestUseProtocolCachePolicy = 0 //默认的缓存策略，使用协议的缓存策略
     *   NSURLRequestReloadIgnoringLocalCacheData = 1 //每次都从网络加载
     *   NSURLRequestReturnCacheDataElseLoad = 2 //返回缓存否则加载，**很少使用**
     *   NSURLRequestReturnCacheDataDontLoad = 3 //只返回缓存，没有也不加载，**很少使用**
     */
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    /** 告诉服务器数据为json类型,拼接参数 */
    /**
     [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"]; // 设置请求体(json类型)
     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"userid":@"123456"} options:NSJSONWritingPrettyPrinted error:nil];
     request.HTTPBody = jsonData;
     */
    
    
    /** 获取session */
    NSURLSession *urlSession = [NSURLSession sharedSession];
    /** 开启请求任务，默认任务是挂起，需要手动开启 */
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            [self showAlertWithTitle:@"normalTest" content:@"no_error"];
        }
        else
        {
            [self showAlertWithTitle:@"normalTest" content:@"error"];
        }
    }];
    
    /** 开启网络请求 */
    [dataTask resume];
}



/**
 批量创建按钮

 @param selNames 方法名
 */
- (void)creatButtonsWithSelNames:(NSArray *)selNames
{
    float screenW   = [UIScreen mainScreen].bounds.size.width;
    CGFloat margin  = 20.f;
    CGFloat buttonW = 200.f;
    CGFloat buttonH = 30.f;
    [selNames enumerateObjectsUsingBlock:^(NSString *actionName, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [self creatButtonWithTitle:actionName SEL:NSSelectorFromString(actionName)];
        button.frame = CGRectMake((screenW - buttonW)/2.f, 100 + (margin + buttonH) *idx, buttonW, buttonH);
    }];
}


/**
 创建单个按钮

 @param title  按钮名
 @param action 响应方法
 @return       按钮实例
 */
- (UIButton *)creatButtonWithTitle:(NSString *)title SEL:(SEL)action
{
    UIButton *button =  [[UIButton alloc] init];
    
    button.layer.cornerRadius = 5.f;
    button.clipsToBounds      = YES;
    
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor orangeColor]];
    [button sizeToFit];
    [self.view addSubview:button];
    return button;
}


/**
 提示弹框

 @param title   弹框标题
 @param content 弹框内容
 */
- (void)showAlertWithTitle:(NSString *)title content:(NSString *)content
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:content delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
