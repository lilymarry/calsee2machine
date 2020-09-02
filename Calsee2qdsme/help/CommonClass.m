//
//  CommonClass.m
//  Calsee2qdsme
//
//  Created by zell on 2020/8/31.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import "CommonClass.h"

@implementation CommonClass


+ (CommonClass *)sharedManager
{
    static CommonClass *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
//        [sharedAccountManagerInstance chushiQueue];
        
    });
    return sharedAccountManagerInstance;
}
-(void)callStateLab:(NSString *)tishiStr{
    NSDictionary *dict =@{NSFontAttributeName:[UIFont systemFontOfSize:11.f ]};
    CGSize infoSize = CGSizeMake(MAXFLOAT, 17);
    CGSize size = [tishiStr boundingRectWithSize:infoSize options:NSStringDrawingUsesLineFragmentOrigin  | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    UILabel *callStateLab = [[UILabel alloc]initWithFrame:CGRectMake(([UIApplication sharedApplication].keyWindow.frame.size.width-40-size.width)/2, [UIApplication sharedApplication].keyWindow.frame.size.height-170, size.width+40, 17)];
    
    
    [callStateLab setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.8f]];
    
    callStateLab.textColor = [UIColor whiteColor];
    callStateLab.textAlignment = NSTextAlignmentCenter;
    callStateLab.font = [UIFont systemFontOfSize:17.0f];
    callStateLab.text = tishiStr;
    [hujiao addSubview:callStateLab];
    
}


-(void)creatCallMengban:(NSString *)roomID callOrByCall:(int)callBeCall{
    roomid = roomID;
    hujiao = [[HujiaoView alloc]initWithFrame:CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.frame.size.width, [UIApplication sharedApplication].keyWindow.frame.size.height)];
    [hujiao setBackgroundColor:[UIColor colorWithRed:53/255.0 green:118/255.0 blue:202/255.0 alpha:1.0]];
    [hujiao setviewInfo:callBeCall];
    [[UIApplication sharedApplication].keyWindow addSubview:hujiao];
    timer  =  [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(Timered) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [hujiao.guaduanBtu addTarget:self action:@selector(guaduan) forControlEvents:UIControlEventTouchUpInside];
    
    [hujiao.jietingBtu addTarget:self action:@selector(jieting) forControlEvents:UIControlEventTouchUpInside];
//    UILabel *callStateLab = [[UILabel alloc]initWithFrame:CGRectMake(20, nameLab.frame.origin.y +nameLab.frame.size.height+20, self.frame.size.width-40, 14)];
    
}
-(void)guaduan{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSString *userbh = [[NSUserDefaults standardUserDefaults] objectForKey:Userbh];
    if (userbh.length>0) {
      
    }else{
        userbh = @"";
    }
    [dic setObject:userbh forKey:@"ubh"];
    [dic setObject:@"cn" forKey:@"lang"];
    [dic setObject:exhiid2 forKey:@"exhiid"];
    [dic setObject:@"" forKey:@"roomid"];
    [LoginBL UserLeaveRoom:dic success:^(NSMutableDictionary *returnValue) {
        
    } failure:^(NSString *errorMessage) {
        
    }];
    [self callStateLab:@"已挂断"];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
        
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self->hujiao removeFromSuperview];
    });
    
    
    
    
}
-(void)jieting{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:@"" forKey:@"ubh"];
    [dic setObject:@"" forKey:@"lang"];
    [dic setObject:@"" forKey:@"exhiid"];
    [dic setObject:@"" forKey:@"roomid"];
    
    [LoginBL CallForAnyUser:dic success:^(NSMutableDictionary *returnValue) {
        
    } failure:^(NSString *errorMessage) {
        
    }];
    
}

-(void)Timered{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:@"" forKey:@"ubh"];
    [dic setObject:@"" forKey:@"lang"];
    [dic setObject:@"" forKey:@"exhiid"];
    [dic setObject:@"" forKey:@"roomid"];
    
    [LoginBL CallWait:dic success:^(NSMutableDictionary *returnValue) {
        
    } failure:^(NSString *errorMessage) {
        
    }];
}
@end
