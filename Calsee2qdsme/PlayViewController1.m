//
//  PlayViewController1.m
//  Calsee2qdsme
//
//  Created by SCHENK on 2020/8/21.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import "PlayViewController1.h"
#import "TXLivePlayer.h"
#import "AppDelegate.h"
@interface PlayViewController1 ()<TXLivePlayListener,TXLiveRecordListener>
{
    UIView               *_videoView;             // 视频画面
    TX_Enum_PlayType     _playType;               // 播放类型
    UIImageView          *_loadingImageView;      // 菊花
    UILabel *  timeLab;
    NSInteger secondsCountDown;
    
    UIButton *fullScreenButton;
     BOOL isFull;
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
    
    [_player setRenderMode: RENDER_MODE_FILL_EDGE];
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
    
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 64)];
      imageview.image=[UIImage imageNamed:@"bg_title"];
      [topView addSubview:imageview];
     
    UIButton *  collectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
      collectBtn.frame=CGRectMake(0, 0, 60, 50);
    collectBtn.backgroundColor=[UIColor clearColor];
      [collectBtn addTarget:self action:@selector(collectPress) forControlEvents:UIControlEventTouchUpInside];
      [topView addSubview:collectBtn];
    

    UIImageView *imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 12, 20)];
    imageView1.image=[UIImage imageNamed:@"icon_back_title"];
    [collectBtn addSubview:imageView1];
    
    CGFloat videoHeight = 64;
       if (KIsiPhoneX) {
           videoHeight=100;
       }
    
    _videoView = [[UIView alloc] initWithFrame:CGRectMake(0, videoHeight, ScreenW, ScreenW*2/3)];
    _videoView.backgroundColor=[UIColor lightGrayColor];
      [self.view addSubview:_videoView];
    
    UIImageView *_videoViewImageView1=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,ScreenW,ScreenW*2/3)];
    _videoViewImageView1.image=[UIImage imageNamed:@"playBack"];
    [_videoView addSubview:_videoViewImageView1];

     fullScreenButton=[UIButton buttonWithType:UIButtonTypeCustom];
     fullScreenButton.frame=CGRectMake(ScreenW-60, 0, 80, 60);
     fullScreenButton.backgroundColor=[UIColor colorWithWhite:0.f alpha:0.5];
     [fullScreenButton setTitle:@"全屏" forState:UIControlStateNormal];
     [fullScreenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [fullScreenButton addTarget:self action:@selector(fullScreen) forControlEvents:UIControlEventTouchUpInside];
     [_videoView addSubview:fullScreenButton];
     
     isFull=NO;
    
    _contentTxt = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_videoView.frame)+10, ScreenW, ScreenH-ScreenW*2/3-videoHeight-20)];
    _contentTxt.editable=NO;
    _contentTxt.backgroundColor=[UIColor whiteColor];
    _contentTxt.font=[UIFont systemFontOfSize:14];
    if ([_playDic[@"content"] length]==0 ) {
        _contentTxt.text=@"    第十五届中国国际机床工具展览会（CIMES 2020）于9月7日隆重开幕。中国机械国际合作股份有限公司总经理赵立志主持并介绍展会情况。中国机械工业集团有限公司副总经理丁宏祥、中国机械国际合作股份有限公司党委书记、董事长夏闻迪、中国机床总公司总经理唐亮及企业代表剪彩。作为后疫情时期在北京举办的第一场机床工具行业展会，展会规模50000m2 ,参展企业600多家。为了充分满足国内外展商、采购商及观众的需求，保证展览效果，CIMES 2020主办方联合机械工业信息研究院产业与市场研究所与线下展会同期举办“2020中国国际机床工具云展览会”。";
    }
    else
    {
          _contentTxt.text=[NSString stringWithFormat:@"    %@",_playDic[@"content"]];
    }
  
    [self.view addSubview:_contentTxt];
    
    
    
   UILabel *   titleLab=[[UILabel alloc]initWithFrame:CGRectMake(ScreenW/2-40, 10, 80, 34)];
       titleLab.textColor=[UIColor whiteColor];
       titleLab.font=[UIFont systemFontOfSize:17];
       titleLab.textAlignment=NSTextAlignmentCenter;
      titleLab.backgroundColor=[UIColor clearColor];
       titleLab.text=@"开幕直播";
       [topView addSubview:titleLab];
    
    NSString *url =  [ _playDic[@"url"] stringByRemovingPercentEncoding];
    self.playUrl =url;
    
  // self.playUrl = @"http://liteavapp.qcloud.com/live/liteavdemoplayerstreamid.flv";
    
    
    timeLab=[[UILabel alloc]initWithFrame:CGRectMake(ScreenW-150, 10, 140, 34)];
    timeLab.textColor=[UIColor whiteColor];
    timeLab.font=[UIFont systemFontOfSize:12];
    timeLab.textAlignment=NSTextAlignmentRight;
     timeLab.backgroundColor=[UIColor clearColor];
    [topView addSubview:timeLab];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYY-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone localTimeZone]; ;
    [formatter setTimeZone:timeZone];
    
    NSString *startTime=_playDic[@"starttime"];
    NSString *startTimeStr=[HelpCommon  getLocalDateFormateUTCDate:startTime];
    NSString *startTimeStamp=  [HelpCommon timeSwitchTimestamp:startTimeStr andFormatter:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *currentDate = [NSDate date];
    NSString *currentDateStr = [formatter stringFromDate:currentDate];
    NSString *currentTimeStamp=  [HelpCommon timeSwitchTimestamp:currentDateStr andFormatter:@"yyyy-MM-dd HH:mm:ss"];
    
    NSInteger seconds =[startTimeStamp integerValue]-[currentTimeStamp integerValue];
    
    if (seconds>0) {
        secondsCountDown =seconds;
        _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
        //启动倒计时后会每秒钟调用一次方法 countDownAction
        
        //设置倒计时显示的时间
        NSString *str_hour = [NSString stringWithFormat:@"%02ld",secondsCountDown/3600];//时
        NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%3600)/60];//分
        NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%60];//秒
        NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
        timeLab.text = [NSString stringWithFormat:@"%@",format_time];
    }
    else
    {
        
        [self startPlay];
        
    }
    
    
}
-(void)fullScreen
{
    isFull =!isFull;
    if (isFull) {
         AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
             appDelegate.allowRotation = YES;//(以上2行代码,可以理解为打开横屏开关)
             [self setNewOrientation:YES];//调用转屏代码
           
              [_videoView setFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
              _contentTxt.hidden=YES;
         fullScreenButton.frame=CGRectMake(ScreenW-80, 0, 80, 60);
        [fullScreenButton setTitle:@"取消全屏" forState:UIControlStateNormal];
    }
    else
    {
        AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                   appDelegate.allowRotation = NO;
                   [self setNewOrientation:NO];
                     CGFloat videoHeight = 64;
                    if (KIsiPhoneX) {
                        videoHeight=100;
                    }
                    [_videoView setFrame:CGRectMake(0, videoHeight, ScreenW, ScreenW*2/3)];
                    _contentTxt.hidden=NO;
                fullScreenButton.frame=CGRectMake(ScreenW-80, 0, 80, 60);
           [fullScreenButton setTitle:@"全屏" forState:UIControlStateNormal];
        
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
    timeLab.text=[NSString stringWithFormat:@"%@",format_time];
    
    //当倒计时到0时做需要的操作
    if(secondsCountDown==0){
        timeLab.hidden=YES;
        [_countDownTimer invalidate];
        [self startPlay];
    }
}
-(void)collectPress
{
    [self.navigationController popViewControllerAnimated:YES];
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
    [_player setupVideoWidget:CGRectMake(0, 64, ScreenW, ScreenW*2/3) containView:_videoView insertIndex:1];
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
 //   NSDictionary *dict = param;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (EvtID == 2004) {
            //视频开始播放
             // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        else if (EvtID == -2301)
        {
            [MBProgressHUD showSuccess:@"直播已结束" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
            
        } else if (EvtID == 2007){
            // [self startLoadingAnimation];
          //  [MBProgressHUD showMessage:nil toView:self.view];
            
        } else if (EvtID == PLAY_EVT_CONNECT_SUCC) {
            
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

- (void)setNewOrientation:(BOOL)fullscreen

{
    if (fullscreen) {
        
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        
        
        
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
        
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
        
    }else{
        
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        
        
        
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
        
    }
    
}

@end
