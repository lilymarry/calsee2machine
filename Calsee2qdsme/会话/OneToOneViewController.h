//
//  OneToOneViewController.h
//  Calsee2qdsme
//
//  Created by zell on 2020/8/29.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OneToOneViewController : UIViewController
@property (nonatomic) int callFrom;
@property (nonatomic) int callzt;
@property (nonatomic,strong) NSString *roomid;
@property (nonatomic,strong) NSString *userid;
@property (nonatomic,strong) NSString *roomsig;
@end

NS_ASSUME_NONNULL_END
