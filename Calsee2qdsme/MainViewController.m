//
//  MainViewController.m
//  Calsee2qdsme
//
//  Created by SCHENK on 2020/8/21.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import "MainViewController.h"
#import<WebKit/WebKit.h>
#import "PlayViewController1.h"

@interface MainViewController ()<WKNavigationDelegate, WKUIDelegate,UIScrollViewDelegate,WKScriptMessageHandler>

@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (strong, nonatomic) NSString *urlStr;
@end

@implementation MainViewController

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
    
     _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, statusBarHeight+5,ScreenW ,ScreenH-statusBarHeight-5 )configuration: _config];
     
   _webView.navigationDelegate = self;
   _webView.UIDelegate = self;
   _webView.scrollView.delegate = self;
    NSString *url=@"https://www.calseeglobal.com/web/ios/index.aspx?exhiid=295621120832";
    NSString *userbh = [[NSUserDefaults standardUserDefaults] objectForKey:Userbh];
    if (userbh.length>0) {
      url=[NSString stringWithFormat:@"https://www.calseeglobal.com/web/ios/index.aspx?exhiid=295621120832&ubh=%@",userbh];
    }
   
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];

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
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
   // 登录
    if ([message.name isEqualToString:@"exhiinfo"] ) {
     NSData *jsonData = [message.body dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                error:&err];
       
         NSLog(@"AAAAA %@",dic);
        [[NSUserDefaults standardUserDefaults]  setObject:dic[@"exhibh"] forKey:Exhibh] ;
        [[NSUserDefaults standardUserDefaults]  setObject:dic[@"userbh"] forKey:Userbh] ;
        NSString *str=@"15@15.com";

        [[NSUserDefaults standardUserDefaults]synchronize];
        //设备绑定 target 目标类型，1：本设备；2：本设备绑定账号；3：别名
       [ CloudPushSDK bindTag:1 withTags:@[str] withAlias:@"1111" withCallback:^(CloudPushCallbackResult *res) {
       }];
        
    }
    //退出登录
  else   if ([message.name isEqualToString:@"logout"]) {
      [[NSUserDefaults standardUserDefaults] removeObjectForKey:Userbh];
       [[NSUserDefaults standardUserDefaults] removeObjectForKey:Exhibh];
       [[NSUserDefaults standardUserDefaults]synchronize];
      NSString *str=@"15@15.com";
                //解除绑定
                [ CloudPushSDK unbindTag:1 withTags:@[str] withAlias:@"1111" withCallback:^(CloudPushCallbackResult *res) {
                     }];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
      WKUserContentController *controller = self.webView.configuration.userContentController;
     [controller addScriptMessageHandler:self name:@"exhiinfo"];//登录
    [controller addScriptMessageHandler:self name:@"logout"];//登录
    
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidDisappear:(BOOL)animated
{
    WKUserContentController *controller = self.webView.configuration.userContentController;
    [controller removeScriptMessageHandlerForName:@"exhiinfo"];
    [controller removeScriptMessageHandlerForName:@"logout"];
     [self.navigationController setNavigationBarHidden:NO];
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
    
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];

}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
}

// 此方法是收到响应开始加载后才会调用
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    // 获取cookie
    if (@available(iOS 12.0, *)) {//iOS11也有这种获取方式，但是我使用的时候iOS11系统可以在response里面直接获取到，只有iOS12获取不到
        WKHTTPCookieStore *cookieStore = webView.configuration.websiteDataStore.httpCookieStore;
        [cookieStore getAllCookies:^(NSArray* cookies) {
           [self setCookie:cookies];
            
            
                            
            
        }];
    }else {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
      
        NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
        [self setCookie:cookies];
    }
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 保存cookie到NSHTTPCookieStorage
-(void)setCookie:(NSArray *)cookies {
    if (cookies.count > 0) {
        for (NSHTTPCookie *cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
}
- (IBAction)playPress:(id)sender {
    PlayViewController1 *play=[[PlayViewController1 alloc]init];
    [self.navigationController pushViewController:play animated:YES];
}

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
@end


