//  WatchLivePlayViewController.m
//  Calsee2qdsme
//
//  Created by SCHENK on 2020/8/27.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import "WatchLivePlayViewController.h"
#import "TXLivePlayer.h"
#import "WatchLivePlayDiscussCell.h"
#import "ReportReasonView.h"
#import "CollectModel.h"
#import <CommonCrypto/CommonDigest.h>
@interface WatchLivePlayViewController ()<TXLivePlayListener ,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate>
{
     UIView               *_videoView;             // 视频画面
     TX_Enum_PlayType     _playType;               // 播放类型
     UIView* bottomView;
     CGRect _rect;
     UITextField *chartTF;
  
    UIButton *returnBtn;
      
    UIButton *alertBtn;
     
    UIButton *sendBtn;
    BOOL isBottom;
    
    UIImageView *userImageView;//用户头像
    UILabel *nameLab;//用户名称
    UILabel*numLab;//在线人数
    UIButton *collectBtn;//收藏按钮
    UIScrollView *userScroll;//右侧用户头像滚图
    UIView *topView;
    
    
    
}
@property (nonatomic, strong) TXLivePlayer *player;
@property (nonatomic, strong) NSString *playUrl;


@end

@implementation WatchLivePlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNotification];
    // Do any additional setup after loading the view from its nib.
        // 创建播放器
    _player = [[TXLivePlayer alloc] init];
    
    TXLivePlayConfig* config = _player.config;
    // 开启 flvSessionKey 数据回调
    //config.flvSessionKey = @"X-Tlive-SpanId";
    // 允许接收消息
    config.enableMessage = YES;
    [_player setConfig:config];
    
    
    [self creatUI];
 
    
   [self.navigationItem setHidesBackButton:TRUE animated:NO];

 //   self.playUrl = @"rtmp://playlive2.calseeglobal.com/live/011518756447?txSecret=ecada4a08aa7fe0d53523d6acb2cc608&txTime=5F4DB565";
    

    isBottom=NO;
    
    _roomid=@"011518756447";
    
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
            NSString *appkey=@"2aab1d8f1639b1765d88cdd84e92e69c";
            NSString *appName=@"live";
         
            NSString *result=[NSString stringWithFormat:@"%@%@%@",appkey,_roomid,str1];
            NSString *url=@"playlive2.calseeglobal.com";
            NSString *md5Str=[self md5String:result];
 
    self.playUrl =[NSString stringWithFormat:@"rtmp://%@/%@/%@?txSecret=%@&txTime=%@",url,appName,_roomid,md5Str,str1];
    if (![self startPlay]) {
               return;
           }
    
}


- ( NSString *)md5String:( NSString *)str
{
    
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
- (NSString *)getHexByDecimal:(NSInteger)decimal
{
    
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
-(void)creatUI
{

     _videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
     _videoView.backgroundColor=[UIColor lightGrayColor];
     [self.view addSubview:_videoView];
     
     CGFloat statusBarHeight = 0.f;
      if (@available(iOS 13.0, *)) {
          statusBarHeight = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame.size.height;
      } else {
          statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
      }
     
     topView = [[UIView alloc] initWithFrame:CGRectMake(0, statusBarHeight, ScreenW, 64)];
     topView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    [self.view addSubview:topView];
      
     UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW/2, 64)];
     leftView.backgroundColor = [UIColor clearColor];
     [topView addSubview:leftView];
     
      collectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
     collectBtn.frame=CGRectMake(ScreenW/2-60, 15, 60, 35);
     collectBtn.backgroundColor=Color(@"#EA5B1E");
     [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [collectBtn setTitle:@"已收藏" forState:UIControlStateSelected];
    collectBtn.selected=NO;
      [collectBtn addTarget:self action:@selector(collectPress) forControlEvents:UIControlEventTouchUpInside];
     collectBtn.titleLabel.font=[UIFont systemFontOfSize:14];
   
     collectBtn.layer.masksToBounds = YES;
     collectBtn.layer.cornerRadius =15;
      [leftView addSubview:collectBtn];
     
     userImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 15, 35, 35)];
     userImageView.layer.masksToBounds = YES;
     userImageView.layer.cornerRadius = userImageView.frame.size.width/2;
     userImageView.image=[UIImage imageNamed:@"ic_placeholder"];
     [leftView addSubview:userImageView];
     
     
     nameLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(userImageView.frame)+5, 15, ScreenW/2-60-45, 12)];
     nameLab.text=@"北京机床精密器材有限公司";
     nameLab.textColor=[UIColor whiteColor];
     nameLab.font=[UIFont systemFontOfSize:12];
     [leftView addSubview:nameLab];
     
       numLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(userImageView.frame)+5, 35, ScreenW/2-60-45, 12)];
       numLab.text=@"1人";
       numLab.textColor=[UIColor whiteColor];
       numLab.font=[UIFont systemFontOfSize:12];
       [leftView addSubview:numLab];
     
//     UIScrollView *scroll=[[UIScrollView alloc]initWithFrame:CGRectMake( ScreenW/2, 0, ScreenW/2, 64)];
//     scroll.backgroundColor=[UIColor yellowColor];
//     [topView addSubview:scroll];
     
    [self initScrollView];
   
    
    
     
     UIButton *vedioBtn=[UIButton buttonWithType:UIButtonTypeCustom];
     vedioBtn.frame=CGRectMake(ScreenW-80, CGRectGetMaxY(topView.frame), 80, 40);
     vedioBtn.backgroundColor=[UIColor clearColor];
     [self.view addSubview:vedioBtn];
     
     UILabel *vedioLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 15, 60, 35)];
     vedioLab.text=@"   视频";
     vedioLab.textAlignment=NSTextAlignmentCenter;
     vedioLab.backgroundColor=[UIColor colorWithWhite:0.f alpha:0.7];
     vedioLab.textColor=[UIColor whiteColor];
     vedioLab.font=[UIFont systemFontOfSize:14];
     [vedioBtn addSubview:vedioLab];
     
    
     UIImageView *vedioImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 15, 35, 35)];
     vedioImageView.image=[UIImage imageNamed:@"icon_klive_lx"];
     [vedioBtn addSubview:vedioImageView];
     
     UIButton *chatBtn=[UIButton buttonWithType:UIButtonTypeCustom];
     chatBtn.frame=CGRectMake(ScreenW-80, CGRectGetMaxY(vedioBtn.frame)+5, 80, 40);
     chatBtn.backgroundColor=[UIColor clearColor];
     [self.view addSubview:chatBtn];
     
     
     UILabel *chatLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 15, 60, 35)];
       chatLab.text=@"   私聊";
       chatLab.textAlignment=NSTextAlignmentCenter;
       chatLab.backgroundColor=[UIColor colorWithWhite:0.f alpha:0.7];
       chatLab.textColor=[UIColor whiteColor];
       chatLab.font=[UIFont systemFontOfSize:14];
       [chatBtn addSubview:chatLab];
       
      
       UIImageView *chatImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 15, 35, 35)];
       chatImageView.image=[UIImage imageNamed:@"icon_klive_chat"];
       [chatBtn addSubview:chatImageView];
     
     
     
     UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, ScreenH-60-ScreenH/3, ScreenW/2, ScreenH/3) style:UITableViewStylePlain];
      tableView.backgroundColor=[UIColor clearColor];
      tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      tableView.delegate = self;
      tableView.dataSource = self;
      [tableView registerClass:[WatchLivePlayDiscussCell class] forCellReuseIdentifier:@"WatchLivePlayDiscussCell"];
      [self.view addSubview:tableView];
     
     
     bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH-60, ScreenW, 60)];
     bottomView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
     [self.view addSubview:bottomView];
     
      _rect = bottomView.frame;
     
     returnBtn=[UIButton buttonWithType:UIButtonTypeCustom];
       returnBtn.frame=CGRectMake(ScreenW-44, 10, 44, 35);
      returnBtn.backgroundColor=[UIColor clearColor];
      [returnBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
     returnBtn.hidden=NO;
     [returnBtn addTarget:self action:@selector(returnPress) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:returnBtn];
     
     alertBtn=[UIButton buttonWithType:UIButtonTypeCustom];
       alertBtn.frame=CGRectMake(ScreenW-44-50, 10, 44, 35);
       alertBtn.backgroundColor=[UIColor clearColor];
      [alertBtn setImage:[UIImage imageNamed:@"icon_tip"] forState:UIControlStateNormal];
     [alertBtn addTarget:self action:@selector(alertPerss) forControlEvents:UIControlEventTouchUpInside];
     [bottomView addSubview:alertBtn];
       alertBtn.hidden=NO;
    
      sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
       sendBtn.frame=CGRectMake(ScreenW-80, 10, 60, 35);
       sendBtn.backgroundColor=Color(@"#EA5B1E");
      [sendBtn setTitle:@"发送"forState:UIControlStateNormal];
     [sendBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
     sendBtn.hidden=YES;
     [bottomView addSubview:sendBtn];
     
         chartTF=[[UITextField alloc]initWithFrame:CGRectMake(10, 10, ScreenW-100, 35)];
        
          chartTF.backgroundColor =  [UIColor colorWithWhite:0.f alpha:0.7];
          chartTF.textColor=[UIColor whiteColor];
          chartTF.font=[UIFont systemFontOfSize:12];
          chartTF.layer.masksToBounds = YES;
          chartTF.layer.cornerRadius = 10;
          chartTF.layer.borderWidth = 1;
          chartTF.delegate=self;
      
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"  跟企业聊点什么..." attributes:
          @{NSForegroundColorAttributeName:[UIColor whiteColor],
                       NSFontAttributeName:chartTF.font
               }];
          chartTF.attributedPlaceholder = attrString;

          [bottomView addSubview:chartTF];
}
-(void)initScrollView
{
     if(!userScroll){
         userScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(ScreenW/2, 0, ScreenW/2, 54)];
         userScroll.backgroundColor=[UIColor yellowColor];
         userScroll.delegate=self;
         userScroll.scrollEnabled = YES;
         [topView addSubview:userScroll];
      
     }
    else
    {
        for (UIView *view in [userScroll subviews]) {
            [view removeFromSuperview];
        }
    }
    
        for (int i=0; i<  6 ;i++) {
            UIImageView *view=[[UIImageView alloc]initWithFrame:CGRectMake(i* 35+5, 10,  35, 35)];
            view.backgroundColor=[UIColor redColor];
                    view.layer.masksToBounds = YES;
                        view.layer.cornerRadius = view.frame.size.width/2;
                        [userScroll addSubview:view];
                      
                    }
            [userScroll setContentSize:CGSizeMake(35 * 20, 0)];
                
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)initNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    if (isBottom) {
        //得到键盘高度
        NSDictionary *userInfo = [notification userInfo];
        NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        // - 49
        bottomView.frame = CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds) - keyboardRect.size.height - 50, CGRectGetWidth(bottomView.frame), CGRectGetHeight(bottomView.frame));
        bottomView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        chartTF.backgroundColor= [UIColor colorWithWhite:1 alpha:1];
         chartTF.textColor=[UIColor blackColor];
         sendBtn.hidden=NO;
    }

    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (isBottom) {
         bottomView.frame = _rect;
           bottomView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
            chartTF.backgroundColor =  [UIColor colorWithWhite:0.f alpha:0.7];
             chartTF.textColor=[UIColor whiteColor];
            sendBtn.hidden=YES;
    }
   
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
     isBottom=YES;
    
   
    return YES;
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    isBottom=NO;
}
-(void)alertPerss
{
    ReportReasonView *view=[[ReportReasonView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    view.reasonBlock = ^(NSString * _Nonnull reason) {
        
    };
    [self.view.window addSubview:view];
    
}
-(void)collectPress
{
    collectBtn.selected=!collectBtn.selected;
    CollectModel *model=[[CollectModel alloc]init];
   
    if (collectBtn.selected) {
        model.type=@"1";
    }
    else
    {
        model.type=@"2";
    }
    model.exhiid=@"";
    model.lang=@"";
    model.ubh=@"";
    model.lx=@"";
    model.id=@"";
    [model CollectModelSuccessBlock:^(NSString * _Nonnull code, NSString * _Nonnull message, id  _Nonnull data) {
        
    } andFailure:^(NSError * _Nonnull error) {
        
    }];
    
}
-(void)sendMessage
{
    
}
-(void)returnPress
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 // [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
 //  [self.navigationController.navigationBar setShadowImage:[UIImage new]];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//   [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
 // [self.navigationController.navigationBar setShadowImage:nil];

     [self stopPlay];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WatchLivePlayDiscussCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WatchLivePlayDiscussCell class])];
    cell.content.text=@"hellohttp://liteavapp.qcloud.com/live/liteavdemoplayerstreamid.flv";
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (BOOL)startPlay {
    
         NSString *playUrl =  self.playUrl;
         
         if (![self checkPlayUrl:playUrl]) {
             return NO;
         }
         [_player setDelegate:self];
         [_player setupVideoWidget:CGRectMake(0, 0, ScreenW, ScreenH) containView:_videoView insertIndex:0];
         // [_player seek:480];//从几秒开播
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
    NSLog(@"SSSS %d",EvtID);
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
            NSData *msgData = param[@"EVT_GET_MSG"];
            NSString *msg = [[NSString alloc] initWithData:msgData encoding:NSUTF8StringEncoding];
            [MBProgressHUD showError:msg toView:self.view];
        }
        else if (EvtID == EVT_VIDEO_PLAY_END) {
            [self.navigationController popViewControllerAnimated:YES];
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
