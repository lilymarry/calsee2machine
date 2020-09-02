//
//  HasKeFuModel.h
//  Calsee2qdsme
//
//  Created by SCHENK on 2020/8/31.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HasKeFuModel : NSObject
@property(nonatomic,copy )NSString *exhiid;
@property(nonatomic,copy )NSString *lang;
@property(nonatomic,copy )NSString *ubh;
@property(nonatomic,copy )NSString *cid;


-(void)HasKeFuModelSuccess:(void (^)(NSMutableDictionary *returnValue))success
failure:(void (^)(NSString *errorMessage))failure;
@end


NS_ASSUME_NONNULL_END
