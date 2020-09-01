//
//  InRoomModel.h
//  Calsee2qdsme
//
//  Created by SCHENK on 2020/8/31.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^InRoomModelSuccessBlock)(NSString *code,NSString* message  ,id data);
typedef void(^InRoomModelFaiulureBlock)(NSError *error);
@interface InRoomModel : NSObject
@property(nonatomic,copy )NSString *exhiid;
@property(nonatomic,copy )NSString *lang;
@property(nonatomic,copy )NSString *ubh;
@property(nonatomic,copy )NSString *roomid;
@property(nonatomic,copy )NSString *type;//进房==1，出房==0
-(void)InRoomModelSuccessBlock:(InRoomModelSuccessBlock)success andFailure:(InRoomModelFaiulureBlock)failure;
@end

NS_ASSUME_NONNULL_END
