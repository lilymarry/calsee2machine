//
//  CameraPushViewController.m
//  Calsee2qdsme
//
//  Created by SCHENK on 2020/8/21.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import "CameraPushViewController.h"
#import <CommonCrypto/CommonDigest.h>
//#import "PushSettingViewController.h"
//#import "PushMoreSettingViewController.h"
#import "TXLivePush.h"
@interface CameraPushViewController ()<TXLivePushListener>
{
 
     UIView              *_localView;    // 本地预览
}
@property (nonatomic, strong) TXLivePush *pusher;
@property (nonatomic, strong) NSString *pushURL;
@end

@implementation CameraPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
         NSDate *currentDate = [NSDate date];
            // 指定日期声明
          NSTimeInterval oneDay = 2 * 60 *60;  // 2H一共有多少秒
        NSDate * appointDate = [currentDate initWithTimeIntervalSinceNow: oneDay];
    
             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
              [formatter setDateStyle:NSDateFormatterMediumStyle];
              [formatter setTimeStyle:NSDateFormatterShortStyle];
              [formatter setDateFormat:@"YYY-MM-dd HH:mm:ss"];
             NSTimeZone* timeZone = [NSTimeZone localTimeZone];
             [formatter setTimeZone:timeZone];
              NSString *dateStr = [formatter stringFromDate:appointDate];
       NSString *str= [HelpCommon timeSwitchTimestamp:dateStr andFormatter:@"YYYY-MM-dd HH:mm:ss"];
        NSString *str1=[self getHexByDecimal:[str integerValue]];
      //  NSLog(@"wwww %@",str1);
    
        NSString *appkey=@"2aab1d8f1639b1765d88cdd84e92e69c";
        NSString *appName=@"calsee2m";
        NSString *streamName=@"643325597468";
        NSString *result=[NSString stringWithFormat:@"%@%@%@",appkey,streamName,str1];
        NSString *url=@"livepushm.calseeglobal.com";
        NSString *md5Str=[self md5String:result];
    
         _pushURL=[NSString stringWithFormat:@"rtmp://%@/%@/%@?txSecret=%@&txTime=%@",url,appName,streamName,md5Str,str1];
    //    NSLog(@"www %@",result2);
    
    // 创建推流器
     _pusher = [self createPusher];
    
   // 本地视频预览view
      _localView = [[UIView alloc] initWithFrame:self.view.bounds];
      [self.view insertSubview:_localView atIndex:0];
      _localView.center = self.view.center;
     
}
// 创建推流器，并使用本地配置初始化它
- (TXLivePush *)createPusher
{
    // config初始化
    TXLivePushConfig *config = [[TXLivePushConfig alloc] init];
    config.pauseFps = 10;
    config.pauseTime = 300;
    config.pauseImg = [UIImage imageNamed:@"pause_publish"];
    
    config.audioChannels = 1;
    config.audioSampleRate = AUDIO_SAMPLE_RATE_48000;
    config.frontCamera =0;
 //   config.touchFocus = [PushMoreSettingViewController isEnableTouchFocus];
   // config.enableZoom = [PushMoreSettingViewController isEnableVideoZoom];
   // config.enablePureAudioPush = [PushMoreSettingViewController isEnablePureAudioPush];
  //  config.enableAudioPreview = [PushSettingViewController getEnableAudioPreview];
  //  NSInteger audioQuality = [PushSettingViewController getAudioQuality];
//    switch (audioQuality) {
//        case 2:
//            // 音乐音质，采样率48000
//            config.audioChannels = 2;
//            config.audioSampleRate = AUDIO_SAMPLE_RATE_48000;
//            break;
//        case 1:
//            // 标准音质，采样率48000
//            config.audioChannels = 1;
//            config.audioSampleRate = AUDIO_SAMPLE_RATE_48000;
//            break;
//        case 0:
//            // 语音音质，采样率16000
//            config.audioChannels = 1;
//            config.audioSampleRate = AUDIO_SAMPLE_RATE_16000;
//            break;
//        default:
//            break;
//    }
  //  config.frontCamera = _btnCamera.tag == 0 ? YES : NO;
  //  if ([PushMoreSettingViewController isEnableWaterMark]) {
        config.watermark = [UIImage imageNamed:@"watermark"];
        config.watermarkPos = CGPointMake(10, 10);
  //  }
    // 推流器初始化
    TXLivePush *pusher = [[TXLivePush alloc] initWithConfig:config];
//    [pusher toggleTorch:[PushMoreSettingViewController isOpenTorch]];
 //   [pusher setMirror:[PushMoreSettingViewController isMirrorVideo]];
 //   [pusher setMute:[PushMoreSettingViewController isMuteAudio]];
 //   [pusher setVideoQuality:[PushSettingViewController getVideoQuality] adjustBitrate:[PushSettingViewController getBandWidthAdjust] adjustResolution:NO];

#ifdef ENABLE_CUSTOM_MODE_AUDIO_CAPTURE
    config.enableAEC = NO;
    config.customModeType = CUSTOM_MODE_AUDIO_CAPTURE;
    config.audioSampleRate = CUSTOM_AUDIO_CAPTURE_SAMPLERATE;
    config.audioChannels = CUSTOM_AUDIO_CAPTURE_CHANNEL;
#endif
    
    // 修改软硬编需要在setVideoQuality之后设置config.enableHWAcceleration
 //   config.enableHWAcceleration = [PushSettingViewController getEnableHWAcceleration];
    
    // 横屏推流需要先设置config.homeOrientation = HOME_ORIENTATION_RIGHT，然后再[pusher setRenderRotation:90]
//    config.homeOrientation = ([PushMoreSettingViewController isHorizontalPush] ? HOME_ORIENTATION_RIGHT : HOME_ORIENTATION_DOWN);
  //  if ([PushMoreSettingViewController isHorizontalPush]) {
        [pusher setRenderRotation:90];
//    } else {
//        [pusher setRenderRotation:0];
//    }
    
    [pusher setLogViewMargin:UIEdgeInsetsMake(120, 10, 60, 10)];
//    [pusher showVideoDebugLog:[PushMoreSettingViewController isShowDebugLog]];
 //   [pusher setEnableClockOverlay:[PushMoreSettingViewController isEnableDelayCheck]];
    
    [pusher setConfig:config];
    
    return pusher;
}
- ( NSString *)md5String:( NSString *)str {
    
    const char *myPasswd = [str UTF8String ];
    
    unsigned char mdc[ 16 ];
    
    CC_MD5 (myPasswd, ( CC_LONG ) strlen (myPasswd), mdc);
    
    NSMutableString *md5String = [ NSMutableString string ];
    
    for ( int i = 0 ; i< 16 ; i++) {
        //(x代表以十六进制形式输出,02代表不足两位，前面补0输出，如果超过两位，则以实际输出)
        [md5String appendFormat : @"%02x" ,mdc[i]];
        
    }
    
    return md5String;
    
}
- (NSString *)getHexByDecimal:(NSInteger)decimal {
    
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
                
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            
            break;
        }
    }
    return hex;
}
#pragma mark - 推流逻辑
- (BOOL)startPush
{
    NSString *rtmpUrl = _pushURL;
    if (!([rtmpUrl hasPrefix:@"rtmp://"])) {
        rtmpUrl = RTMP_PUBLISH_URL;
    }
    if (!([rtmpUrl hasPrefix:@"rtmp://"])) {
         [MBProgressHUD showError:@"推流地址不合法，目前只支持rtmp推流!" toView:self.view];
 
        return NO;
    }
  //  [_logView setPushUrlValid:YES];
    
    // 检查摄像头权限
    AVAuthorizationStatus statusVideo = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (statusVideo == AVAuthorizationStatusDenied) {
          [MBProgressHUD showError:@"获取摄像头权限失败，请前往隐私-相机设置里面打开应用权限" toView:self.view];
    
        return NO;
    }
    
    // 检查麦克风权限
    AVAuthorizationStatus statusAudio = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (statusAudio == AVAuthorizationStatusDenied) {
          [MBProgressHUD showError:@"获取麦克风权限失败，请前往隐私-麦克风设置里面打开应用权限" toView:self.view];
       
        return NO;
    }
    
    // 还原设置
   // [PushMoreSettingViewController setDisableVideo:NO];
    
    // 设置delegate
    [_pusher setDelegate:self];
    
    // 开启预览
    [_pusher startPreview:_localView];

#ifdef ENABLE_CUSTOM_MODE_AUDIO_CAPTURE
    [CustomAudioFileReader sharedInstance].delegate = self;
    [[CustomAudioFileReader sharedInstance] start:CUSTOM_AUDIO_CAPTURE_SAMPLERATE
                                         channels:CUSTOM_AUDIO_CAPTURE_CHANNEL
                                  framLenInSample:1024];
#endif
    
    // 开始推流
    int ret = [_pusher startPush:rtmpUrl];
    if (ret != 0) {
      //  [self toastTip:[NSString stringWithFormat:@"推流器启动失败: %d", ret]];
        NSLog(@"推流器启动失败");
        return NO;
    }

    // 保存推流地址，其他地方需要
  //  _pushUrl = rtmpUrl;
    
    return YES;
}
- (void)stopPush {
    if (_pusher) {
        [_pusher setDelegate:nil];
        [_pusher stopPreview];
        [_pusher stopPush];
    }
#ifdef ENABLE_CUSTOM_MODE_AUDIO_CAPTURE
    [[CustomAudioFileReader sharedInstance] stop];
    [CustomAudioFileReader sharedInstance].delegate = nil;
#endif
}

@end
