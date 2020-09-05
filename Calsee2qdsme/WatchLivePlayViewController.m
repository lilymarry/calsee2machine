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
#import "InRoomModel.h"
#import "LiveUserModel.h"
#import "AccusationModel.h"
#import "LivechatModel.h"
#import "ChatWebViewController.h"
#import "HasKeFuModel.h"
#import "IntoroomModel.h"
#import "OneToOneViewController.h"
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
    
    
    NSTimer         *getDataTimer;
    NSInteger timerCount;
    
    NSString *lastId;
    
    NSMutableArray *userArr;
    NSMutableArray *chatlist;
    
    UITableView *tableView;
    
    
}
@property (nonatomic, strong) TXLivePlayer *player;
@property (nonatomic, strong) NSString *playUrl;


@end

@implementation WatchLivePlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    chatlist=   [NSMutableArray array];
    [self initNotification];
   
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
    
    
    lastId=@"";
    isBottom=NO;
    
   NSString * roomid=_mainDic[@"roomid"];
    
    NSDate *currentDate = [NSDate date];
    // 指定日期声明
    NSTimeInterval oneDay = 12 * 60 *60;  // 12H一共有多少秒
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
    
    NSString *result=[NSString stringWithFormat:@"%@%@%@",appkey,roomid,str1];
    NSString *url=@"playlive2.calseeglobal.com";
    NSString *md5Str=[self md5String:result];
    self.playUrl =[NSString stringWithFormat:@"rtmp://%@/%@/%@?txSecret=%@&txTime=%@",url,appName,roomid,md5Str,str1];
  //self.playUrl = @"http://liteavapp.qcloud.com/live/liteavdemoplayerstreamid.flv";
    
    if (![self startPlay]) {
        return;
    }
    [self startGetDataTimer];
    [self getData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //  [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    //   [self inRoomWithType:@"inroom"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
  
}

#pragma  mark--------  计时器
-(void)startGetDataTimer
{
    timerCount=1;
    getDataTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadView) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:getDataTimer  forMode:NSRunLoopCommonModes];
}
-(void)reloadView
{
    
    timerCount++;
    NSLog(@"timerCount  %ld",(long)timerCount);
    if (timerCount%5==0)
    {
        [self getData];
    }
}
-(void)getData
{
    LiveUserModel *model=[[LiveUserModel alloc]init];
    model.exhiid= [[NSUserDefaults standardUserDefaults] objectForKey:Exhibh];
    model.lang=[[NSUserDefaults standardUserDefaults] objectForKey:Lang];
    model.ubh=[[NSUserDefaults standardUserDefaults] objectForKey:Userbh];;
    model.lastid=lastId;
    model.roomid=_mainDic[@"roomid"];
    
    [model LiveUserModelSuccessBlock:^(NSMutableDictionary * _Nonnull returnValue) {
        if ([returnValue[@"code"] isEqualToString:@"100"]) {
            
            self->userArr=[NSMutableArray arrayWithArray:returnValue[@"detail"][@"userlist"]];
            
            [self->chatlist addObjectsFromArray:returnValue[@"detail"][@"chatlist"] ];
            
            
            self->numLab.text=[NSString stringWithFormat:@"%d人",(int)[self->userArr count]];
            NSArray *arr=returnValue[@"detail"][@"chatlist"];
            if (arr.count>0) {
                NSDictionary*dic=[arr lastObject];
                self->lastId=dic[@"id"];
            }
            
            [self->tableView reloadData];
            [self initScrollView];
        }
        
    } failure:^(NSString * _Nonnull errorMessage) {
        
    }];
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
    
    
    
    userImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 15, 35, 35)];
    userImageView.layer.masksToBounds = YES;
    userImageView.layer.cornerRadius = userImageView.frame.size.width/2;
    NSString* encodedString =[_mainDic[@"Logo"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [userImageView sd_setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"ic_placeholder"]];
    
    
    [leftView addSubview:userImageView];
    
    
    nameLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(userImageView.frame)+5, 15, ScreenW/2-60-45, 12)];
    nameLab.text=_mainDic[@"liveName"];
    nameLab.textColor=[UIColor whiteColor];
    nameLab.font=[UIFont systemFontOfSize:12];
    [leftView addSubview:nameLab];
    
    numLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(userImageView.frame)+5, 35, ScreenW/2-60-45, 12)];
    numLab.text=[NSString stringWithFormat:@"%@人",_mainDic[@"showNum"]];
    numLab.textColor=[UIColor whiteColor];
    numLab.font=[UIFont systemFontOfSize:12];
    [leftView addSubview:numLab];
    
   if ([_mainDic[@"livetype"] isEqualToString:@"直播"]) {
        
        collectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        collectBtn.frame=CGRectMake(ScreenW/2-60, 15, 60, 35);
        collectBtn.backgroundColor=Color(@"#EA5B1E");
        [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [collectBtn setTitle:@"已收藏" forState:UIControlStateSelected];
        if ([_mainDic[@"isFavourite"] isEqualToString:@"0"]) {
            collectBtn.selected=NO;
        }
        else
        {
            collectBtn.selected=YES;
        }
        
        [collectBtn addTarget:self action:@selector(collectPress) forControlEvents:UIControlEventTouchUpInside];
        collectBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        
        collectBtn.layer.masksToBounds = YES;
        collectBtn.layer.cornerRadius =15;
        [leftView addSubview:collectBtn];
        
        
        UIButton *vedioBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        vedioBtn.frame=CGRectMake(ScreenW-80, CGRectGetMaxY(topView.frame), 80, 40);
        vedioBtn.backgroundColor=[UIColor clearColor];
        [vedioBtn addTarget:self action:@selector(goVedio) forControlEvents:UIControlEventTouchUpInside];
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
        [chatBtn addTarget:self action:@selector(goChat) forControlEvents:UIControlEventTouchUpInside];
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
        
    }
    
    tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, ScreenH-60-ScreenH/3, ScreenW/2, ScreenH/3) style:UITableViewStylePlain];
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
        userScroll.backgroundColor=[UIColor clearColor];
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
    if (userArr.count>0) {
        for (int i=0; i< userArr.count ;i++) {
            UIImageView *view=[[UIImageView alloc]initWithFrame:CGRectMake(i* 37+5, 15,  35, 35)];
            view.backgroundColor=[UIColor whiteColor];
            view.layer.masksToBounds = YES;
            view.image=[UIImage imageNamed:@"ic_placeholder"];
            view.layer.cornerRadius = view.frame.size.width/2;
            NSString *name=userArr[i][@"tx"];
            
            NSString* encodedString =[name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//URL 含有中文 encode 编码
            
            [userImageView  sd_setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"ic_placeholder"]];
            
            [userScroll addSubview:view];
            
        }
        [userScroll setContentSize:CGSizeMake(37 * userArr.count+35, 0)];
    }
}
#pragma mark 私聊
-(void)goChat
{
    ChatWebViewController *chart=[[ChatWebViewController alloc]init];
    
     NSString * exhiid= [[NSUserDefaults standardUserDefaults] objectForKey:Exhibh];
      NSString *langstr=[[NSUserDefaults standardUserDefaults] objectForKey:Lang];
       NSString *ubh=[[NSUserDefaults standardUserDefaults] objectForKey:Userbh];;
    
    NSString *url=  [NSString stringWithFormat:@"https://www.calseeglobal.com/web/ios/chat.aspx?cid=%@&exhiid=%@&ubh=%@&lang=%@",_mainDic[@"cid"],exhiid,ubh,langstr];
    chart.url=url;
  
    [self.navigationController pushViewController:chart animated:YES];
}
-(void)goVedio
{
    HasKeFuModel *model=[[HasKeFuModel alloc]init];
    model.exhiid= [[NSUserDefaults standardUserDefaults] objectForKey:Exhibh];
    model.lang=[[NSUserDefaults standardUserDefaults] objectForKey:Lang];
    model.ubh=[[NSUserDefaults standardUserDefaults] objectForKey:Userbh];;
    model.cid=_mainDic[@"cid"];
    [MBProgressHUD showMessage:nil toView:self.view];
    [model HasKeFuModelSuccess:^(NSMutableDictionary * _Nonnull returnValue) {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([returnValue[@"code"] isEqualToString:@"101"]||[returnValue[@"code"] isEqualToString:@"102"]||[returnValue[@"code"] isEqualToString:@"103"]) {
           
            [MBProgressHUD showError:@"暂无空闲客服" toView:self.view];
        }
        else
        {
             IntoroomModel *room=[[IntoroomModel alloc]init];
              room.exhiid= [[NSUserDefaults standardUserDefaults] objectForKey:Exhibh];
              room.lang=[[NSUserDefaults standardUserDefaults] objectForKey:Lang];
              room.ubh=[[NSUserDefaults standardUserDefaults] objectForKey:Userbh];;
              room.cid=self->_mainDic[@"cid"];
              [MBProgressHUD showMessage:nil toView:self.view];
            [room IntoroomModelSuccess:^(NSMutableDictionary * _Nonnull returnValue) {
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                if ([returnValue[@"code"] isEqualToString:@"100"]) {
                NSDictionary *dic = [returnValue objectForKey:@"detail"];
                                           [self.navigationController setNavigationBarHidden:YES animated:YES];
                                           OneToOneViewController *play=[[OneToOneViewController alloc]init];
                                             play.callFrom = 1;
                                           play.callzt = [[dic objectForKey:@"callzt"] intValue];
                                           play.userid = [dic objectForKey:@"userid"];
                                           play.roomid = [dic objectForKey:@"roomid"];
                                           play.roomsig = [dic objectForKey:@"sig"];
                                           [self.navigationController pushViewController:play animated:YES];
                    }
                else
                {
                     [MBProgressHUD showError:returnValue[@"message"] toView:self.view];
                }
            } failure:^(NSString * _Nonnull errorMessage) {
              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 [MBProgressHUD showError:@"网络错误 "toView:self.view];
            }];
           
          
        }
        
    } failure:^(NSString * _Nonnull errorMessage) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络错误 "toView:self.view];
    }];
}
-(void)alertPerss
{
    ReportReasonView *view=[[ReportReasonView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    view.reasonBlock = ^(NSString * _Nonnull reason) {
        
        if (reason.length==0) {
            [MBProgressHUD showError:@"请输入举报理由"toView:self.view];
            return;
        }
        AccusationModel *model=[[AccusationModel alloc]init];
        model.exhiid= [[NSUserDefaults standardUserDefaults] objectForKey:Exhibh];
        model.lang=[[NSUserDefaults standardUserDefaults] objectForKey:Lang];
        model.ubh=[[NSUserDefaults standardUserDefaults] objectForKey:Userbh];;
        model.roomid=self.mainDic[@"roomid"];
        model.content=reason;
        [MBProgressHUD showMessage:nil toView:self.view];
        [model AccusationModelSuccess:^(NSMutableDictionary * _Nonnull returnValue) {
              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
              if ([returnValue[@"code"] isEqualToString:@"100"]) {
                  
                    [MBProgressHUD showSuccess:@"举报成功" toView:self.view];
                }
        } failure:^(NSString * _Nonnull errorMessage) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             [MBProgressHUD showError:@"网络错误 "toView:self.view];
        }];
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
    model.exhiid= [[NSUserDefaults standardUserDefaults] objectForKey:Exhibh];
    model.lang=[[NSUserDefaults standardUserDefaults] objectForKey:Lang];
    model.ubh=[[NSUserDefaults standardUserDefaults] objectForKey:Userbh];;
    model.lx=@"2";
    model.id=_mainDic[@"cid"];
    [MBProgressHUD showMessage:nil toView:self.view];
    [model CollectModelSuccessBlock:^(NSMutableDictionary * _Nonnull returnValue) {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([returnValue[@"code"] isEqualToString:@"100"]) {
            NSLog(@"收藏成功");
        }
    } failure:^(NSString * _Nonnull errorMessage) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络错误，稍后再试" toView:self.view];
    }];
    
}
-(void)sendMessage
{
    [self.view endEditing:YES];

      if (chartTF.text.length==0) {
              [MBProgressHUD showError:@"请输入聊天内容"toView:self.view];
              return;
          }
    LivechatModel *model=[[LivechatModel alloc]init];
    model.exhiid= [[NSUserDefaults standardUserDefaults] objectForKey:Exhibh];
    model.lang=[[NSUserDefaults standardUserDefaults] objectForKey:Lang];
    model.ubh=[[NSUserDefaults standardUserDefaults] objectForKey:Userbh];;
    model.roomid=_mainDic[@"roomid"];
    model.nr=chartTF.text;
    [MBProgressHUD showMessage:nil toView:self.view];
    [model LivechatModelSuccess:^(NSMutableDictionary * _Nonnull returnValue) {
          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([returnValue[@"code"] isEqualToString:@"100"]) {
            NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
            [dic setValue:@"我" forKey:@"mc"];
            [dic setValue:self->chartTF.text forKey:@"nr"];
            [self->chatlist addObject:dic];
            [MBProgressHUD showSuccess:@"发送成功" toView:self.view];
            self->chartTF.text=nil;
        }
    } failure:^(NSString * _Nonnull errorMessage) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络错误 "toView:self.view];

    }];
    
}
-(void)returnPress
{
    [self inRoomWithType:@"outroom"];
    [self stopPlay];
    [getDataTimer invalidate];
    getDataTimer=nil;
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)inRoomWithType:(NSString *)type
{
    InRoomModel *model=[[InRoomModel alloc]init];
    model.exhiid= [[NSUserDefaults standardUserDefaults] objectForKey:Exhibh];
    model.lang=[[NSUserDefaults standardUserDefaults] objectForKey:Lang];
    model.ubh=[[NSUserDefaults standardUserDefaults] objectForKey:Userbh];;
    model.roomid=_mainDic[@"roomid"];
    model.type=@"0";
    [model InRoomModelSuccess:^(NSMutableDictionary * _Nonnull returnValue) {
    } failure:^(NSString * _Nonnull errorMessage) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络错误，稍后再试" toView:self.view];
    }];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return chatlist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WatchLivePlayDiscussCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WatchLivePlayDiscussCell class])];
    NSDictionary *dic=chatlist[indexPath.row];
    cell.content.text=[NSString stringWithFormat:@"%@:%@",dic[@"mc"],dic[@"nr"]];
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
 //   NSDictionary *dict = param;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (EvtID == PLAY_EVT_PLAY_BEGIN) {
            //  [self stopLoadingAnimation];
            
        } else if (EvtID == -2301) {
            
            [MBProgressHUD showSuccess:@"直播已结束" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self  returnPress];
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
            
            
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
        //        else if (EvtID == EVT_VIDEO_PLAY_END) {
        //            [self.navigationController popViewControllerAnimated:YES];
        //        }
        
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
