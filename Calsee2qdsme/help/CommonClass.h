//
//  CommonClass.h
//  Calsee2qdsme
//
//  Created by zell on 2020/8/31.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HujiaoView.h"
#import "LoginBL.h"
NS_ASSUME_NONNULL_BEGIN

@interface CommonClass : NSObject
{
    HujiaoView *hujiao;
    NSString *roomid;
    NSTimer *timer;
}
+ (CommonClass *)sharedManager;
-(void)creatCallMengban:(NSString *)roomID callOrByCall:(int)callBeCall;
-(void)callStateLab:(NSString *)tishiStr;
@end

NS_ASSUME_NONNULL_END
