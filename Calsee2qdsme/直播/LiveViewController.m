//
//  LiveViewController.m
//  Calsee2qdsme
//
//  Created by zell on 2020/8/27.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import "LiveViewController.h"
#import "TXLiteAVSDK_Professional/TXLiteAVSDK.h"
#import "pushLiveView.h"
#import "scrollTextView.h"
#import "LoginBL.h"
#import <CommonCrypto/CommonCrypto.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface LiveViewController ()
{
    pushLiveView *plv;
    NSMutableArray *textarr;
    NSMutableArray *companyArr;
    UIScrollView *joinUserIconView;
    UIScrollView *joinTextShowView;
    UIView *mengbanView;
    UIButton *startBtu;
    NSTimer *timer;
    NSTimer *timerjishi;
    UILabel *joinCompanyNumLab;
    int jishi;
    long lastMessageID;
    NSString *fdlKey;
    int kaishizhibo;
    int timeNum;
    int zhiborenshu;
}
@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kaishizhibo = 0;
    lastMessageID = 0;
    fdlKey = @"2aab1d8f1639b1765d88cdd84e92e69c";
    textarr = [[NSMutableArray alloc]init];
    companyArr = [[NSMutableArray alloc]init];
    [self.view setBackgroundColor:[UIColor blackColor]];
    plv = [[pushLiveView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self setFullLiveScreen];
    [self setStartLiveBtu];
    [self setButtonTop];
//    [self gainOwnInfo];
    // Do any additional setup after loading the view.
}
-(void)gainOwnInfo{
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
        
        
        
    } failure:^(NSString *errorMessage) {
        
    }];
    
    
    
}

-(void)setFullLiveScreen{
    
    [plv setPushInfor];
    //    [_pusher switchCamera];
    
    [self.view addSubview:plv];
    
}
-(void)setStartLiveBtu{
    
    startBtu = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-220)/2, self.view.frame.size.height-150-LL_TabbarSafeBottomMargin, 220, 60)];
    [startBtu setBackgroundColor:[UIColor redColor]];
    startBtu.layer.masksToBounds = YES;

    startBtu.layer.cornerRadius = 30.0f;
    [startBtu addTarget:self action:@selector(startLive) forControlEvents:UIControlEventTouchUpInside];
    [startBtu setTitle:@"开始直播" forState:UIControlStateNormal];
    [startBtu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:startBtu];
}

-(void)startLive{
    [startBtu removeFromSuperview];
    jishi = 0;
    
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
    [dic setObject:@"1" forKey:@"type"];
    if (_LunTanOrLive == 1) {
        [LoginBL UserLiveRoom:dic success:^(NSMutableDictionary *returnValue) {
            self->kaishizhibo = 1;
            self->timer  =  [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(Timered) userInfo:nil repeats:YES];

            [[NSRunLoop mainRunLoop] addTimer:self->timer forMode:NSDefaultRunLoopMode];
            NSString *hexTime = [self ToHex:[[LiveViewController getNowTimeStamp]longLongValue]];
            NSString *md5Str = [NSString stringWithFormat:@"%@%@%@",self->fdlKey,userbh,hexTime];
            NSString *pushURL = [NSString stringWithFormat:@"rtmp://livepushm.calseeglobal.com/calsee2m/%@?txSecret=%@&txTime=%@",userbh,[LiveViewController md5:md5Str],hexTime];
            
            
            [self->plv.livePusher startPush:pushURL];
            [self setButtonIcon];
            
        } failure:^(NSString *errorMessage) {
            [self.view addSubview:self->startBtu];
        }];
    }else{
        [LoginBL CloseUserLiveRoom:dic success:^(NSMutableDictionary *returnValue) {
            self->kaishizhibo = 1;
            self->timer  =  [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(Timered) userInfo:nil repeats:YES];

            [[NSRunLoop mainRunLoop] addTimer:self->timer forMode:NSDefaultRunLoopMode];
            NSString *hexTime = [self ToHex:[[LiveViewController getNowTimeStamp]longLongValue]];
            NSString *md5Str = [NSString stringWithFormat:@"%@%@%@",self->fdlKey,userbh,hexTime];
            NSString *pushURL = [NSString stringWithFormat:@"rtmp://livepushm.calseeglobal.com/calsee2m/%@?txSecret=%@&txTime=%@",userbh,[LiveViewController md5:md5Str],hexTime];
            [self->plv.livePusher startPush:pushURL];
            [self setButtonIcon];
            
        } failure:^(NSString *errorMessage) {
            [self.view addSubview:self->startBtu];
        }];
        
        
    }
    
    
    
    
    
    
    
}
-(void)setButtonTop{
    //左上角公司视图
        UIView *companyInfoView = [[UIView alloc]initWithFrame:CGRectMake(18, 10+LL_StatusBarHeight, (self.view.frame.size.width-36)/2, 38)];
        UIImageView *touxiangIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 38, 38)];
//    if([self.touxiangUrl rangeOfString: @"../"].location == NSNotFound) {
//
//        self.touxiangUrl = [self.touxiangUrl stringByReplacingOccurrencesOfString:@"../" withString:@""];
//
//    } else {
//
//    }
    NSString* encodedString =[self.touxiangUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//URL 含有中文 encode 编码
    
    [touxiangIcon sd_setImageWithURL:[NSURL URLWithString:encodedString] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image == nil) {
            touxiangIcon.image=[UIImage imageNamed:@"ic_placeholder"];
            touxiangIcon.backgroundColor=[UIColor whiteColor];
        }
    }];
//    [touxiangIcon  sd_setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"ic_placeholder"]];
//    [touxiangIcon sd_setImageWithURL:[NSURL URLWithString:self.touxiangUrl]];
        touxiangIcon.layer.masksToBounds = YES;
        touxiangIcon.layer.cornerRadius = touxiangIcon.frame.size.width / 2;
    
//        [touxiangIcon setBackgroundColor:[LiveViewController RandomColor]];
        [companyInfoView addSubview:touxiangIcon];
        
        UILabel *companyNameLab = [[UILabel alloc]initWithFrame:CGRectMake(48, 4, companyInfoView.frame.size.width-48-34, 14)];
    companyNameLab.text = self.userNameStr;
        companyNameLab.font = [UIFont systemFontOfSize:14.0f];
        companyNameLab.textColor = [UIColor whiteColor];
        [companyInfoView addSubview:companyNameLab];
        joinCompanyNumLab = [[UILabel alloc]initWithFrame:CGRectMake(48, 25, companyInfoView.frame.size.width-48-34, 12)];
        joinCompanyNumLab.text = [NSString stringWithFormat:@"%lu人",(unsigned long)companyArr.count];
           joinCompanyNumLab.font = [UIFont systemFontOfSize:12.0f];
           joinCompanyNumLab.textColor = [UIColor whiteColor];
           [companyInfoView addSubview:joinCompanyNumLab];
        
    
    
    
    
    //    [companyInfoView setBackgroundColor:[UIColor blueColor]];
        [self.view addSubview:companyInfoView];
   //右下角加入人员视图
       joinUserIconView = [[UIScrollView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-36)/2, 10+LL_StatusBarHeight, (self.view.frame.size.width-36)/2, 36)];
       
       
   //    [joinUserIconView setBackgroundColor:[UIColor redColor]];
       [self.view addSubview:joinUserIconView];
    
    UIButton *closeBtu = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-18-27, self.view.frame.size.height-70-LL_TabbarSafeBottomMargin, 27, 30)];
        //    [closeBtu setBackgroundColor:[UIColor yellowColor]];
            [closeBtu setBackgroundImage:[UIImage imageNamed:@"icon_closelive"] forState:UIControlStateNormal];
    //        closeBtu.layer.masksToBounds = YES;
    //
    //        closeBtu.layer.cornerRadius = closeBtu.frame.size.width / 2;
            [closeBtu addTarget:self action:@selector(closeLive) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtu];
    
}
-(void)setButtonIcon{
    
    
    
    //左下角文字显示
    joinTextShowView = [[UIScrollView alloc]initWithFrame:CGRectMake(18, self.view.frame.size.height-248-LL_TabbarSafeBottomMargin, self.view.frame.size.width-18-18-85, 208)];
    
//    [joinTextShowView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:joinTextShowView];
    
    
    
    
    //右下角控制按钮显示
    UIView *controllBtuView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-85-18, self.view.frame.size.height-70-LL_TabbarSafeBottomMargin, 38, 30)];
    UIButton *switchBtu = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 38, 30)];
//    [switchBtu setBackgroundColor:[UIColor systemPinkColor]];
    [switchBtu setBackgroundImage:[UIImage imageNamed:@"icon_live_switch"] forState:UIControlStateNormal];
    [switchBtu addTarget:self action:@selector(qiehuanShexiang) forControlEvents:UIControlEventTouchUpInside];
//    switchBtu.layer.masksToBounds = YES;
//    switchBtu.layer.cornerRadius = switchBtu.frame.size.width / 2;
    [controllBtuView addSubview:switchBtu];
    
     
    
    [self.view addSubview:controllBtuView];
    
  
}

-(void)qiehuanShexiang{
    
    [plv.livePusher switchCamera];
    
}
-(void)closeLive{
    if (kaishizhibo == 1) {
        //结束推流
        mengbanView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.frame.size.width, [UIApplication sharedApplication].keyWindow.frame.size.height)];
        [mengbanView setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.4f]];
        [[UIApplication sharedApplication].keyWindow addSubview:mengbanView];
        
        UIView *tishiView = [[UIView alloc]initWithFrame:CGRectMake(20, (mengbanView.frame.size.height-100)/2, mengbanView.frame.size.width-40, 100)];
        [tishiView setBackgroundColor:[UIColor whiteColor]];
        tishiView.layer.masksToBounds = YES;
        tishiView.layer.cornerRadius = 3;
        [mengbanView addSubview:tishiView];
        
        UILabel *tishiLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, tishiView.frame.size.width, 12)];
        tishiLab.text = @"提示";
        tishiLab.textAlignment = NSTextAlignmentCenter;
        tishiLab.textColor = [UIColor blackColor];
        [tishiView addSubview:tishiLab];
        
        UILabel *tishiTextLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 32, tishiView.frame.size.width, 12)];
        tishiTextLab.text = @"是否确认结束直播";
        tishiTextLab.textAlignment = NSTextAlignmentCenter;
        tishiTextLab.textColor = [UIColor blackColor];
        [tishiView addSubview:tishiTextLab];
        
        UIButton *quxiaoBtu = [[UIButton alloc]initWithFrame:CGRectMake(0, 54, tishiView.frame.size.width/2, 46)];
        [quxiaoBtu setTitle:@"取消" forState:UIControlStateNormal];
        [quxiaoBtu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [quxiaoBtu addTarget:self action:@selector(quxiaotishi) forControlEvents:UIControlEventTouchUpInside];
        [tishiView addSubview:quxiaoBtu];
        
        UIButton *querenBtu = [[UIButton alloc]initWithFrame:CGRectMake(tishiView.frame.size.width/2, 54, tishiView.frame.size.width/2, 46)];
        [querenBtu setTitle:@"确认" forState:UIControlStateNormal];
        [querenBtu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [querenBtu addTarget:self action:@selector(querenClose) forControlEvents:UIControlEventTouchUpInside];
        [tishiView addSubview:querenBtu];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    
    
}

-(void)quxiaotishi{
    
    [mengbanView removeFromSuperview];
}

-(void)querenClose{
    [mengbanView removeFromSuperview];
    [plv.livePusher stopPreview]; //如果已经启动了摄像头预览，请在结束推流时将其关闭。
    [plv.livePusher stopPush];
    
    [timer invalidate];

    timer = nil;
    
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
    [dic setObject:@"0" forKey:@"type"];
    
    if (_LunTanOrLive == 1) {
        [LoginBL UserLiveRoom:dic success:^(NSMutableDictionary *returnValue) {
            self->timeNum = [[returnValue objectForKey:@"totaltime"] intValue];
            self->zhiborenshu = [[returnValue objectForKey:@"totalperson"] intValue];
            [self setmengbanjieshu];
        } failure:^(NSString *errorMessage) {
            
        }];
    }else{
        [LoginBL CloseUserLiveRoom:dic success:^(NSMutableDictionary *returnValue) {
            self->timeNum = [[returnValue objectForKey:@"totaltime"] intValue];
            self->zhiborenshu = [[returnValue objectForKey:@"totalperson"] intValue];
            [self setmengbanjieshu];
        } failure:^(NSString *errorMessage) {
            
        }];
        
        
    }
    
    
    
    
}
-(void)setmengbanjieshu{
    mengbanView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.frame.size.width, [UIApplication sharedApplication].keyWindow.frame.size.height)];
    [mengbanView setBackgroundColor:[UIColor colorWithRed:0.0/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:0.85f]];
    [[UIApplication sharedApplication].keyWindow addSubview:mengbanView];
    
    UILabel *zhijieshutishiLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 80+LL_StatusBarHeight, mengbanView.frame.size.width-20, 20)];
    zhijieshutishiLab.text = @"直播已结束";
    zhijieshutishiLab.textAlignment = NSTextAlignmentLeft;
    zhijieshutishiLab.textColor = [UIColor whiteColor];
    zhijieshutishiLab.font = [UIFont systemFontOfSize:20.0f];
    [mengbanView addSubview:zhijieshutishiLab];
    
    UIView *jishiView = [[UIView alloc]initWithFrame:CGRectMake((mengbanView.frame.size.width-260)/2, 130+LL_StatusBarHeight, 260, 330)];
    [mengbanView addSubview:jishiView];
    
    UILabel *shijianLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, jishiView.frame.size.width, 15)];
    shijianLab.text = [self getMMSSFromSS:[NSString stringWithFormat:@"%d",timeNum]];
    shijianLab.textAlignment = NSTextAlignmentCenter;
    shijianLab.font = [UIFont systemFontOfSize:15.0f];
    shijianLab.textColor = [UIColor whiteColor];
    [jishiView addSubview:shijianLab];
    
    UILabel *shijianWenziLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, jishiView.frame.size.width, 15)];
    shijianWenziLab.text = @"直播时长";
    shijianWenziLab.textAlignment = NSTextAlignmentCenter;
    shijianWenziLab.font = [UIFont systemFontOfSize:15.0f];
    shijianWenziLab.textColor = [UIColor whiteColor];
    [jishiView addSubview:shijianWenziLab];
    
    UILabel *renshuLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, jishiView.frame.size.width, 15)];
    renshuLab.text = [NSString stringWithFormat:@"%d",zhiborenshu];
    renshuLab.textAlignment = NSTextAlignmentCenter;
    renshuLab.font = [UIFont systemFontOfSize:15.0f];
    renshuLab.textColor = [UIColor whiteColor];
    [jishiView addSubview:renshuLab];
    
    UILabel *renshuWenziLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 155, jishiView.frame.size.width, 15)];
    renshuWenziLab.text = @"观看人数";
    renshuWenziLab.textAlignment = NSTextAlignmentCenter;
    renshuWenziLab.font = [UIFont systemFontOfSize:15.0f];
    renshuWenziLab.textColor = [UIColor whiteColor];
    [jishiView addSubview:renshuWenziLab];
    
    UIButton *guanbiBtu = [[UIButton alloc]initWithFrame:CGRectMake(10, 230, jishiView.frame.size.width-20, 40)];
    guanbiBtu.layer.masksToBounds = YES;
    guanbiBtu.layer.cornerRadius = 20.0f;
    [guanbiBtu addTarget:self action:@selector(colseLiveController) forControlEvents:UIControlEventTouchUpInside];
    [guanbiBtu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [guanbiBtu setTitle:@"确定" forState:UIControlStateNormal];
    [guanbiBtu setBackgroundColor:[UIColor orangeColor]];
    [jishiView addSubview:guanbiBtu];
    
}
-(void)colseLiveController{
    [mengbanView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
//-------------------------------------------------------------------------
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName: font};
    CGSize textSize = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return textSize;
}
+ (UIColor*)RandomColor {

    NSInteger aRedValue =arc4random() %255;

    NSInteger aGreenValue =arc4random() %255;

    NSInteger aBlueValue =arc4random() %255;

    UIColor*randColor = [UIColor colorWithRed:aRedValue /255.0f green:aGreenValue /255.0f blue:aBlueValue /255.0f alpha:1.0f];

    return randColor;

}
//产生随机字符串
- (NSString *)generateTradeNO
{
    static long kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRST";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
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



//计时器计数
-(void)Timered{
    jishi += 1;
    if (jishi % 8 == 0) {
//        [textarr removeAllObjects];
        [companyArr removeAllObjects];
//        for (int t = 0; t<15; t++) {
//            [textarr addObject:[self generateTradeNO]];
//        }
//        for (int t = 0; t<15; t++) {
//            [companyArr addObject:[LiveViewController RandomColor]];
//        }
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
        [dic setObject:userbh forKey:@"roomid"];
        if (lastMessageID == 0) {
           [dic setObject:@"" forKey:@"lastid"];
        }else{
           [dic setObject:[NSNumber numberWithLong:lastMessageID] forKey:@"lastid"];
        }
        
        
        [LoginBL LiveRoomUserInfo:dic success:^(NSMutableDictionary *returnValue) {
            NSArray *textArr = [returnValue objectForKey:@"chatlist"];
            if (textArr.count > 0) {
                NSDictionary *textDic = [textArr objectAtIndex:textArr.count-1];
                NSString *idStr = [textDic objectForKey:@"id"];
                self->lastMessageID = [idStr intValue];
                
            }
            for (NSDictionary *textDic in textArr) {
                [self->textarr addObject:textDic];
            }
            
            
            NSArray *userDic = [returnValue objectForKey:@"userlist"];
            for (NSDictionary *userdic in userDic) {
                [self->companyArr addObject:[userdic objectForKey:@"tx"]];
            }
            [self updateDate];
            
        } failure:^(NSString *errorMessage) {
            
        }];
        
        
    }
    
    
    
    
    
    
}
-(void)updateDate{
    //更新右上角加入人员数据
    for (UIImageView *imageView in [joinUserIconView subviews]) {
        [imageView removeFromSuperview];
    }
    float totalwidth = 0.0f;
    for (NSString *companyIconUrl in companyArr) {
        UIImageView *companyIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10+totalwidth,0 , 36, 36)];
        companyIcon.layer.masksToBounds = YES;
        companyIcon.layer.cornerRadius = companyIcon.frame.size.width / 2;
        NSString *imageStr = companyIconUrl;
//        if([imageStr rangeOfString: @"../../"].location == NSNotFound) {
//
//            imageStr = [imageStr stringByReplacingOccurrencesOfString:@"../../" withString:@""];
//
//        } else {
//
//        }
        companyIcon.image=[UIImage imageNamed:@"ic_placeholder"];
        NSString* encodedString =[imageStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//URL 含有中文 encode 编码
        [companyIcon sd_setImageWithURL:[NSURL URLWithString:encodedString] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image == nil) {
                companyIcon.image=[UIImage imageNamed:@"ic_placeholder"];
                companyIcon.backgroundColor=[UIColor whiteColor];
            }
        }];
//        [companyIcon  sd_setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"ic_placeholder"]];
//        [companyIcon setBackgroundColor:companyIconColor];
        [joinUserIconView addSubview:companyIcon];
        totalwidth += 36+10;
        
    }
    [joinUserIconView setContentSize:CGSizeMake(totalwidth, 0)];
    joinCompanyNumLab.text = [NSString stringWithFormat:@"%lu人",(unsigned long)companyArr.count];
    //更新左下角文本数据
    for (UIView *lab in [joinTextShowView subviews]) {
        [lab removeFromSuperview];
    }
    float totalHeight = 0.0f;
    for (NSDictionary *textstr in textarr) {
        scrollTextView *stv = [[scrollTextView alloc]init];
        [stv setViewInfo:textstr];
        [stv setFrame:CGRectMake(0, totalHeight, stv.viewWidth, stv.viewHeight)];
//        stv.layer.masksToBounds = YES;
//        stv.layer.cornerRadius = 22;
        
        
        
//        float strHeight = [self sizeWithString:textstr font:[UIFont systemFontOfSize:11.0f] maxSize:CGSizeMake(joinTextShowView.frame.size.width, MAXFLOAT)].height;
//
//        UILabel *textLab = [[UILabel alloc]initWithFrame:CGRectMake(0, totalHeight, joinTextShowView.frame.size.width, strHeight)];
//        textLab.numberOfLines = 0;
//        textLab.text = textstr;
//        textLab.font = [UIFont systemFontOfSize:11.0f];
//        textLab.textColor = [UIColor whiteColor];
//        textLab.layer.borderWidth = 0.5;
//
//        textLab.layer.borderColor = [[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1] CGColor];
        [joinTextShowView addSubview:stv];
        totalHeight += stv.viewHeight+10;
    }
    [joinTextShowView setContentSize:CGSizeMake(0, totalHeight)];
    
}
+ (NSString *)md5:(NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    return result;
}
+(NSString *)getNowTimeStamp {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;

    [formatter setDateStyle:NSDateFormatterMediumStyle];

    [formatter setTimeStyle:NSDateFormatterShortStyle];

    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // 设置想要的格式，hh与HH的区别:分别表示12小时制,24小时制

    //设置时区,这一点对时间的处理很重要

    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];

    [formatter setTimeZone:timeZone];

    NSDate *dateNow = [NSDate date];

    NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)[dateNow timeIntervalSince1970]+(12*60*60)];

    return timeStamp;

}
//将十进制转化为十六进制
-(NSString *)ToHex:(long long int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];

        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }

    }
    return str;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
