//
//  LoginBL.h
//  OASystemSass
//
//  Created by Eric on 2017/3/22.
//  Copyright © 2017年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginBL : NSObject
+(void)UserLogin:(NSDictionary *)topInfo
         success:(void (^)(NSMutableDictionary *returnValue))success
         failure:(void (^)(NSString *errorMessage))failure;

+(void)UserLiveRoom:(NSDictionary *)topInfo
success:(void (^)(NSMutableDictionary *returnValue))success
            failure:(void (^)(NSString *errorMessage))failure;

+(void)CloseUserLiveRoom:(NSDictionary *)topInfo
success:(void (^)(NSMutableDictionary *returnValue))success
                 failure:(void (^)(NSString *errorMessage))failure;

+(void)UserInfo:(NSDictionary *)topInfo
success:(void (^)(NSMutableDictionary *returnValue))success
        failure:(void (^)(NSString *errorMessage))failure;

+(void)CallUserRepace:(NSDictionary *)topInfo
success:(void (^)(NSMutableDictionary *returnValue))success
              failure:(void (^)(NSString *errorMessage))failure;

+(void)CallForAnyUser:(NSDictionary *)topInfo
success:(void (^)(NSMutableDictionary *returnValue))success
              failure:(void (^)(NSString *errorMessage))failure;

+(void)CallWait:(NSDictionary *)topInfo
success:(void (^)(NSMutableDictionary *returnValue))success
        failure:(void (^)(NSString *errorMessage))failure;

+(void)UserLeaveRoom:(NSDictionary *)topInfo
success:(void (^)(NSMutableDictionary *returnValue))success
             failure:(void (^)(NSString *errorMessage))failure;

+(void)LiveRoomUserInfo:(NSDictionary *)topInfo
success:(void (^)(NSMutableDictionary *returnValue))success
                failure:(void (^)(NSString *errorMessage))failure;

+(void)GainUserInfo:(NSDictionary *)topInfo
success:(void (^)(NSMutableDictionary *returnValue))success
            failure:(void (^)(NSString *errorMessage))failure;

+(void)updevicetoken:(NSDictionary *)topInfo
success:(void (^)(NSMutableDictionary *returnValue))success
             failure:(void (^)(NSString *errorMessage))failure;
@end
