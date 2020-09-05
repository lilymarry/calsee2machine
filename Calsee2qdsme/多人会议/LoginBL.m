//
//  LoginBL.m
//  OASystemSass
//
//  Created by Eric on 2017/3/22.
//  Copyright © 2017年 Eric. All rights reserved.
//

#import "LoginBL.h"
#import "OAAPIClient.h"
@implementation LoginBL

#pragma mark - 获取会议房间信息接口
+(void)UserLogin:(NSDictionary *)topInfo
                    success:(void (^)(NSMutableDictionary *returnValue))success
                    failure:(void (^)(NSString *errorMessage))failure
{
    [[OAAPIClient sharedInstance] POST:@"/api/api/intomeeting2" parameters:topInfo success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary * arr = responseObject;
        int mt = [[arr objectForKey:@"code"] intValue];
            if (mt == 100) {
            NSMutableDictionary *dic = [arr objectForKey:@"detail"];
//            NSData *jsonData = [dit dataUsingEncoding:NSUTF8StringEncoding];
//            NSError *err;
//            NSDictionary * arr = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                 options:NSJSONReadingMutableContainers error:&err];
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:arr];
                success(dic);
//            if (![[dic objectForKey:@"Result"] isEqualToString:@"False"]) {
//
//
//            }else{
//                failure(@"用户名或密码错误，请重试");
//            }
            
        }else{
            failure(@"登录失败，请重试");
        }
        //        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(@"登录失败，请重试");
        
    }];
}

#pragma mark - 获取开启直播信息接口
+(void)UserLiveRoom:(NSDictionary *)topInfo
                    success:(void (^)(NSMutableDictionary *returnValue))success
                    failure:(void (^)(NSString *errorMessage))failure
{
    [[OAAPIClient sharedInstance] POST:@"/api/api/liveaddr" parameters:topInfo success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary * arr = responseObject;
        int mt = [[arr objectForKey:@"code"] intValue];
            if (mt == 100) {
            NSMutableDictionary *dic = [arr objectForKey:@"detail"];
//            NSData *jsonData = [dit dataUsingEncoding:NSUTF8StringEncoding];
//            NSError *err;
//            NSDictionary * arr = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                 options:NSJSONReadingMutableContainers error:&err];
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:arr];
            success(dic);
//            if (![[dic objectForKey:@"Result"] isEqualToString:@"False"]) {
//
//
//            }else{
//                failure(@"用户名或密码错误，请重试");
//            }
            
        }else{
            failure(@"登录失败，请重试");
        }
        //        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(@"登录失败，请重试");
        
    }];
}

#pragma mark - 获取论坛直播信息接口
+(void)CloseUserLiveRoom:(NSDictionary *)topInfo
                    success:(void (^)(NSMutableDictionary *returnValue))success
                    failure:(void (^)(NSString *errorMessage))failure
{
    [[OAAPIClient sharedInstance] POST:@"/api/api/liveaddr2" parameters:topInfo success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary * arr = responseObject;
        int mt = [[arr objectForKey:@"code"] intValue];
            if (mt == 100) {
            NSMutableDictionary *dic = [arr objectForKey:@"detail"];
//            NSData *jsonData = [dit dataUsingEncoding:NSUTF8StringEncoding];
//            NSError *err;
//            NSDictionary * arr = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                 options:NSJSONReadingMutableContainers error:&err];
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:arr];
                success(dic);
//            if (![[dic objectForKey:@"Result"] isEqualToString:@"False"]) {
//                success(dic);
//
//            }else{
//                failure(@"用户名或密码错误，请重试");
//            }
            
        }else{
            NSLog(@"%@",[arr objectForKey:@"message"]);
            failure(@"登录失败，请重试");
        }
        //        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(@"登录失败，请重试");
        
    }];
}

#pragma mark - 获取用户信息接口
+(void)UserInfo:(NSDictionary *)topInfo
                    success:(void (^)(NSMutableDictionary *returnValue))success
                    failure:(void (^)(NSString *errorMessage))failure
{
    [[OAAPIClient sharedInstance] POST:@"/api/api/userdetail" parameters:topInfo success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary * arr = responseObject;
        int mt = [[arr objectForKey:@"code"] intValue];
            if (mt == 100) {
            NSMutableDictionary *dic = [arr objectForKey:@"detail"];
//            NSData *jsonData = [dit dataUsingEncoding:NSUTF8StringEncoding];
//            NSError *err;
//            NSDictionary * arr = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                 options:NSJSONReadingMutableContainers error:&err];
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:arr];
                success(dic);
//            if (![[dic objectForKey:@"Result"] isEqualToString:@"False"]) {
//                success(dic);
//
//            }else{
//                failure(@"用户名或密码错误，请重试");
//            }
            
        }else{
            failure(@"登录失败，请重试");
        }
        //        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(@"登录失败，请重试");
        
    }];
}

#pragma mark - 呼叫对方接受接口
+(void)CallUserRepace:(NSDictionary *)topInfo
                    success:(void (^)(NSMutableDictionary *returnValue))success
                    failure:(void (^)(NSString *errorMessage))failure
{
    [[OAAPIClient sharedInstance] POST:@"/api/api/intoroom" parameters:topInfo success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary * arr = responseObject;
        int mt = [[arr objectForKey:@"code"] intValue];
            if (mt == 100) {
            NSMutableDictionary *dic = [arr objectForKey:@"detail"];
//            NSData *jsonData = [dit dataUsingEncoding:NSUTF8StringEncoding];
//            NSError *err;
//            NSDictionary * arr = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                 options:NSJSONReadingMutableContainers error:&err];
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:arr];
                success(dic);
//            if (![[dic objectForKey:@"Result"] isEqualToString:@"False"]) {
//                success(dic);
//
//            }else{
//                failure(@"用户名或密码错误，请重试");
//            }
            
        }else{
            failure(@"登录失败，请重试");
        }
        //        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(@"登录失败，请重试");
        
    }];
}

#pragma mark - 被对方呼叫接口
+(void)CallForAnyUser:(NSDictionary *)topInfo
                    success:(void (^)(NSMutableDictionary *returnValue))success
                    failure:(void (^)(NSString *errorMessage))failure
{
    [[OAAPIClient sharedInstance] POST:@"/api/api/intoroom2" parameters:topInfo success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary * arr = responseObject;
        int mt = [[arr objectForKey:@"code"] intValue];
            if (mt == 100) {
            NSMutableDictionary *dic = [arr objectForKey:@"detail"];
//            NSData *jsonData = [dit dataUsingEncoding:NSUTF8StringEncoding];
//            NSError *err;
//            NSDictionary * arr = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                 options:NSJSONReadingMutableContainers error:&err];
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:arr];
                success(dic);
//            if (![[dic objectForKey:@"Result"] isEqualToString:@"False"]) {
//                success(dic);
//
//            }else{
//                failure(@"用户名或密码错误，请重试");
//            }
            
        }else{
            failure(@"登录失败，请重试");
        }
        //        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(@"登录失败，请重试");
        
    }];
}

#pragma mark - 呼叫等待状态接口
+(void)CallWait:(NSDictionary *)topInfo
                    success:(void (^)(NSMutableDictionary *returnValue))success
                    failure:(void (^)(NSString *errorMessage))failure
{
    [[OAAPIClient sharedInstance] POST:@"/api/api/waitcall" parameters:topInfo success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary * arr = responseObject;
        int mt = [[arr objectForKey:@"code"] intValue];
            if (mt == 100) {
            NSMutableDictionary *dic = [arr objectForKey:@"detail"];
//            NSData *jsonData = [dit dataUsingEncoding:NSUTF8StringEncoding];
//            NSError *err;
//            NSDictionary * arr = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                 options:NSJSONReadingMutableContainers error:&err];
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:arr];
                success(dic);
//            if (![[dic objectForKey:@"Result"] isEqualToString:@"False"]) {
//                success(dic);
//
//            }else{
//                failure(@"用户名或密码错误，请重试");
//            }
            
        }else{
            failure(@"登录失败，请重试");
        }
        //        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(@"登录失败，请重试");
        
    }];
}

#pragma mark - 会议/呼叫退出房间信息接口
+(void)UserLeaveRoom:(NSDictionary *)topInfo
                    success:(void (^)(NSMutableDictionary *returnValue))success
                    failure:(void (^)(NSString *errorMessage))failure
{
    [[OAAPIClient sharedInstance] POST:@"/api/api/exitroom" parameters:topInfo success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary * arr = responseObject;
        int mt = [[arr objectForKey:@"code"] intValue];
            if (mt == 100) {
            NSMutableDictionary *dic = [arr objectForKey:@"detail"];
//            NSData *jsonData = [dit dataUsingEncoding:NSUTF8StringEncoding];
//            NSError *err;
//            NSDictionary * arr = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                 options:NSJSONReadingMutableContainers error:&err];
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:arr];
                success(dic);
//            if (![[dic objectForKey:@"Result"] isEqualToString:@"False"]) {
//                success(dic);
//
//            }else{
//                failure(@"用户名或密码错误，请重试");
//            }
//
        }else{
            failure(@"登录失败，请重试");
        }
        //        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(@"登录失败，请重试");
        
    }];
}

#pragma mark - 获取直播间用户信息接口
+(void)LiveRoomUserInfo:(NSDictionary *)topInfo
                    success:(void (^)(NSMutableDictionary *returnValue))success
                    failure:(void (^)(NSString *errorMessage))failure
{
    [[OAAPIClient sharedInstance] POST:@"/api/api/liveuser" parameters:topInfo success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary * arr = responseObject;
        int mt = [[arr objectForKey:@"code"] intValue];
            if (mt == 100) {
            NSMutableDictionary *dic = [arr objectForKey:@"detail"];
//            NSData *jsonData = [dit dataUsingEncoding:NSUTF8StringEncoding];
//            NSError *err;
//            NSDictionary * arr = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                 options:NSJSONReadingMutableContainers error:&err];
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:arr];
                success(dic);
//            if (![[dic objectForKey:@"Result"] isEqualToString:@"False"]) {
//                success(dic);
//                
//            }else{
//                failure(@"用户名或密码错误，请重试");
//            }
            
        }else{
            failure(@"登录失败，请重试");
        }
        //        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(@"登录失败，请重试");
        
    }];
}

#pragma mark - 获取用户信息接口
+(void)GainUserInfo:(NSDictionary *)topInfo
                    success:(void (^)(NSMutableDictionary *returnValue))success
                    failure:(void (^)(NSString *errorMessage))failure
{
    [[OAAPIClient sharedInstance] POST:@"/api/api/userdetail" parameters:topInfo success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary * arr = responseObject;
        int mt = [[arr objectForKey:@"code"] intValue];
            if (mt == 100) {
            NSMutableDictionary *dic = [arr objectForKey:@"detail"];
//            NSData *jsonData = [dit dataUsingEncoding:NSUTF8StringEncoding];
//            NSError *err;
//            NSDictionary * arr = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                 options:NSJSONReadingMutableContainers error:&err];
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:arr];
                success(dic);
//            if (![[dic objectForKey:@"Result"] isEqualToString:@"False"]) {
//                success(dic);
//
//            }else{
//                failure(@"用户名或密码错误，请重试");
//            }
            
        }else{
            failure(@"登录失败，请重试");
        }
        //        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(@"登录失败，请重试");
        
    }];
}
#pragma mark - 上传devicetoken接口
+(void)updevicetoken:(NSDictionary *)topInfo
                    success:(void (^)(NSMutableDictionary *returnValue))success
                    failure:(void (^)(NSString *errorMessage))failure
{
    [[OAAPIClient sharedInstance] POST:@"/api/api/ios_devicetoken" parameters:topInfo success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary * arr = responseObject;
        int mt = [[arr objectForKey:@"code"] intValue];
            if (mt == 100) {
            NSMutableDictionary *dic = [arr objectForKey:@"detail"];

                success(dic);

        }else{
            failure(@"登录失败，请重试");
        }
        //        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(@"登录失败，请重试");
        
    }];
}


#pragma mark - 会议/呼叫挂断退出房间信息接口
+(void)UserGuaduanRoom:(NSDictionary *)topInfo
                    success:(void (^)(NSMutableDictionary *returnValue))success
                    failure:(void (^)(NSString *errorMessage))failure
{
    [[OAAPIClient sharedInstance] POST:@"/api/api/callfail" parameters:topInfo success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary * arr = responseObject;
        int mt = [[arr objectForKey:@"code"] intValue];
            if (mt == 100) {
            NSMutableDictionary *dic = [arr objectForKey:@"detail"];
//            NSData *jsonData = [dit dataUsingEncoding:NSUTF8StringEncoding];
//            NSError *err;
//            NSDictionary * arr = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                 options:NSJSONReadingMutableContainers error:&err];
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:arr];
                success(dic);
//            if (![[dic objectForKey:@"Result"] isEqualToString:@"False"]) {
//                success(dic);
//
//            }else{
//                failure(@"用户名或密码错误，请重试");
//            }
//
        }else{
            failure(@"登录失败，请重试");
        }
        //        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(@"登录失败，请重试");
        
    }];
}
@end
