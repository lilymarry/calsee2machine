//
//  ViewController.m
//  Calsee2qdsme
//
//  Created by SCHENK on 2020/8/20.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import "ViewController.h"
#import<WebKit/WebKit.h>

@interface ViewController ()<WKNavigationDelegate, WKUIDelegate>
@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

       WKWebViewConfiguration*   _config = [[WKWebViewConfiguration alloc]init];
     _config.userContentController = [[WKUserContentController alloc]init];
     //webViewAppShare这个需保持跟服务器端的一致，服务器端通过这个name发消息，客户端这边回调接收消息，从而做相关的处理
 
     _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 44,ScreenW ,ScreenH-44)configuration: _config];
     
   _webView.navigationDelegate = self;
   _webView.UIDelegate = self;

     NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.calseeglobal.com/web/iOS/index.aspx?exhiid=765218152561"]];
//     [request setValue:@"ios"
//    forHTTPHeaderField:@"device"];

     [_webView loadRequest:request];
     [self.view addSubview:_webView];
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 38, ScreenW, 5)];
    self.progressView.backgroundColor = [UIColor whiteColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
  //  self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
    
    //3.添加KVO，WKWebView有一个属性estimatedProgress，就是当前网页加载的进度，所以监听这个属性。
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = _webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;

            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    self.progressView.progress=0.1;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    //加载完成后隐藏progressView
    //self.progressView.hidden = YES;
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    //加载失败同样需要隐藏progressView
    //self.progressView.hidden = YES;
}
- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
@end
