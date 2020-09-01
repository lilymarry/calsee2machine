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
}

@property (nonatomic, strong) TXVodPlayer *player;
@property (nonatomic, strong) NSString *playUrl;
@property (nonatomic, strong) UITextView *contentTxt;

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
      collectBtn.frame=CGRectMake(10, 10, 60, 35);
     
      [collectBtn setTitle:@"<返回" forState:UIControlStateNormal];
       [collectBtn addTarget:self action:@selector(collectPress) forControlEvents:UIControlEventTouchUpInside];
    
      collectBtn.titleLabel.font=[UIFont systemFontOfSize:17];
    [collectBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [topView addSubview:collectBtn];
    

    _videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenW, ScreenW*2/3)];
    _videoView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:_videoView];
    
    // 创建播放器
     _player = [[TXVodPlayer alloc] init];
    [_player setupVideoWidget:_videoView insertIndex:0];
    
    _contentTxt = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_videoView.frame)+10, ScreenW, ScreenH-ScreenW*2/3-64-20)];
    _contentTxt.editable=NO;
    _contentTxt.font=[UIFont systemFontOfSize:14];
    _contentTxt.text=@"美国媒体已经很久没有报道黑人抗议事件了，然而这并不代表黑人抗议在美国已经平息了下来。仅仅只是美国大选占据了其篇幅，一旦发生重大规模的情况，该被曝出的还是得被曝出来\n今天推特热搜上就曝出了一个美国警察枪击黑人的视频，随即受到了海外网友的疯狂转发，因为这次事件似乎让美国的黑人再次感受到了极大的不安全。一名白人警察对一名黑人连开7枪。据视频内容显示，两名警察拿着枪勒令一名穿着白色体恤的黑人男子布莱克停止移动，但布莱克并没有理会，更是直接来到一辆suv前打开车门意欲离开。白人警察冲了过去并揪住了布莱克的脖子，随后视频中传来7声枪响.";
    [self.view addSubview:_contentTxt];
    

    
  // NSString* url = @"http://1252463788.vod2.myqcloud.com/xxxxx/v.f20.mp4";
 // [_player startPlay:url ];
    

//        p.appId = 1252463788;
//        p.fileId = @"4564972819220421305";
    
  
        TXPlayerAuthParams *p = [TXPlayerAuthParams new];
        p.appId = 1301332811;
        p.fileId = @"5285890805172256660";
        
         int ret=  [_player startPlayWithParams:p];
           
           _player.vodDelegate=self;
            
           if (ret==0) {
               NSLog(@"ssss ok");
           }
           else
           {
               NSLog(@"ssss %d",ret);
           }
    
    
    
//    // 调整进度
//    [_player seek:slider.value];
//    // 暂停播放
//    [_player pause];
//    // 恢复播放
//    [_player resume];
    
//    // 停止播放
//
    
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
   else  if (EvtID == PLAY_EVT_PLAY_PROGRESS) {
            // 加载进度, 单位是秒, 小数部分为毫秒
            double playable = [param[EVT_PLAYABLE_DURATION] doubleValue];
            //    [_loadProgressBar setValue:playable];//

            // 播放进度, 单位是秒, 小数部分为毫秒
            double progress = [param[EVT_PLAY_PROGRESS] doubleValue];
             //   [_seekProgressBar setValue:progress];

            // 视频总长, 单位是秒, 小数部分为毫秒
            double duration = [param[EVT_PLAY_DURATION] doubleValue];
            // 可以用于设置时长显示等等
        
      
    }
   else if (EvtID == PLAY_EVT_GET_MESSAGE) {
        NSData *msgData = param[@"EVT_GET_MSG"];
        NSString *msg = [[NSString alloc] initWithData:msgData encoding:NSUTF8StringEncoding];
        [MBProgressHUD showError:msg toView:self.view];
    }
     else  if (EvtID == PLAY_EVT_PLAY_END)
    {
        //直播结束
        [_player stopPlay];
        [_player removeVideoWidget]; // 记得销毁 view 控件
    }
    
}




@end
