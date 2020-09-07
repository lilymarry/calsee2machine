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
    
    NSString *startTimeStamp;//起始时间戳
    NSString *startTimeStr;
    
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
    
     
    UILabel *   titleLab=[[UILabel alloc]initWithFrame:CGRectMake(ScreenW/2-40, 10, 80, 34)];
        titleLab.textColor=[UIColor whiteColor];
        titleLab.font=[UIFont systemFontOfSize:17];
        titleLab.textAlignment=NSTextAlignmentCenter;
       titleLab.backgroundColor=[UIColor clearColor];
        titleLab.text=@"开幕直播";
        [topView addSubview:titleLab];
    
    
     timeLab=[[UILabel alloc]initWithFrame:CGRectMake(ScreenW-150, 10, 140, 34)];
      timeLab.textColor=[UIColor whiteColor];
      timeLab.font=[UIFont systemFontOfSize:12];
      timeLab.textAlignment=NSTextAlignmentRight;
       timeLab.backgroundColor=[UIColor clearColor];
      
      [topView addSubview:timeLab];
    
    
    
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

    
    // 创建播放器
    _player = [[TXVodPlayer alloc] init];
    [_player setRenderMode: RENDER_MODE_FILL_EDGE];
    [_player setupVideoWidget:_videoView insertIndex:1];
    
    _contentTxt = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_videoView.frame)+10, ScreenW, ScreenH-ScreenW*2/3-videoHeight-20)];
    _contentTxt.backgroundColor=[UIColor whiteColor];
    _contentTxt.editable=NO;
    _contentTxt.font=[UIFont systemFontOfSize:14];
       if ([_playDic[@"content"] length]==0 ) {
        _contentTxt.text=@"    第十五届中国国际机床工具展览会（CIMES 2020）于9月7日隆重开幕。中国机械国际合作股份有限公司总经理赵立志主持并介绍展会情况。中国机械工业集团有限公司副总经理丁宏祥、中国机械国际合作股份有限公司党委书记、董事长夏闻迪、中国机床总公司总经理唐亮及企业代表剪彩。作为后疫情时期在北京举办的第一场机床工具行业展会，展会规模50000m2 ,参展企业600多家。为了充分满足国内外展商、采购商及观众的需求，保证展览效果，CIMES 2020主办方联合机械工业信息研究院产业与市场研究所与线下展会同期举办“2020中国国际机床工具云展览会”。";
    }
    else
    {
          _contentTxt.text=[NSString stringWithFormat:@"    %@",_playDic[@"content"]];
    }
    [self.view addSubview:_contentTxt];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYY-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    
    NSString *startTime=_playDic[@"starttime"];
    startTimeStr=[HelpCommon  getLocalDateFormateUTCDate:startTime];
    startTimeStamp=  [HelpCommon timeSwitchTimestamp:startTimeStr andFormatter:@"yyyy-MM-dd HH:mm:ss"];

    
    
    NSDate *currentDate = [NSDate date];
    NSString *currentTimeStamp=  [self getTime:currentDate];
    

    
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
              [self startPlay];
    }
    
}

-(NSString *)getTime:(NSDate *)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYY-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    
    NSString *currentDateStr = [formatter stringFromDate:time];
    NSString *currentTimeStamp=  [HelpCommon timeSwitchTimestamp:currentDateStr andFormatter:@"yyyy-MM-dd HH:mm:ss"];
    return currentTimeStamp;
    
    
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
        timeLab.hidden=YES;
        [_countDownTimer invalidate];
        [self startPlay];
    }
}
-(void)startPlay
{
    
    TXPlayerAuthParams *p = [TXPlayerAuthParams new];
     //   p.appId = 1252463788;
     //   p.fileId = @"4564972819219071568";
    //-----------------------------正式
    p.appId = 1301332811;
    p.fileId = _playDic[@"url"];
    
    [_player startPlayWithParams:p];
    
    _player.vodDelegate=self;
    
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

    if (EvtID == 2004) {
        
    }
    else if (EvtID == 2013)
       {
          
           int intel=(int)player.duration;
           
           NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
             [formatter setDateStyle:NSDateFormatterMediumStyle];
             [formatter setTimeStyle:NSDateFormatterShortStyle];
             [formatter setDateFormat:@"YYY-MM-dd HH:mm:ss"];
             NSTimeZone* timeZone = [NSTimeZone localTimeZone];
             [formatter setTimeZone:timeZone];
           
           NSDate *startDate=[formatter dateFromString:startTimeStr];//开始时间
           NSDate * overDate = [startDate initWithTimeIntervalSinceNow: intel];//结束时间
           NSString *overTimeStamp=  [self getTime:overDate];//结束时间戳
           
            NSDate *currentDate = [NSDate date];//当前时间
            NSString *currentTimeStamp=  [self getTime:currentDate];//当前时间戳
           
           int second=[overTimeStamp intValue]-[currentTimeStamp intValue];
           if (second>0) {
               //直播没有结束 计算开始播放时间
               int over=[currentTimeStamp intValue] -[startTimeStamp intValue];
                [_player seek:over];
           }
           else
           {
               [_player seek:0];
           }
           
           
           
       }
    else if (EvtID == -2301)
    {
        //              [MBProgressHUD showSuccess:@"播放已结束" toView:self.view];
        //              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //                  [self.navigationController popViewControllerAnimated:YES];
        //              });
        //
        
    }
    else  if (EvtID == 2005) {
        //        // 加载进度, 单位是秒, 小数部分为毫秒
        //        double playable = [param[EVT_PLAYABLE_DURATION] doubleValue];
        //        //    [_loadProgressBar setValue:playable];//
        //
        //        // 播放进度, 单位是秒, 小数部分为毫秒
        //        double progress = [param[EVT_PLAY_PROGRESS] doubleValue];
        //        //   [_seekProgressBar setValue:progress];
        //
        //        // 视频总长, 单位是秒, 小数部分为毫秒
      //          double duration = [param[EVT_PLAY_DURATION] doubleValue];
     //     NSLog(@"AAAA %f",duration);
      //          // 可以用于设置时长显示等等
        
        
    }
    else if (EvtID == PLAY_EVT_GET_MESSAGE) {
        NSData *msgData = param[@"EVT_GET_MSG"];
        NSString *msg = [[NSString alloc] initWithData:msgData encoding:NSUTF8StringEncoding];
        [MBProgressHUD showError:msg toView:self.view];
    }
    else  if (EvtID == 2006)
    {
       //播放结束 重新播放
       [_player resume];
    }
    
}




@end
