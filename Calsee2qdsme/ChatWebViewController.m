//
//  ChatWebViewController.m
//  Calsee2qdsme
//
//  Created by SCHENK on 2020/9/1.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import "ChatWebViewController.h"
#import<WebKit/WebKit.h>
@interface ChatWebViewController ()
@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation ChatWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     WKWebViewConfiguration*   _config = [[WKWebViewConfiguration alloc]init];
     _config.userContentController = [[WKUserContentController alloc]init];

    
    CGFloat statusBarHeight = 0.f;
    if (@available(iOS 13.0, *)) {
        statusBarHeight = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame.size.height;
    } else {
        statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
    
     UIView *   topView = [[UIView alloc] initWithFrame:CGRectMake(0, statusBarHeight, ScreenW, 64)];
     topView.backgroundColor = [UIColor whiteColor];
     [self.view addSubview:topView];
     UIButton *  collectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
      collectBtn.frame=CGRectMake(10, 10, 60, 35);
     
      [collectBtn setTitle:@"<返回" forState:UIControlStateNormal];
       [collectBtn addTarget:self action:@selector(collectPress) forControlEvents:UIControlEventTouchUpInside];
    
      collectBtn.titleLabel.font=[UIFont systemFontOfSize:17];
    [collectBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [topView addSubview:collectBtn];
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, statusBarHeight+64,ScreenW ,ScreenH-statusBarHeight-5-64 )configuration: _config];
     
  // _webView.navigationDelegate = self;
 //  _webView.UIDelegate = self;
 //  _webView.scrollView.delegate = self;
    
  //  _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
 //   [_bridge setWebViewDelegate:self];
  
  
  NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url]];

[_webView loadRequest:request];
   
[self.view addSubview:_webView];
    
   self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, statusBarHeight, ScreenW, 5)];
   self.progressView.backgroundColor = [UIColor whiteColor];
       //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
     //  self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
       [self.view addSubview:self.progressView];
       
    
    //3.添加KVO，WKWebView有一个属性estimatedProgress，就是当前网页加载的进度，所以监听这个属性。
   [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
}
-(void)collectPress
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
  
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
  
        if (_webView.estimatedProgress == 1) {
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

@end
