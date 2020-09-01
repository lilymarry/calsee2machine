//
//  LivechatModel.h
//  Calsee2qdsme
//
//  Created by SCHENK on 2020/8/31.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^LivechatModelSuccessBlock)(NSString *code,NSString* message  ,id data);
typedef void(^LivechatModelFaiulureBlock)(NSError *error);
@interface LivechatModel : NSObject
@property(nonatomic,copy )NSString *exhiid;
@property(nonatomic,copy )NSString *lang;
@property(nonatomic,copy )NSString *ubh;
@property(nonatomic,copy )NSString *roomid;
@property(nonatomic,copy )NSString *nr;//发言内容

-(void)LivechatModelSuccess:(LivechatModelSuccessBlock)success andFailure:(LivechatModelFaiulureBlock)failure;
@end

NS_ASSUME_NONNULL_END
