//
//  HasKeFuModel.h
//  Calsee2qdsme
//
//  Created by SCHENK on 2020/8/31.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^HasKeFuModelSuccessBlock)(NSString *code,NSString* message  ,id data);
typedef void(^HasKeFuModelFaiulureBlock)(NSError *error);
@interface HasKeFuModel : NSObject
@property(nonatomic,copy )NSString *exhiid;
@property(nonatomic,copy )NSString *lang;
@property(nonatomic,copy )NSString *ubh;
@property(nonatomic,copy )NSString *cid;


-(void)HasKeFuModelSuccess:(HasKeFuModelSuccessBlock)success andFailure:(HasKeFuModelFaiulureBlock)failure;
@end


NS_ASSUME_NONNULL_END
