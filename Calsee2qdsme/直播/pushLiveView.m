//
//  pushLiveView.m
//  Calsee2qdsme
//
//  Created by zell on 2020/8/27.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import "pushLiveView.h"


@implementation pushLiveView

-(void)setPushInfor{
    TXLivePushConfig *config = [[TXLivePushConfig alloc] init];  // 一般情况下不需要修改默认 config

    self.livePusher = [[TXLivePush alloc] initWithConfig: config]; // config 参数不能为空
    //创建一个 view 对象，并将其嵌入到当前界面中
    config.pauseFps = 10;
        config.pauseTime = 300;
        config.pauseImg = [UIImage imageNamed:@"pause_publish"];
        //是否允许点击曝光聚焦
        config.touchFocus = NO;
        //是否允许双指手势放大预览画面
        config.enableZoom = NO;
        //否为纯音频推流
        config.enablePureAudioPush = NO;
        //是否开启耳返特效
        config.enableAudioPreview = NO;
        //        config.frontCamera = _btnCamera.tag == 0 ? YES : NO;
        //    /水印图片，设为 nil 等同于关闭水印
        config.watermark = nil;
        config.watermarkPos = CGPointMake(10, 10);
        // 推流器初始化
        self.livePusher = [[TXLivePush alloc] initWithConfig:config];
        //设置混响效果
        [self.livePusher setReverbType:NO];
        //设置变声类型
        [self.livePusher setVoiceChangerType:NO];
        //打开后置摄像头旁边的闪关灯
        [self.livePusher toggleTorch:NO];
        //设置视频镜像效果
        [self.livePusher setMirror:NO];
        //开启静音
        [self.livePusher setMute:NO];
        //设置视频编码质量
        [self.livePusher setVideoQuality:VIDEO_QUALITY_HIGH_DEFINITION adjustBitrate:NO adjustResolution:NO];
        
    #ifdef ENABLE_CUSTOM_MODE_AUDIO_CAPTURE
        config.enableAEC = NO;
        config.customModeType = CUSTOM_MODE_AUDIO_CAPTURE;
        config.audioSampleRate = CUSTOM_AUDIO_CAPTURE_SAMPLERATE;
        config.audioChannels = CUSTOM_AUDIO_CAPTURE_CHANNEL;
    #endif
        
        // 修改软硬编需要在setVideoQuality之后设置config.enableHWAcceleration
        config.enableHWAcceleration = YES;
        
        // 横屏推流需要先设置config.homeOrientation = HOME_ORIENTATION_RIGHT，然后再[pusher setRenderRotation:90]
        config.homeOrientation =  HOME_ORIENTATION_DOWN;
        [self.livePusher setRenderRotation:0];
    UIView *_localView = [[UIView alloc] initWithFrame:self.bounds];
//    [self insertSubview:_localView atIndex:0];
    [self addSubview:_localView];
    _localView.center = self.center;

//    //启动本地摄像头预览
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//            // 处理耗时操作的代码块...
//
//
//
//            //通知主线程刷新
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//                //回调或者说是通知主线程刷新，
//
//        });
//
//
//
//    });
    [self.livePusher startPreview:_localView];
//    //启动推流
//    NSString* rtmpUrl = @"rtmp://111032.livepush.myqcloud.com/live/livepushstream?txSecret=9448d437822c917287f8789e2a29da46&txTime=5F487961";    //此处填写您的 rtmp 推流地址
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
