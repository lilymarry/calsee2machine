//
//  RoomLiveViewController.m
//  Calsee2qdsme
//
//  Created by zell on 2020/8/27.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import "RoomLiveViewController.h"
#import <TXLiteAVSDK_Professional/TRTCCloud.h>
#import "LoginBL.h"
@interface RoomLiveViewController ()<TRTCCloudDelegate>
{
    NSMutableDictionary *remoteViewDic;
    NSMutableArray *uidArr;
    int videoNum;
    int audioNum;
    UIView *remoteViewOwen;
    UIView *tongbuBackView;
    UIView *topBackView;
    NSString *roomid;
    NSString *benrenUid;
    NSString *userID;
    NSMutableArray *mixUserArr;
    TRTCTranscodingConfig *config;
    NSTimer *timer;
    int leixing;
    UILabel *daojishiLab;
    long miaoshu;
}
@property (nonatomic, strong) TRTCCloud *trtcCloud;
@end

@implementation RoomLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    remoteViewDic = [[NSMutableDictionary alloc]init];
    uidArr = [[NSMutableArray alloc]init];
    videoNum = 0;
    audioNum = 0;
    // 登录
//    [[TRTCCalling shareInstance] login:1400419433 user:@"sc" userSig:[GenerateTestUserSig genTestUserSig:@"eJwtzF0LgjAUxvHvsttCzubGUuiqV0woyD6AumOc3ljTSoy*ezK9fH4P-L8sS4-BGx2LmQiATf0mg4*GKvJcl6PW5ppbS4bFXAJIHskwHB5sLTnsXSklAGDQhu7eopnSWmo1VujcRz*OLosi4RV0xU2ctkv9pNceXbQ5ZLhud*mEZKco4flqzn5-df0wPg__"] success:^{
//         NSLog(@"Video call login success.");
//        // 发起视频通话
//        [[TRTCCalling shareInstance] call:@"cs" type:CallType_Video];
//    } failed:^(int code, NSString *error) {
//         NSLog(@"Video call login failed.");
//    }];
    _trtcCloud = [TRTCCloud sharedInstance];
    
    _trtcCloud.delegate = self;
    [self setBtuView];
    [self creatTopView];
    [self huoUserLX];
    [self enterRoom];
    
    // 1.监听回调
//    [[TRTCCalling shareInstance] addDelegate:self];
    // Do any additional setup after loading the view.
}
-(void)huoUserLX{
    
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
    [LoginBL GainUserInfo:dic success:^(NSMutableDictionary *returnValue) {
//        leixing = [[returnValue objectForKey:@""] intValue];
        NSString *userLXStr = [returnValue objectForKey:@"user_lx"];
        if ([userLXStr isEqualToString:@"参展商"]) {
            self->daojishiLab.hidden = NO;
            self->leixing = 1;
        }
        
    } failure:^(NSString *errorMessage) {
        
    }];
    
}
-(void)creatTopView{
    
    topBackView = [[UIView alloc]initWithFrame:CGRectMake(0, LL_StatusBarHeight, [UIApplication sharedApplication].keyWindow.frame.size.width, 44)];
    [topBackView setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.4f]];
    [[UIApplication sharedApplication].keyWindow addSubview:topBackView];
    
    UIButton *backBtu = [[UIButton alloc]initWithFrame:CGRectMake(20, 10, 29, 23)];
    [backBtu addTarget:self action:@selector(closeRoom) forControlEvents:UIControlEventTouchUpInside];
//    [backBtu setBackgroundColor:[UIColor whiteColor]];
    [backBtu setBackgroundImage:[UIImage imageNamed:@"biaoqingDel"] forState:UIControlStateNormal];
    [topBackView addSubview:backBtu];
    
    daojishiLab = [[UILabel alloc]initWithFrame:CGRectMake(52, 11, [UIApplication sharedApplication].keyWindow.frame.size.width-104, 22)];
    daojishiLab.font = [UIFont systemFontOfSize:17];
    daojishiLab.textColor = [UIColor whiteColor];
    daojishiLab.hidden = YES;
    daojishiLab.textAlignment = NSTextAlignmentCenter;
    [topBackView addSubview:daojishiLab];
    
}
-(void)setBtuView{
    tongbuBackView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height-140, [UIApplication sharedApplication].keyWindow.frame.size.width, 140)];
    [tongbuBackView setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.4f]];
    [[UIApplication sharedApplication].keyWindow addSubview:tongbuBackView];
//    UIButton *closeRoomBtu = [[UIButton alloc]initWithFrame:CGRectMake(20, LL_StatusBarHeight, 40, 40)];
//    [closeRoomBtu addTarget:self action:@selector(closeRoom) forControlEvents:UIControlEventTouchUpInside];
//    [closeRoomBtu setBackgroundColor:[UIColor whiteColor]];
//    [self.view addSubview:closeRoomBtu];
    
//    UIView *controllView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-100-LL_TabbarSafeBottomMargin, self.view.frame.size.width, 100)];
//    [self.view addSubview:controllView];
    
//    tongbuBackView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height-140, [UIApplication sharedApplication].keyWindow.frame.size.width, 140)];
//        [tongbuBackView setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.4f]];
//        [[UIApplication sharedApplication].keyWindow addSubview:tongbuBackView];

        
        UIButton *selectCameraBtu = [[UIButton alloc]initWithFrame:CGRectMake((tongbuBackView.frame.size.width-118)/4, 46, 30, 30)];
        [selectCameraBtu addTarget:self action:@selector(selectCamera) forControlEvents:UIControlEventTouchUpInside];
    //    [selectCameraBtu setBackgroundColor:[UIColor whiteColor]];
        [selectCameraBtu setBackgroundImage:[UIImage imageNamed:@"toggleCameraIcon"] forState:UIControlStateNormal];
    //    selectCameraBtu.layer.masksToBounds = YES;
    //    selectCameraBtu.layer.cornerRadius = selectCameraBtu.frame.size.width / 2;
        
    //    selectCameraBtu.layer.borderWidth = 1.0f;
    //    selectCameraBtu.layer.borderColor = [[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1] CGColor];
        [tongbuBackView addSubview:selectCameraBtu];
        
        UIButton *closeVideoBtu = [[UIButton alloc]initWithFrame:CGRectMake((tongbuBackView.frame.size.width-118)/4+30+((tongbuBackView.frame.size.width-118)/4), 39, 44, 44)];
    [closeVideoBtu addTarget:self action:@selector(closeVideo:) forControlEvents:UIControlEventTouchUpInside];
    //    [closeVideoBtu setBackgroundColor:[UIColor whiteColor]];
        [closeVideoBtu setBackgroundImage:[UIImage imageNamed:@"icon_avp_video_white"] forState:UIControlStateNormal];
    //    closeVideoBtu.layer.masksToBounds = YES;
    //    closeVideoBtu.layer.cornerRadius = selectCameraBtu.frame.size.width / 2;
        
    //    closeVideoBtu.layer.borderWidth = 1.0f;
    //    closeVideoBtu.layer.borderColor = [[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1] CGColor];
        [tongbuBackView addSubview:closeVideoBtu];
        
        UIButton *closeAvdioBtu = [[UIButton alloc]initWithFrame:CGRectMake((tongbuBackView.frame.size.width-118)/4+74+((tongbuBackView.frame.size.width-118)/4)+((tongbuBackView.frame.size.width-118)/4), 39, 44, 44)];
    [closeAvdioBtu addTarget:self action:@selector(closeAvdio:) forControlEvents:UIControlEventTouchUpInside];
    //    [closeAvdioBtu setBackgroundColor:[UIColor whiteColor]];
        [closeAvdioBtu setBackgroundImage:[UIImage imageNamed:@"icon_avp_mute_white"] forState:UIControlStateNormal];
    //    closeAvdioBtu.layer.masksToBounds = YES;
    //    closeAvdioBtu.layer.cornerRadius = selectCameraBtu.frame.size.width / 2;
        
    //    closeAvdioBtu.layer.borderWidth = 1.0f;
    //    closeAvdioBtu.layer.borderColor = [[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1] CGColor];
        [tongbuBackView addSubview:closeAvdioBtu];
    
}
-(void)enterRoom{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSString *userbh = [[NSUserDefaults standardUserDefaults] objectForKey:Userbh];
    if (userbh.length>0) {
      [dic setObject:userbh forKey:@"ubh"];
    }
    NSString *langus = [[NSUserDefaults standardUserDefaults] objectForKey:Lang];
    if (userbh.length>0) {
      
    }else{
        langus = @"";
    }
    [dic setObject:exhiid2 forKey:@"exhiid"];
    [dic setObject:langus forKey:@"lang"];
    [LoginBL UserLogin:dic success:^(NSMutableDictionary *returnValue) {
        TRTCParams *params = [[TRTCParams alloc]init];
            params.sdkAppId = 1400382996;
            params.userId = [returnValue objectForKey:@"userid"];
        self->userID = [returnValue objectForKey:@"userid"];
        self->benrenUid = [returnValue objectForKey:@"userid"];
            params.userSig = [returnValue objectForKey:@"sig"];
        //    params.userSig = @"eJyrVgrxCdYrSy1SslIy0jNQ0gHzM1NS80oy0zLBwsnFUNHilOzEgoLMFCUrQxMDAxNDSxNjY4hMakVBZlEqUNzU1NTIwMAAIlqSmQsWs7QwtTQ0MLWAmpKZDjTUxS*51Kw8NTfL3SXVNa3Awi1GP6vK0yk7qjQ8x6kiyzg0Nack2y8vRj*sIi-UVqkWAOCFMeY_";
            
            params.roomId = [[returnValue objectForKey:@"roomid"] intValue];
        self->roomid = [returnValue objectForKey:@"roomid"];
        NSString *timeY = [returnValue objectForKey:@"etime"];
        //1.【字符串插入】
//        double time = [RoomLiveViewController CurTimeMilSec:timeY];
//        time += 8*3600;
        
//        NSString *timeStamp2 = @"1414956901";
//        long long int date1 = (long long int)[timeStamp2 intValue];
//        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:time];
//        NSLog(@"时间戳转日期 %@  = %@", timeY, date2);
         

         NSMutableString* str1=[[NSMutableString alloc]initWithString:timeY];//存在堆区，可变字符串
        NSRange range={10,1};//字符串覆盖另一个字符串（覆盖范围可以设定）

        [str1 replaceCharactersInRange:range withString:@"T"];
         NSLog(@"str1:%@",str1);

          [str1 insertString:@"+0000"atIndex:19];//把一个字符串插入另一个字符串中的某一个位置

          NSLog(@"str1:%@",str1);

        

         
        
        NSString *timeStr =[self getLocalDateFormateUTCDate: str1] ;
        double endTime = [RoomLiveViewController CurTimeMilSec:timeStr];
        
        NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式

        double nowTime = [datenow timeIntervalSince1970];
//
        self->miaoshu = endTime - nowTime;
        
        self->timer  =  [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(Timered) userInfo:nil repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:self->timer forMode:NSDefaultRunLoopMode];
        
        
//        miaoshu = []
        [self->_trtcCloud enterRoom:params appScene:TRTCAppSceneVideoCall];
            TRTCVideoEncParam *videoEncParam = [[TRTCVideoEncParam alloc]init];
        //    videoEncParam.videoResolution = TRTCVideoResolution._640_360
            videoEncParam.videoResolution = TRTCVideoResolution_640_360;
            videoEncParam.videoBitrate = 550;
            videoEncParam.videoFps = 15;
        [self->_trtcCloud setVideoEncoderParam:videoEncParam];
    } failure:^(NSString *errorMessage) {
        
    }];
    
    
    
    
}

-(void)onEnterRoom:(NSInteger)result{
    if (result > 0) {
        NSLog(@"进房成功，总计耗时[%ld]ms",(long)result);
        remoteViewOwen = [[UIView alloc]initWithFrame:CGRectMake(0, LL_StatusBarHeight,(self.view.frame.size.width)/2 , (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/3)];
//        remoteViewOwen = [[UIView alloc]initWithFrame:CGRectMake(0, LL_StatusBarHeight, self.view.frame.size.width, self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)];
        [self.view addSubview:remoteViewOwen];
        [remoteViewDic setObject:remoteViewOwen forKey:benrenUid];
        [uidArr addObject:benrenUid];
        [self yunduanLuzhi];
                [_trtcCloud startLocalPreview:YES view:remoteViewOwen];
                [_trtcCloud setLocalViewFillMode:TRTCVideoFillMode_Fill];
        
//                [_trtcCloud setVideoEncoderParam:TRTCVideoEncParam];
                [_trtcCloud startLocalAudio];
    }else{
        NSLog(@"进房失败，错误码[\(%ld)]",(long)result);
    }
    
    
}
-(void)onUserLeave:(NSString *)uid{
    
}
- (void)onRemoteUserEnterRoom:(NSString *)userId{
    // 连麦者的画面位置
    long numUser = [remoteViewDic allKeys].count;
    long numchu = numUser/2;
    TRTCMixUser* remote2 = [TRTCMixUser new];
    remote2.userId = userId;
    remote2.zOrder = 1;
    remote2.rect   = CGRectMake((((self.view.frame.size.width-30)/2)*(numUser%2)), LL_StatusBarHeight+((self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/3)*numchu,(self.view.frame.size.width)/2, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/3);//仅供参考
    remote2.roomID = roomid; // 本地用户不用填写 roomID，远程需要
    [mixUserArr addObject:remote2];
    config.mixUsers = mixUserArr;
    // 发起云端混流
    [_trtcCloud setMixTranscodingConfig:config];
    
    
}

- (void)onRemoteUserLeaveRoom:(NSString *)userId reason:(NSInteger)reason{
    
//    [uidArr removeObject:userId];
//    UIView *remoteview = [remoteViewDic objectForKey:userId];
//    [remoteview removeFromSuperview];
//    [remoteViewDic removeObjectForKey:userId];
    [_trtcCloud stopRemoteView:userId];
//    [self setViewBuju:userId];
    
}
-(void)onUserVideoAvailable:(NSString *)uid available:(BOOL)available{
    
    UIView *remoteView;
    if ([[remoteViewDic allKeys] containsObject:uid]) {
        remoteView = [remoteViewDic objectForKey:uid];
    }else{
        long numUser = [remoteViewDic allKeys].count;
        long numchu = numUser/2;
        remoteView = [[UIView alloc]initWithFrame:CGRectMake((((self.view.frame.size.width-30)/2)*(numUser%2)), LL_StatusBarHeight+((self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/3)*numchu,(self.view.frame.size.width)/2, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/3)];
       /* if (uidArr.count == 1) {
            remoteView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, 0, 0)];
        }else if(uidArr.count == 2){
            remoteView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, self.view.frame.size.height, 0, 0)];
        }else if(uidArr.count == 3){
            remoteView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, self.view.frame.size.height, 0, 0)];
        }else if(uidArr.count == 4){
            remoteView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, 0, 0)];
        }else if(uidArr.count == 5){
            remoteView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, self.view.frame.size.height, 0, 0)];
        }*/
        
        [self.view addSubview:remoteView];
        [uidArr addObject:uid];
    }
    [remoteViewDic setObject:remoteView forKey:uid];
    
//    [self setViewBuju:uid];
    if (available) {
        [_trtcCloud startRemoteView:uid view:remoteView];
        [_trtcCloud setRemoteViewFillMode:uid mode:TRTCVideoFillMode_Fill];
    }else{
        [_trtcCloud stopRemoteView:uid];
        
    }
    
}
-(void)setViewBuju:(NSString *)uid{
    
    long keyNub = uidArr.count;
        if (keyNub == 2) {
//
            [UIView animateWithDuration:0.5 animations:^{
                NSString *uidl = [self->uidArr objectAtIndex:0];
                UIView *aview = [self->remoteViewDic objectForKey:uidl];
                [aview setFrame:CGRectMake(0, LL_StatusBarHeight, self.view.frame.size.width, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/2)];
                NSString *uidb = [self->uidArr objectAtIndex:1];
                UIView *bview = [self->remoteViewDic objectForKey:uidb];
                [bview setFrame:CGRectMake(0, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/2+LL_StatusBarHeight, self.view.frame.size.width, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/2)];
                
    //            [self->dic setObject:bview forKey:@"b"];
                
            }];
            
            
        }else if(keyNub == 3){
            
            [UIView animateWithDuration:0.5 animations:^{
                NSString *uidb = [self->uidArr objectAtIndex:1];
                UIView *bview = [self->remoteViewDic objectForKey:uidb];
                [bview setFrame:CGRectMake(0, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/2+LL_StatusBarHeight, self.view.frame.size.width/2, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/2)];
                NSString *uidc = [self->uidArr objectAtIndex:2];
                UIView *cview = [self->remoteViewDic objectForKey:uidc];
                [cview setFrame:CGRectMake(self.view.frame.size.width/2, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/2+LL_StatusBarHeight, self.view.frame.size.width/2, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/2)];
    //            [cview setBackgroundColor:[UIColor cyanColor]];
    //            [self->dic setObject:cview forKey:@"c"];
    //            [self.view addSubview:cview];
            }];
        }else if(keyNub == 4){
            
            [UIView animateWithDuration:0.5 animations:^{
                NSString *uida = [self->uidArr objectAtIndex:0];
                        UIView *aview = [self->remoteViewDic objectForKey:uida];
                        [aview setFrame:CGRectMake(0, LL_StatusBarHeight, self.view.frame.size.width/2, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/2)];
                NSString *uidb = [self->uidArr objectAtIndex:1];
                UIView *bview = [self->remoteViewDic objectForKey:uidb];
                [bview setFrame:CGRectMake(self.view.frame.size.width/2, LL_StatusBarHeight, self.view.frame.size.width/2, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/2)];
                NSString *uidc = [self->uidArr objectAtIndex:2];
                UIView *cview = [self->remoteViewDic objectForKey:uidc];
                [cview setFrame:CGRectMake(0, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/2+LL_StatusBarHeight, self.view.frame.size.width/2, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/2)];
                NSString *uidd = [self->uidArr objectAtIndex:3];
                UIView *dview = [self->remoteViewDic objectForKey:uidd];
                [dview setFrame:CGRectMake(self.view.frame.size.width/2, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/2+LL_StatusBarHeight, self.view.frame.size.width/2, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/2)];
    //            [dview setBackgroundColor:[UIColor darkGrayColor]];
    //            [self->dic setObject:dview forKey:@"d"];
    //            [self.view addSubview:dview];
            }];
        }else if(keyNub == 5){
            
                    [UIView animateWithDuration:0.5 animations:^{
                        NSString *uida = [self->uidArr objectAtIndex:0];
                                UIView *aview = [self->remoteViewDic objectForKey:uida];
                                [aview setFrame:CGRectMake(0, LL_StatusBarHeight, self.view.frame.size.width/2, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/3)];
                        NSString *uidb = [self->uidArr objectAtIndex:1];
                        UIView *bview = [self->remoteViewDic objectForKey:uidb];
                        [bview setFrame:CGRectMake(self.view.frame.size.width/2, LL_StatusBarHeight, self.view.frame.size.width/2, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/3)];
                        NSString *uidc = [self->uidArr objectAtIndex:2];
                        UIView *cview = [self->remoteViewDic objectForKey:uidc];
                        [cview setFrame:CGRectMake(0, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/3+LL_StatusBarHeight, self.view.frame.size.width/2, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/3)];
                        NSString *uidd = [self->uidArr objectAtIndex:3];
                        UIView *dview = [self->remoteViewDic objectForKey:uidd];
                        [dview setFrame:CGRectMake(self.view.frame.size.width/2, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/3+LL_StatusBarHeight, self.view.frame.size.width/2, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/3)];
                        NSString *uide = [self->uidArr objectAtIndex:4];
                        UIView *eview = [self->remoteViewDic objectForKey:uide];
                        [eview setFrame:CGRectMake(0, ((self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/3)*2+LL_StatusBarHeight, self.view.frame.size.width/2, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/3)];
                    }];
            
        }else if (keyNub == 6){
            
            [UIView animateWithDuration:0.5 animations:^{
                NSString *uida = [self->uidArr objectAtIndex:0];
                        UIView *aview = [self->remoteViewDic objectForKey:uida];
                        [aview setFrame:CGRectMake(0, LL_StatusBarHeight, self.view.frame.size.width/2, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/3)];
                NSString *uidb = [self->uidArr objectAtIndex:1];
                UIView *bview = [self->remoteViewDic objectForKey:uidb];
                [bview setFrame:CGRectMake(self.view.frame.size.width/2, LL_StatusBarHeight, self.view.frame.size.width/2, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/3)];
                NSString *uidc = [self->uidArr objectAtIndex:2];
                UIView *cview = [self->remoteViewDic objectForKey:uidc];
                [cview setFrame:CGRectMake(0, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/3+LL_StatusBarHeight, self.view.frame.size.width/2, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/3)];
                NSString *uidd = [self->uidArr objectAtIndex:3];
                UIView *dview = [self->remoteViewDic objectForKey:uidd];
                [dview setFrame:CGRectMake(self.view.frame.size.width/2, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/3+LL_StatusBarHeight, self.view.frame.size.width/2, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/3)];
                NSString *uide = [self->uidArr objectAtIndex:4];
                UIView *eview = [self->remoteViewDic objectForKey:uide];
                [eview setFrame:CGRectMake(0, ((self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/3)*2+LL_StatusBarHeight, self.view.frame.size.width/2, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/3)];
                NSString *uidf = [self->uidArr objectAtIndex:5];
                UIView *fview = [self->remoteViewDic objectForKey:uidf];
                [fview setFrame:CGRectMake(self.view.frame.size.width/2, ((self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/3)*2+LL_StatusBarHeight, self.view.frame.size.width/2, (self.view.frame.size.height-LL_StatusBarHeight-LL_TabbarSafeBottomMargin)/3)];
            }];
        }else{
            
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
        [btu setBackgroundImage:[UIImage imageNamed:@"icon_avp_video_gray"] forState:UIControlStateNormal];
    }else{
        [_trtcCloud startLocalPreview:YES view:remoteViewOwen];
        [btu setBackgroundImage:[UIImage imageNamed:@"icon_avp_video_white"] forState:UIControlStateNormal];
    }
    
}
-(void)closeAvdio:(UIButton *)btu{
    audioNum +=1;
    if (audioNum %2 == 1) {
        [_trtcCloud stopLocalAudio];
        [btu setBackgroundImage:[UIImage imageNamed:@"icon_avp_mute_gray"] forState:UIControlStateNormal];
    }else{
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
      
    }else{
        userbh = @"";
    }
    NSString *langus = [[NSUserDefaults standardUserDefaults] objectForKey:Lang];
    if (userbh.length>0) {
      
    }else{
        langus = @"";
    }
    [dic setObject:userbh forKey:@"ubh"];
    [dic setObject:langus forKey:@"lang"];
    [dic setObject:exhiid2 forKey:@"exhiid"];
    [dic setObject:roomid forKey:@"roomid"];
    [LoginBL UserLeaveRoom:dic success:^(NSMutableDictionary *returnValue) {
        
        
        
        
    } failure:^(NSString *errorMessage) {
        
    }];
    [timer invalidate];

    timer = nil;
    [_trtcCloud stopLocalAudio];
    [_trtcCloud stopLocalPreview];
    [topBackView removeFromSuperview];
    [tongbuBackView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}












-(void)onError:(TXLiteAVError)errCode errMsg:(NSString *)errMsg extInfo:(NSDictionary *)extInfo{
    
    if (errCode == ERR_ROOM_ENTER_FAIL) {
        NSLog(@"%@", [NSString stringWithFormat:@"进房失败[%@]",errMsg]);
    }
    
    
}

-(void)yunduanLuzhi{
    
    TRTCTranscodingConfig *config = [[TRTCTranscodingConfig alloc] init];
    // 设置分辨率为720 × 1280, 码率为1500kbps，帧率为20FPS
    config.videoWidth      = 720;
    config.videoHeight     = 1280;
    config.videoBitrate    = 1500;
    config.videoFramerate  = 20;
    config.videoGOP        = 2;
    config.audioSampleRate = 48000;
    config.audioBitrate    = 64;
    config.audioChannels   = 2;
    // 采用预排版模式
    config.mode = TRTCTranscodingConfigMode_Template_PresetLayout;
    NSMutableArray *mixUserArr = [[NSMutableArray alloc]init];
    config.mixUsers = [[NSMutableArray alloc]init];

    // 主播摄像头的画面位置
    TRTCMixUser* local = [TRTCMixUser new];
    local.userId = userID;
    local.zOrder = 1;   // zOrder 为0代表主播画面位于最底层
    local.rect   = CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.frame.size.width, [UIApplication sharedApplication].keyWindow.frame.size.height);
    local.roomID = nil; // 本地用户不用填写 roomID，远程需要
    [mixUserArr addObject:local];
    config.mixUsers = mixUserArr;
    // 发起云端混流
    [_trtcCloud setMixTranscodingConfig:config];
    
    
    
    
}

-(void)Timered{
    miaoshu-=1;
    daojishiLab.text = [self getMMSSFromSS:[NSString stringWithFormat:@"%ld",miaoshu]];
    
    if (miaoshu == 300) {
        NSDictionary *dict =@{NSFontAttributeName:[UIFont systemFontOfSize:11.f ]};
        CGSize infoSize = CGSizeMake(MAXFLOAT, 17);
        CGSize size = [@"会议还有5分钟就要结束了" boundingRectWithSize:infoSize options:NSStringDrawingUsesLineFragmentOrigin  | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
        UILabel *callStateLab = [[UILabel alloc]initWithFrame:CGRectMake(([UIApplication sharedApplication].keyWindow.frame.size.width-40-size.width)/2, [UIApplication sharedApplication].keyWindow.frame.size.height-170, size.width+40, 17)];
        
        
        [callStateLab setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.8f]];
        
        callStateLab.textColor = [UIColor whiteColor];
        callStateLab.textAlignment = NSTextAlignmentCenter;
        callStateLab.font = [UIFont systemFontOfSize:17.0f];
        callStateLab.text = @"会议还有5分钟就要结束了";
        [self.view addSubview:callStateLab];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
            [callStateLab removeFromSuperview];
        });//这句话的意思是1.5秒后，把label移出视图
    }else if (miaoshu == 30){
        NSDictionary *dict =@{NSFontAttributeName:[UIFont systemFontOfSize:11.f ]};
        CGSize infoSize = CGSizeMake(MAXFLOAT, 17);
        CGSize size = [@"会议还有5分钟就要结束了" boundingRectWithSize:infoSize options:NSStringDrawingUsesLineFragmentOrigin  | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
        UILabel *callStateLab = [[UILabel alloc]initWithFrame:CGRectMake(([UIApplication sharedApplication].keyWindow.frame.size.width-40-size.width)/2, [UIApplication sharedApplication].keyWindow.frame.size.height-170, size.width+40, 17)];
        
        
        [callStateLab setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.8f]];
        
        callStateLab.textColor = [UIColor whiteColor];
        callStateLab.textAlignment = NSTextAlignmentCenter;
        callStateLab.font = [UIFont systemFontOfSize:17.0f];
        callStateLab.text = @"会议还有30秒就要结束了";
        [self.view addSubview:callStateLab];
        

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                [callStateLab removeFromSuperview];
            });//这句话的意思是1.5秒后，把label移出视图
    }
    
}

-(NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:utcDate];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}


+(double) CurTimeMilSec:(NSString*)pstrTime
{
    NSDateFormatter *pFormatter= [[NSDateFormatter alloc]init];
    [pFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *pCurrentDate = [pFormatter dateFromString:pstrTime];
    return [pCurrentDate timeIntervalSince1970];
}
//传入 秒  得到 xx:xx:xx
-(NSString *)getMMSSFromSS:(NSString *)totalTime{

    NSInteger seconds = [totalTime integerValue];

    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];

    return format_time;

}
@end
