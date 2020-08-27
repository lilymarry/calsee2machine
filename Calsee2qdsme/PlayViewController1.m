//
//  PlayViewController1.m
//  Calsee2qdsme
//
//  Created by SCHENK on 2020/8/21.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import "PlayViewController1.h"
#import "TXLivePlayer.h"

@interface PlayViewController1 ()<TXLivePlayListener>
{
     UIView               *_videoView;             // 视频画面
     TX_Enum_PlayType     _playType;               // 播放类型
}

@property (nonatomic, strong) TXLivePlayer *player;
@property (nonatomic, strong) NSString *playUrl;
@end

@implementation PlayViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
        // 创建播放器
    _player = [[TXLivePlayer alloc] init];
    
    TXLivePlayConfig* config = _player.config;
    // 开启 flvSessionKey 数据回调
    //config.flvSessionKey = @"X-Tlive-SpanId";
    // 允许接收消息
    config.enableMessage = YES;
    [_player setConfig:config];
    
    
 //   CGRect videoFrame = self.view.bounds;
    _videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenW, ScreenW*2/3)];
    _videoView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:_videoView];
    
    self.playUrl = @"http://liteavapp.qcloud.com/live/liteavdemoplayerstreamid.flv";
    
      if (![self startPlay]) {
                 return;
             }
    
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [self stopPlay];
}
- (BOOL)startPlay {
   //  CGRect frame = CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
   //   _videoView.frame = frame;
        
         
         NSString *playUrl =  self.playUrl;
         
         if (![self checkPlayUrl:playUrl]) {
             return NO;
         }
         
         [_player setDelegate:self];
         [_player setupVideoWidget:CGRectMake(0, 64, ScreenW, ScreenW*2/3) containView:_videoView insertIndex:0];
         
         
         int ret = [_player startPlay:playUrl type:_playType];
         
//         frame = CGRectMake(0, 64, ScreenW, ScreenW*2/3);
//         [UIView animateWithDuration:0.4 animations:^{
//             _videoView.frame =  CGRectMake(0, 64, ScreenW, ScreenW*2/3);
//         } completion:^(BOOL finished) {
//
//         }];

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

@end
