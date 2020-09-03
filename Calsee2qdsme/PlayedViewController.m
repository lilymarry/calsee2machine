//
//  PlayedViewController.m
//  Calsee2qdsme
//
//  Created by SCHENK on 2020/8/28.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import "PlayedViewController.h"
#import "TXVodPlayer.h"
@interface PlayedViewController ()<TXVodPlayListener>{
    UIView               *_videoView;             // 视频画面
    TX_Enum_PlayerType     _playType;               // 播放类型
    UIView               *_selectView;
    UILabel *  timeLab;
    NSInteger secondsCountDown;
    
}

@property (nonatomic, strong) TXVodPlayer *player;
@property (nonatomic, strong) NSString *playUrl;
@property (nonatomic, strong) UITextView *contentTxt;
@property (nonatomic, strong) NSTimer *countDownTimer;
@end

@implementation PlayedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [ self.view setBackgroundColor:[UIColor whiteColor]];
    
    
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
    
    timeLab=[[UILabel alloc]initWithFrame:CGRectMake(70, 10, ScreenW-80, 34)];
    timeLab.textColor=[UIColor redColor];
    timeLab.font=[UIFont systemFontOfSize:14];
    
    timeLab.textAlignment=NSTextAlignmentRight;
    [topView addSubview:timeLab];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYY-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    
    NSString *startTime=_playDic[@"starttime"];
    NSDate  *startDate= [formatter dateFromString:startTime];
    NSString *startTimeStr=[formatter stringFromDate:startDate];
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
        timeLab.text = [NSString stringWithFormat:@"即将开始：%@",format_time];
    }
    else
    {
        
        //        int seconds =[currentTimeStamp intValue]-[startTimeStamp intValue];
        //
        //        int playLongTime =[_player duration];
        //    [_player setStartTime:seconds];
        
        [self startPlay];
    }
     CGFloat videoHeight = 64;
    if (KIsiPhoneX) {
        videoHeight=100;
    }
    _videoView = [[UIView alloc] initWithFrame:CGRectMake(0, videoHeight, ScreenW, ScreenW*2/3)];
    _videoView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:_videoView];
    
    // 创建播放器
    _player = [[TXVodPlayer alloc] init];
    [_player setupVideoWidget:_videoView insertIndex:0];
    
    _contentTxt = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_videoView.frame)+10, ScreenW, ScreenH-ScreenW*2/3-videoHeight-20)];
    _contentTxt.backgroundColor=[UIColor whiteColor];
    _contentTxt.editable=NO;
    _contentTxt.font=[UIFont systemFontOfSize:14];
    _contentTxt.text=_playDic[@"content"];;
    [self.view addSubview:_contentTxt];
    
    
    
    // NSString* url = @"http://1252463788.vod2.myqcloud.com/xxxxx/v.f20.mp4";
    // [_player startPlay:url ];
    
    
    //        p.appId = 1252463788;
    //        p.fileId = @"4564972819220421305";
    
    
    //        TXPlayerAuthParams *p = [TXPlayerAuthParams new];
    //        p.appId = 1301332811;
    //        p.fileId = @"5285890805172256660";
    //
    //         int ret=  [_player startPlayWithParams:p];
    //
    //           _player.vodDelegate=self;
    //
    //           if (ret==0) {
    //               NSLog(@"ssss ok");
    //           }
    //           else
    //           {
    //               NSLog(@"ssss %d",ret);
    //           }
    //
    
    
    //    // 调整进度
    //    [_player seek:slider.value];
    //    // 暂停播放
    //    [_player pause];
    //    // 恢复播放
    //    [_player resume];
    
    //    // 停止播放
    //
    
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
-(void)startPlay
{
    
    TXPlayerAuthParams *p = [TXPlayerAuthParams new];
    
    //       p.appId = 1252463788;
    //       p.fileId = @"4564972819220421305";
    
    //         p.appId = 1301332811;
    //         p.fileId = @"5285890805172256660";
    
    //-----------------------------正式
    p.appId = 1301332811;
    p.fileId = _playDic[@"url"];
    
    int ret=  [_player startPlayWithParams:p];
    
    _player.vodDelegate=self;
   // [_player seek:seek];
    if (ret==0) {
        NSLog(@"ssss ok");
    }
    else
    {
        NSLog(@"ssss %d",ret);
    }
}
-(void)collectPress
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [_player stopPlay];
    [_player removeVideoWidget]; // 记得销毁 view 控件
}
-(void) onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary*)param {
    NSLog(@"------------------------EvtID= %d",EvtID);
    
    if (EvtID == PLAY_EVT_PLAY_PROGRESS) {
        
    }
    else if (EvtID == -2301)
          {
//              [MBProgressHUD showSuccess:@"播放已结束" toView:self.view];
//              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                  [self.navigationController popViewControllerAnimated:YES];
//              });
//
              
          }
    else  if (EvtID == PLAY_EVT_PLAY_PROGRESS) {
//        // 加载进度, 单位是秒, 小数部分为毫秒
//        double playable = [param[EVT_PLAYABLE_DURATION] doubleValue];
//        //    [_loadProgressBar setValue:playable];//
//
//        // 播放进度, 单位是秒, 小数部分为毫秒
//        double progress = [param[EVT_PLAY_PROGRESS] doubleValue];
//        //   [_seekProgressBar setValue:progress];
//
//        // 视频总长, 单位是秒, 小数部分为毫秒
//        double duration = [param[EVT_PLAY_DURATION] doubleValue];
//        // 可以用于设置时长显示等等
//
        
    }
    else if (EvtID == PLAY_EVT_GET_MESSAGE) {
        NSData *msgData = param[@"EVT_GET_MSG"];
        NSString *msg = [[NSString alloc] initWithData:msgData encoding:NSUTF8StringEncoding];
        [MBProgressHUD showError:msg toView:self.view];
    }
    else  if (EvtID == PLAY_EVT_PLAY_END)
    {
//        //直播结束
//        [_player stopPlay];
//        [_player removeVideoWidget]; // 记得销毁 view 控件
    }
    
}




@end
