//
//  LiveUserModel.h
//  Calsee2qdsme
//
//  Created by SCHENK on 2020/8/31.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveUserModel : NSObject
@property(nonatomic,copy )NSString *exhiid;
@property(nonatomic,copy )NSString *lang;
@property(nonatomic,copy )NSString *ubh;
@property(nonatomic,copy )NSString *roomid;
@property(nonatomic,copy )NSString *lastid;////最后一条消息的id，没有传“”

-(void)LiveUserModelSuccessBlock:(void (^)(NSMutableDictionary *returnValue))success
failure:(void (^)(NSString *errorMessage))failure;
@end
NS_ASSUME_NONNULL_END
