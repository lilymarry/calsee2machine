//
//  AccusationModel.h
//  Calsee2qdsme
//
//  Created by SCHENK on 2020/8/31.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^AccusationModelSuccessBlock)(NSString *code,NSString* message  ,id data);
typedef void(^AccusationModelFaiulureBlock)(NSError *error);
@interface AccusationModel : NSObject
@property(nonatomic,copy )NSString *exhiid;
@property(nonatomic,copy )NSString *lang;
@property(nonatomic,copy )NSString *ubh;
@property(nonatomic,copy )NSString *roomid;
@property(nonatomic,copy )NSString *content;

-(void)AccusationModelSuccess:(AccusationModelSuccessBlock)success andFailure:(AccusationModelFaiulureBlock)failure;
@end

NS_ASSUME_NONNULL_END
