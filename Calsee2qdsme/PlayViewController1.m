//
//  PlayViewController1.m
//  Calsee2qdsme
//
//  Created by SCHENK on 2020/8/21.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import "PlayViewController1.h"
#import "TXLivePlayer.h"

@interface PlayViewController1 ()<TXLivePlayListener,TXLiveRecordListener>
{
    UIView               *_videoView;             // 视频画面
    TX_Enum_PlayType     _playType;               // 播放类型
    UIImageView          *_loadingImageView;      // 菊花
}

@property (nonatomic, strong) TXLivePlayer *player;
@property (nonatomic, strong) NSString *playUrl;
@property (nonatomic, strong) UITextView *contentTxt;
@end

@implementation PlayViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
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
    
    // 创建播放器
    _player = [[TXLivePlayer alloc] init];
    
    TXLivePlayConfig* config = _player.config;
    // 开启 flvSessionKey 数据回调
    //config.flvSessionKey = @"X-Tlive-SpanId";
    // 允许接收消息
    config.enableMessage = YES;
    
    
    //极速模式
    config.bAutoAdjustCacheTime   = YES;
    config.minAutoAdjustCacheTime = 1;
    config.maxAutoAdjustCacheTime = 1;
    
    [_player setConfig:config];
    
    
    //   CGRect videoFrame = self.view.bounds;
    _videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenW, ScreenW*2/3)];
    _videoView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:_videoView];
    
    _contentTxt = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_videoView.frame)+10, ScreenW, ScreenH-ScreenW*2/3-64-20)];
    _contentTxt.editable=NO;
    _contentTxt.font=[UIFont systemFontOfSize:14];
    _contentTxt.text=@"美国媒体已经很久没有报道黑人抗议事件了，然而这并不代表黑人抗议在美国已经平息了下来。仅仅只是美国大选占据了其篇幅，一旦发生重大规模的情况，该被曝出的还是得被曝出来\n今天推特热搜上就曝出了一个美国警察枪击黑人的视频，随即受到了海外网友的疯狂转发，因为这次事件似乎让美国的黑人再次感受到了极大的不安全。一名白人警察对一名黑人连开7枪。据视频内容显示，两名警察拿着枪勒令一名穿着白色体恤的黑人男子布莱克停止移动，但布莱克并没有理会，更是直接来到一辆suv前打开车门意欲离开。白人警察冲了过去并揪住了布莱克的脖子，随后视频中传来7声枪响.";
    [self.view addSubview:_contentTxt];
    
    self.playUrl = @"http://liteavapp.qcloud.com/live/liteavdemoplayerstreamid.flv";
    
    //      if (![self startPlay]) {
    //                 return;
    //             }
    
    // 如下代码用于展示直播播放场景下的录制功能
    //
    // 指定一个 TXVideoRecordListener 用于同步录制的进度和结果
    //_player.recordDelegate = self;
    // 启动录制，可放于录制按钮的响应函数里，目前只支持录制视频源，弹幕消息等目前还不支持
    // [_player startRecord: RECORD_TYPE_STREAM_SOURCE];
    // ...
    // ...
    // 结束录制，可放于结束按钮的响应函数里
    // [_player stopRecord];
    
    
    
    NSString *time1=  [HelpCommon timeSwitchTimestamp:@"2020-08-29 19:10:12" andFormatter:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *time2=  [HelpCommon timeSwitchTimestamp:@"2020-08-30 19:20:00" andFormatter:@"yyyy-MM-dd HH:mm:ss"];
    NSLog(@"ffff %ld",[time2 integerValue]-[time1 integerValue]);
    
    NSLog(@"ssss %@",[self  timeFormatted:[time2 integerValue]-[time1 integerValue]]);
    
}
-(void)collectPress
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)startLoadingAnimation {
    if (_loadingImageView != nil) {
        _loadingImageView.hidden = NO;
        [_loadingImageView startAnimating];
    }
}

- (void)stopLoadingAnimation {
    if (_loadingImageView != nil) {
        _loadingImageView.hidden = YES;
        [_loadingImageView stopAnimating];
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [self stopPlay];
}
- (BOOL)startPlay {
    
    NSString *playUrl =  self.playUrl;
    
    if (![self checkPlayUrl:playUrl]) {
        return NO;
    }
    [_player setDelegate:self];
    [_player setupVideoWidget:CGRectMake(0, 64, ScreenW, ScreenW*2/3) containView:_videoView insertIndex:0];
    // [_player seek:480];//从几秒开播
    int ret = [_player startPlay:playUrl type:_playType];
    
    if (ret != 0) {
        NSLog(@"播放器启动失败");
        return NO;
    }
    else
    {
        return YES;
    }
    
}
- (void)stopPlay {
    
    if (_player) {
        [_player setDelegate:nil];
        [_player removeVideoWidget];
        [_player stopPlay];
    }
}
#pragma mark - TXLivePlayListener

- (void)onPlayEvent:(int)EvtID withParam:(NSDictionary *)param
{
    NSDictionary *dict = param;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (EvtID == PLAY_EVT_PLAY_BEGIN) {
            //  [self stopLoadingAnimation];
            
        } else if (EvtID == PLAY_ERR_NET_DISCONNECT || EvtID == PLAY_EVT_PLAY_END) {
            // 断开连接时，模拟点击一次关闭播放
            // [self clickPlay:_btnPlay];
            
            if (EvtID == PLAY_ERR_NET_DISCONNECT) {
                NSString *msg = (NSString*)[dict valueForKey:EVT_MSG];
                // [self toastTip:msg];
            }
            
        } else if (EvtID == PLAY_EVT_PLAY_LOADING){
            // [self startLoadingAnimation];
            
        } else if (EvtID == PLAY_EVT_CONNECT_SUCC) {
            BOOL isWifi = [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
            if (!isWifi) {
                __weak __typeof(self) weakSelf = self;
                [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                    if (weakSelf.playUrl.length == 0) {
                        return;
                    }
                    if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                                       message:@"您要切换到Wifi再观看吗?"
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [alert dismissViewControllerAnimated:YES completion:nil];
                            
                            // 先停止，再重新播放
                            [weakSelf stopPlay];
                            [weakSelf startPlay];
                        }]];
                        [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            [alert dismissViewControllerAnimated:YES completion:nil];
                        }]];
                        [weakSelf presentViewController:alert animated:YES completion:nil];
                    }
                }];
            }
        }
        else if (EvtID == PLAY_EVT_GET_MESSAGE) {
            //   NSData *msgData = param[@"EVT_GET_MSG"];
            //  NSString *msg = [[NSString alloc] initWithData:msgData encoding:NSUTF8StringEncoding];
            // [self toastTip:msg];
        }
        /*
         7.2 新增
         else if (EvtID == PLAY_EVT_GET_FLVSESSIONKEY) {
         //NSString *Msg = (NSString*)[dict valueForKey:EVT_MSG];
         //[self toastTip:[NSString stringWithFormat:@"event PLAY_EVT_GET_FLVSESSIONKEY: %@", Msg]];
         }
         */
    });
}
-(BOOL)checkPlayUrl:(NSString*)playUrl {
    if ([playUrl hasPrefix:@"rtmp:"]) {
        _playType = PLAY_TYPE_LIVE_RTMP;
    } else if (([playUrl hasPrefix:@"https:"] || [playUrl hasPrefix:@"http:"]) && ([playUrl rangeOfString:@".flv"].length > 0)) {
        _playType = PLAY_TYPE_LIVE_FLV;
    } else if (([playUrl hasPrefix:@"https:"] || [playUrl hasPrefix:@"http:"]) && [playUrl rangeOfString:@".m3u8"].length > 0) {
        _playType = PLAY_TYPE_VOD_HLS;
    } else{
        [MBProgressHUD showError:@"播放地址不合法，直播目前仅支持rtmp,flv播放方式!" toView:self.view];
        
        return NO;
    }
    return YES;
}
/**
 * 短视频录制进度
 */
-(void) onRecordProgress:(NSInteger)milliSecond{
    
}

/**
 * 短视频录制完成
 */
-(void) onRecordComplete:(TXRecordResult*)result
{
    
}

/**
 * 短视频录制事件通知
 */
-(void) onRecordEvent:(NSDictionary*)evt
{
    
}


//转换成时分秒

- (NSString *)timeFormatted:(int)totalSeconds

{
    
    int seconds = totalSeconds % 60;
    
    int minutes = (totalSeconds / 60) % 60;
    
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    
}


@end
