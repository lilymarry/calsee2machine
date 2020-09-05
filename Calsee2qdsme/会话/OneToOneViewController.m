//
//  OneToOneViewController.m
//  Calsee2qdsme
//
//  Created by zell on 2020/8/29.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import "OneToOneViewController.h"
#import <TXLiteAVSDK_Professional/TRTCCloud.h>
#import "LoginBL.h"
#import "CommonClass.h"
#import "HujiaoView.h"
@interface OneToOneViewController ()<TRTCCloudDelegate>
{
    NSMutableDictionary *remoteViewDic;
    NSMutableArray *uidArr;
    int videoNum;
    int audioNum;
    UIView *remoteViewOwen;
    UIView *tongbuBackView;
    NSTimer *timer;
    NSString *roomID;
    HujiaoView *hujiao;
    UIView *remoteView;
    UILabel *videoTishiLab;
    UILabel *AudioTishiLab;
}
@property (nonatomic, strong) TRTCCloud *trtcCloud;
@end

@implementation OneToOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    remoteViewDic = [[NSMutableDictionary alloc]init];
    uidArr = [[NSMutableArray alloc]init];
    videoNum = 0;
    audioNum = 0;
    _trtcCloud = [TRTCCloud sharedInstance];
    
    _trtcCloud.delegate = self;
    
    remoteView = [[UIView alloc]initWithFrame:CGRectMake(0, LL_StatusBarHeight, self.view.frame.size.width, self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)];
        
    [self.view addSubview:remoteView];
    remoteViewOwen = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2+15, self.view.frame.size.height-390, self.view.frame.size.width/2-30, 200)];
    [self.view addSubview:remoteViewOwen];
    if (self.callFrom == 1) {
        [self creatHujiaoView];
        [self hujiao];
    }else{
        [self creatHujiaoView];
        [self hujiao];
    }
    
    
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [tongbuBackView removeFromSuperview];
    
    
}
-(void)creatHujiaoView{
    hujiao = [[HujiaoView alloc]initWithFrame:CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.frame.size.width, [UIApplication sharedApplication].keyWindow.frame.size.height)];
    [hujiao setBackgroundColor:[UIColor colorWithRed:53/255.0 green:118/255.0 blue:202/255.0 alpha:1.0]];
    [hujiao setviewInfo:self.callFrom];
    
    [hujiao.guaduanBtu addTarget:self action:@selector(guaduan) forControlEvents:UIControlEventTouchUpInside];
    [hujiao.jietingBtu addTarget:self action:@selector(jieting) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:hujiao];
    
    
}
-(void)jieting{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSString *userbh = [[NSUserDefaults standardUserDefaults] objectForKey:Userbh];
    if (userbh.length>0) {
      
    }
    NSString *langus = [[NSUserDefaults standardUserDefaults] objectForKey:Lang];
    if (userbh.length>0) {
      
    }else{
        langus = @"";
    }
    [dic setObject:userbh forKey:@"ubh"];
    [dic setObject:langus forKey:@"lang"];
    [dic setObject:exhiid2 forKey:@"exhiid"];
    [dic setObject:self.roomid forKey:@"roomid"];
    
    [LoginBL CallForAnyUser:dic success:^(NSMutableDictionary *returnValue) {
        if ([[returnValue objectForKey:@"callzt"] intValue] == 2) {
            self.roomsig = [returnValue objectForKey:@"sig"];
            self.userid = [returnValue objectForKey:@"userid"];
            [self->hujiao removeFromSuperview];
            [self->timer invalidate];
            self->timer = nil;
            [self setBtuView];
            [self enterRoom];
        }else if ([[returnValue objectForKey:@"callzt"] intValue] == 3){
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            NSString *userbh = [[NSUserDefaults standardUserDefaults] objectForKey:Userbh];
            if (userbh.length>0) {
              
            }
            NSString *langus = [[NSUserDefaults standardUserDefaults] objectForKey:Lang];
            if (userbh.length>0) {
              
            }else{
                langus = @"";
            }
            [dic setObject:userbh forKey:@"ubh"];
            [dic setObject:langus forKey:@"lang"];
            [dic setObject:exhiid2 forKey:@"exhiid"];
            [dic setObject:self.roomid forKey:@"roomid"];
            [LoginBL UserLeaveRoom:dic success:^(NSMutableDictionary *returnValue) {
                
            } failure:^(NSString *errorMessage) {
                
            }];
            [self->timer invalidate];
            self->timer = nil;
            [self->hujiao removeFromSuperview];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSString *errorMessage) {
        
    }];
}
-(void)guaduan{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSString *userbh = [[NSUserDefaults standardUserDefaults] objectForKey:Userbh];
    if (userbh.length>0) {
      
    }
    NSString *langus = [[NSUserDefaults standardUserDefaults] objectForKey:Lang];
    if (userbh.length>0) {
      
    }else{
        langus = @"";
    }
    [dic setObject:userbh forKey:@"ubh"];
    [dic setObject:langus forKey:@"lang"];
    [dic setObject:exhiid2 forKey:@"exhiid"];
    [dic setObject:self.roomid forKey:@"roomid"];
    [LoginBL UserGuaduanRoom:dic success:^(NSMutableDictionary *returnValue) {
        
    } failure:^(NSString *errorMessage) {
        
    }];
    [timer invalidate];
    timer = nil;
    [hujiao removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)hujiao{
    if (self.callzt == 1) {
        timer  =  [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(Timered) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self->timer forMode:NSDefaultRunLoopMode];
    }else{
        timer  =  [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(Timered) userInfo:nil repeats:YES];
               [[NSRunLoop mainRunLoop] addTimer:self->timer forMode:NSDefaultRunLoopMode];
        
    }
    /*NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSString *userbh = [[NSUserDefaults standardUserDefaults] objectForKey:Userbh];
    if (userbh.length>0) {
      
    }
    [dic setObject:userbh forKey:@"ubh"];
    [dic setObject:@"cn" forKey:@"lang"];
    [dic setObject:exhiid2 forKey:@"exhiid"];
    int type = 1;
    if(type == 1){//金融、采购、参展商
        [dic setObject:@"companyId" forKey:@"cid"];
        [dic setObject:@"" forKey:@"uid"];
                           
    }else if(type ==2){//人才、公司的具体某个人
        [dic setObject:@"" forKey:@"cid"];
        [dic setObject:@"rcID" forKey:@"uid"];
    }
    
    [LoginBL CallUserRepace:dic success:^(NSMutableDictionary *returnValue) {
//        self->roomID = @"";
        
        
        
        
        
        
    } failure:^(NSString *errorMessage) {
        
    }];*/
    
    
    
}
-(void)Timered{
    
    NSMutableDictionary *dic2 = [[NSMutableDictionary alloc]init];
    NSString *userbh = [[NSUserDefaults standardUserDefaults] objectForKey:Userbh];
    if (userbh.length>0) {
      
    }
    NSString *langus = [[NSUserDefaults standardUserDefaults] objectForKey:Lang];
    if (userbh.length>0) {
      
    }else{
        langus = @"";
    }
    [dic2 setObject:userbh forKey:@"ubh"];
    [dic2 setObject:langus forKey:@"lang"];
    [dic2 setObject:exhiid2 forKey:@"exhiid"];
    [dic2 setObject:self.roomid forKey:@"roomid"];
    
    [LoginBL CallWait:dic2 success:^(NSMutableDictionary *returnValue) {
        if ([[returnValue objectForKey:@"callzt"] intValue] == 1) {
            [self->hujiao removeFromSuperview];
            [self->timer invalidate];
            self->timer = nil;
            [self setBtuView];
            [self enterRoom];
        }else if ([[returnValue objectForKey:@"callzt"] intValue] == 3){
            [[CommonClass sharedManager] callStateLab:@"对方已挂断"];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            NSString *userbh = [[NSUserDefaults standardUserDefaults] objectForKey:Userbh];
            if (userbh.length>0) {
              
            }
            NSString *langus = [[NSUserDefaults standardUserDefaults] objectForKey:Lang];
            if (userbh.length>0) {
              
            }else{
                langus = @"";
            }
            [dic setObject:userbh forKey:@"ubh"];
            [dic setObject:langus forKey:@"lang"];
            [dic setObject:exhiid2 forKey:@"exhiid"];
            [dic setObject:self.roomid forKey:@"roomid"];
            [LoginBL UserLeaveRoom:dic success:^(NSMutableDictionary *returnValue) {
                
            } failure:^(NSString *errorMessage) {
                
            }];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
                
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self->hujiao removeFromSuperview];
                [self->tongbuBackView removeFromSuperview];
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
    } failure:^(NSString *errorMessage) {
        
    }];
    
}
-(void)setBtuView{
    tongbuBackView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height-190, [UIApplication sharedApplication].keyWindow.frame.size.width, 190)];
//    [tongbuBackView setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.4f]];
    [[UIApplication sharedApplication].keyWindow addSubview:tongbuBackView];
//    UIButton *closeRoomBtu = [[UIButton alloc]initWithFrame:CGRectMake(20, LL_StatusBarHeight, 40, 40)];
//    [closeRoomBtu addTarget:self action:@selector(closeRoom) forControlEvents:UIControlEventTouchUpInside];
//    [closeRoomBtu setBackgroundColor:[UIColor whiteColor]];
//    [self.view addSubview:closeRoomBtu];
    
//    UIView *controllView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-100-LL_TabbarSafeBottomMargin, self.view.frame.size.width, 100)];
//    [self.view addSubview:controllView];
    
    UIButton *guaduanBtu = [[UIButton alloc]initWithFrame:CGRectMake((tongbuBackView.frame.size.width-60)/2, 0, 60, 60)];
    [guaduanBtu setBackgroundImage:[UIImage imageNamed:@"icon_call_reject_normal"] forState:UIControlStateNormal];
    [guaduanBtu addTarget:self action:@selector(closeRoom) forControlEvents:UIControlEventTouchUpInside];
    [tongbuBackView addSubview:guaduanBtu];
    
//    tongbuBackView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height-140, [UIApplication sharedApplication].keyWindow.frame.size.width, 140)];
//        [tongbuBackView setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.4f]];
//        [[UIApplication sharedApplication].keyWindow addSubview:tongbuBackView];

        
        UIButton *selectCameraBtu = [[UIButton alloc]initWithFrame:CGRectMake((tongbuBackView.frame.size.width-132)/4+7, 96, 30, 30)];
        [selectCameraBtu addTarget:self action:@selector(selectCamera) forControlEvents:UIControlEventTouchUpInside];
    //    [selectCameraBtu setBackgroundColor:[UIColor whiteColor]];
        [selectCameraBtu setBackgroundImage:[UIImage imageNamed:@"toggleCameraIcon"] forState:UIControlStateNormal];
    //    selectCameraBtu.layer.masksToBounds = YES;
    //    selectCameraBtu.layer.cornerRadius = selectCameraBtu.frame.size.width / 2;
        
    //    selectCameraBtu.layer.borderWidth = 1.0f;
    //    selectCameraBtu.layer.borderColor = [[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1] CGColor];
        [tongbuBackView addSubview:selectCameraBtu];
        
        UIButton *closeVideoBtu = [[UIButton alloc]initWithFrame:CGRectMake((tongbuBackView.frame.size.width-132)/4+30+14+((tongbuBackView.frame.size.width-132)/4), 89, 44, 44)];
    [closeVideoBtu addTarget:self action:@selector(closeVideo:) forControlEvents:UIControlEventTouchUpInside];
    //    [closeVideoBtu setBackgroundColor:[UIColor whiteColor]];
        [closeVideoBtu setBackgroundImage:[UIImage imageNamed:@"icon_avp_video_white"] forState:UIControlStateNormal];
    //    closeVideoBtu.layer.masksToBounds = YES;
    //    closeVideoBtu.layer.cornerRadius = selectCameraBtu.frame.size.width / 2;
        
    //    closeVideoBtu.layer.borderWidth = 1.0f;
    //    closeVideoBtu.layer.borderColor = [[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1] CGColor];
        [tongbuBackView addSubview:closeVideoBtu];
    videoTishiLab = [[UILabel alloc]initWithFrame:CGRectMake((tongbuBackView.frame.size.width-132)/4+30+14+((tongbuBackView.frame.size.width-132)/4)-12, 89+44+5, 80, 11)];
    videoTishiLab.text = @"请开启摄像头";
    videoTishiLab.textColor = [UIColor whiteColor];
    videoTishiLab.textAlignment = NSTextAlignmentCenter;
    videoTishiLab.font = [UIFont systemFontOfSize:11];
    videoTishiLab.hidden = YES;
    [tongbuBackView addSubview:videoTishiLab];
        
        UIButton *closeAvdioBtu = [[UIButton alloc]initWithFrame:CGRectMake((tongbuBackView.frame.size.width-132)/4+74+14+((tongbuBackView.frame.size.width-132)/4)+((tongbuBackView.frame.size.width-132)/4), 89, 44, 44)];
    [closeAvdioBtu addTarget:self action:@selector(closeAvdio:) forControlEvents:UIControlEventTouchUpInside];
    //    [closeAvdioBtu setBackgroundColor:[UIColor whiteColor]];
        [closeAvdioBtu setBackgroundImage:[UIImage imageNamed:@"icon_avp_mute_white"] forState:UIControlStateNormal];
    //    closeAvdioBtu.layer.masksToBounds = YES;
    //    closeAvdioBtu.layer.cornerRadius = selectCameraBtu.frame.size.width / 2;
        
    //    closeAvdioBtu.layer.borderWidth = 1.0f;
    //    closeAvdioBtu.layer.borderColor = [[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1] CGColor];
        [tongbuBackView addSubview:closeAvdioBtu];
    AudioTishiLab = [[UILabel alloc]initWithFrame:CGRectMake((tongbuBackView.frame.size.width-132)/4+74+14+((tongbuBackView.frame.size.width-132)/4)+((tongbuBackView.frame.size.width-132)/4)-12, 89+44+5, 80, 11)];
    AudioTishiLab.text = @"请开启麦克风";
    AudioTishiLab.textColor = [UIColor whiteColor];
    AudioTishiLab.textAlignment = NSTextAlignmentCenter;
    AudioTishiLab.font = [UIFont systemFontOfSize:11];
    AudioTishiLab.hidden = YES;
    [tongbuBackView addSubview:AudioTishiLab];
    
}
-(void)enterRoom{
    TRTCParams *params = [[TRTCParams alloc]init];
    params.sdkAppId = 1400382996;
    params.userId = self.userid;
    params.userSig = self.roomsig;
//    params.userSig = @"eJyrVgrxCdYrSy1SslIy0jNQ0gHzM1NS80oy0zLBwsnFUNHilOzEgoLMFCUrQxMDAxNDSxNjY4hMakVBZlEqUNzU1NTIwMAAIlqSmQsWs7QwtTQ0MLWAmpKZDjTUxS*51Kw8NTfL3SXVNa3Awi1GP6vK0yk7qjQ8x6kiyzg0Nack2y8vRj*sIi-UVqkWAOCFMeY_";
    
    params.roomId = [self.roomid intValue];
    [_trtcCloud enterRoom:params appScene:TRTCAppSceneVideoCall];
    TRTCVideoEncParam *videoEncParam = [[TRTCVideoEncParam alloc]init];
//    videoEncParam.videoResolution = TRTCVideoResolution._640_360
    videoEncParam.videoResolution = TRTCVideoResolution_640_360;
    videoEncParam.videoBitrate = 550;
    videoEncParam.videoFps = 15;
    [_trtcCloud setVideoEncoderParam:videoEncParam];
    
    
}
-(void)onEnterRoom:(NSInteger)result{
    if (result > 0) {
        NSLog(@"进房成功，总计耗时[%ld]ms",(long)result);
//        remoteViewOwen = [[UIView alloc]initWithFrame:CGRectMake(10, 40+10+LL_StatusBarHeight,(self.view.frame.size.width-30)/2 , (self.view.frame.size.height-140-LL_TabbarSafeBottomMargin)/3)];
        
        
//        [remoteViewDic setObject:remoteViewOwen forKey:@"sc"];
//        [uidArr addObject:@"sc"];
                [_trtcCloud startLocalPreview:YES view:remoteViewOwen];
                [_trtcCloud setLocalViewFillMode:TRTCVideoFillMode_Fill];
        
        //        [_trtcCloud setVideoEncoderParam:TRTCVideoEncParam];
                [_trtcCloud startLocalAudio];
    }else{
        NSLog(@"进房失败，错误码[\(%ld)]",(long)result);
    }
    
    
}
-(void)onUserLeave:(NSString *)uid{
//    [uidArr removeObject:uid];
//    UIView *remoteview = [remoteViewDic objectForKey:uid];
//    [remoteview removeFromSuperview];
//    [remoteViewDic removeObjectForKey:uid];
    [_trtcCloud stopRemoteView:uid];
    
}
- (void)onRemoteUserLeaveRoom:(NSString *)userId reason:(NSInteger)reason{
    
    [_trtcCloud stopRemoteView:userId];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSString *userbh = [[NSUserDefaults standardUserDefaults] objectForKey:Userbh];
    if (userbh.length>0) {
      
    }
    NSString *langus = [[NSUserDefaults standardUserDefaults] objectForKey:Lang];
    if (userbh.length>0) {
      
    }else{
        langus = @"";
    }
    [dic setObject:userbh forKey:@"ubh"];
    [dic setObject:langus forKey:@"lang"];
    [dic setObject:exhiid2 forKey:@"exhiid"];
    [dic setObject:self.roomid forKey:@"roomid"];
    [LoginBL UserLeaveRoom:dic success:^(NSMutableDictionary *returnValue) {
        
    } failure:^(NSString *errorMessage) {
        
    }];
    [self->tongbuBackView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onUserVideoAvailable:(NSString *)uid available:(BOOL)available{
    
    if (available) {
        [_trtcCloud startRemoteView:uid view:remoteView];
        [_trtcCloud setRemoteViewFillMode:uid mode:TRTCVideoFillMode_Fill];
    }else{
        [_trtcCloud stopRemoteView:uid];
    }
    
}

-(void)onUserAudioAvailable:(NSString *)uid available:(BOOL)available{
    
    if (available) {
        
    }else{
//        [_trtcCloud stopRemoteView:uid];
        
    }
    
    
}
-(void)selectCamera{
    
    [_trtcCloud switchCamera];
}
-(void)closeVideo:(UIButton *)btu{
    videoNum +=1;
    if (videoNum %2 == 1) {
        [_trtcCloud stopLocalPreview];
        videoTishiLab.hidden = NO;
        [btu setBackgroundImage:[UIImage imageNamed:@"icon_avp_video_gray"] forState:UIControlStateNormal];
    }else{
        videoTishiLab.hidden = YES;
        [_trtcCloud startLocalPreview:YES view:remoteViewOwen];
        [btu setBackgroundImage:[UIImage imageNamed:@"icon_avp_video_white"] forState:UIControlStateNormal];
    }
    
}
-(void)closeAvdio:(UIButton *)btu{
    audioNum +=1;
    if (audioNum %2 == 1) {
        [_trtcCloud stopLocalAudio];
        AudioTishiLab.hidden = NO;
        [btu setBackgroundImage:[UIImage imageNamed:@"icon_avp_mute_gray"] forState:UIControlStateNormal];
    }else{
        
        AudioTishiLab.hidden = YES;
        [_trtcCloud startLocalAudio];
        [btu setBackgroundImage:[UIImage imageNamed:@"icon_avp_mute_white"] forState:UIControlStateNormal];
    }
}

-(void)closeRoom{
    [_trtcCloud exitRoom];
}
-(void)onExitRoom:(NSInteger)reason{
    
    NSLog(@"likaifangjian=================");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSString *userbh = [[NSUserDefaults standardUserDefaults] objectForKey:Userbh];
    if (userbh.length>0) {
      
    }
    NSString *langus = [[NSUserDefaults standardUserDefaults] objectForKey:Lang];
    if (userbh.length>0) {
      
    }else{
        langus = @"";
    }
    [dic setObject:userbh forKey:@"ubh"];
    [dic setObject:langus forKey:@"lang"];
    [dic setObject:exhiid2 forKey:@"exhiid"];
    [dic setObject:self.roomid forKey:@"roomid"];
    [LoginBL UserLeaveRoom:dic success:^(NSMutableDictionary *returnValue) {
        
    } failure:^(NSString *errorMessage) {
        
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onError:(TXLiteAVError)errCode errMsg:(NSString *)errMsg extInfo:(NSDictionary *)extInfo{
    
    if (errCode == ERR_ROOM_ENTER_FAIL) {
        NSLog(@"%@", [NSString stringWithFormat:@"进房失败[%@]",errMsg]);
    }
    
    
}
@end
