//
//  pushLiveView.h
//  Calsee2qdsme
//
//  Created by zell on 2020/8/27.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXLiteAVSDK_Professional/TXLiteAVSDK.h"
NS_ASSUME_NONNULL_BEGIN

@interface pushLiveView : UIView
@property (nonatomic, strong) TXLivePush *livePusher;
-(void)setPushInfor;
@end

NS_ASSUME_NONNULL_END
