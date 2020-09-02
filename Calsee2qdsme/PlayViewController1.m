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
    UILabel *  timeLab;
    NSInteger secondsCountDown;
}

@property (nonatomic, strong) TXLivePlayer *player;
@property (nonatomic, strong) NSString *playUrl;
@property (nonatomic, strong) UITextView *contentTxt;
@property (nonatomic, strong) NSTimer *countDownTimer;
@end

@implementation PlayViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
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
      collectBtn.frame=CGRectMake(0, 0, 60, 50);
    collectBtn.backgroundColor=[UIColor clearColor];
      [collectBtn addTarget:self action:@selector(collectPress) forControlEvents:UIControlEventTouchUpInside];
      [topView addSubview:collectBtn];

    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 12, 20)];
    imageView.image=[UIImage imageNamed:@"icon_back_title"];
    [collectBtn addSubview:imageView];
    
    CGFloat videoHeight = 64;
       if (KIsiPhoneX) {
           videoHeight=100;
       }
    
    _videoView = [[UIView alloc] initWithFrame:CGRectMake(0, videoHeight, ScreenW, ScreenW*2/3)];
    _videoView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:_videoView];
    
    _contentTxt = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_videoView.frame)+10, ScreenW, ScreenH-ScreenW*2/3-videoHeight-20)];
    _contentTxt.editable=NO;
    _contentTxt.backgroundColor=[UIColor whiteColor];
    _contentTxt.font=[UIFont systemFontOfSize:14];
    _contentTxt.text=_playDic[@"content"];
    [self.view addSubview:_contentTxt];
    
    self.playUrl = _playDic[@"url"];
    
    
    
    
    timeLab=[[UILabel alloc]initWithFrame:CGRectMake(70, 10, ScreenW-70, 34)];
    timeLab.textColor=[UIColor redColor];
    timeLab.font=[UIFont systemFontOfSize:14];
    timeLab.textAlignment=NSTextAlignmentCenter;
    [topView addSubview:timeLab];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYY-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    
    NSString *starttime=_playDic[@"starttime"];
    NSDate  *time= [formatter dateFromString:starttime];
    NSString *timestr=[formatter stringFromDate:time];
    NSString *time1=  [HelpCommon timeSwitchTimestamp:timestr andFormatter:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *currentDate = [NSDate date];
    
    NSString *dateStr = [formatter stringFromDate:currentDate];
    
    NSString *time2=  [HelpCommon timeSwitchTimestamp:dateStr andFormatter:@"yyyy-MM-dd HH:mm:ss"];
    
    NSInteger seconds =[ time1 integerValue]-[time2 integerValue];
    
    
    if (seconds>0) {
        secondsCountDown =seconds;
        _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
        //启动倒计时后会每秒钟调用一次方法 countDownAction
        
        //设置倒计时显示的时间
        NSString *str_hour = [NSString stringWithFormat:@"%02ld",secondsCountDown/3600];//时
        NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%3600)/60];//分
        NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%60];//秒
        NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
        timeLab.text = [NSString stringWithFormat:@"即将开始：%@",format_time];
    }
    else
    {
        
        [self startPlay];
        
    }
    
    
}
-(void)countDownAction{
    //倒计时-1
    secondsCountDown--;
    
    //重新计算 时/分/秒
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",secondsCountDown/3600];
    
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%3600)/60];
    
    NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%60];
    
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    //修改倒计时标签及显示内容
    timeLab.text=[NSString stringWithFormat:@"即将开始：%@",format_time];
    
    //当倒计时到0时做需要的操作，比如验证码过期不能提交
    if(secondsCountDown==0){
        [_countDownTimer invalidate];
        [self startPlay];
    }
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
            
        }
        else if (EvtID == -2301)
        {
            [MBProgressHUD showSuccess:@"直播已结束" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
            
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


@end
