//
//  BaseAFNetworkingManager.m
//  SuperiorAcme
//
//  Created by mac on 2019/10/17.
//  Copyright © 2019 sunjiayu. All rights reserved.
//

#import "BaseAFNetworkingManager.h"
//#import "SVProgressHUD.h"

@interface BaseAFNetworkingManager ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation BaseAFNetworkingManager

static BaseAFNetworkingManager *baseAFNetworkingManage = nil;

/**
 单例
 
 @return 网络请求类的实例
 */
+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!baseAFNetworkingManage) {
            baseAFNetworkingManage = [[BaseAFNetworkingManager alloc] init];
        }
    });
    return baseAFNetworkingManage;
}

- (instancetype)init {
    if (self = [super init]) {
        self.sessionManager = [AFHTTPSessionManager manager];
        //设置超时时间
        self.sessionManager.requestSerializer.timeoutInterval = 60.0;
          self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
      //  self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"application/x-www-form-urlencoded",nil];
        
    }
    return self;
}

/**
 网络请求
 
 @param requestMethod 请求方式
 @param url 服务器地址
 @param apiPath api方法地址
 @param parameters 参数
 @param progress 进度
 @param success 成功
 @param failure 失败
 @return return value description
 */
- (nullable NSURLSessionDataTask *)sendRequestMethod:(HTTPMethod)requestMethod url:(nonnull NSString *)url apiPath:(nonnull NSString *)apiPath parameters:(nullable id)parameters progress:(nullable void(^)(NSProgress *_Nullable progress))progress header:(NSDictionary *)headers  success:(nullable void(^)(BOOL isSuccess, id _Nullable responseObject))success failure:(nullable void(^)(NSError * _Nullable error))failure {
    
   
    //请求的地址
    NSString *requestPath = [url stringByAppendingPathComponent:apiPath];
    NSURLSessionDataTask *task = nil;
    switch (requestMethod) {
        case HTTPMethodGET: {
            task=[self.sessionManager GET:requestPath parameters:parameters headers:headers progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if(success)
                {
                    if (responseObject) {
                                    NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];



                                              NSData* data = [aString dataUsingEncoding:NSUTF8StringEncoding];

                                              NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                            
                                 
                                    {
                                        success(YES, dic);
                                    }
                                }
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                                 [self errorDispose:error result:^(BOOL result) {
                                     if (result) failure(error);
                                 }];
                             }
            }];
            
            
          

        }
            break;
        case HTTPMethodPOST: {
            task=[self.sessionManager POST:requestPath parameters:parameters headers:headers progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if(success)
                {
                    if (responseObject) {
                                    NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];



                                              NSData* data = [aString dataUsingEncoding:NSUTF8StringEncoding];

                                              NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                            
                                 
                                    {
                                        success(YES, dic);
                                    }
                                }
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                                 [self errorDispose:error result:^(BOOL result) {
                                     if (result) failure(error);
                                 }];
                             }
            }];
            
            
          

        }
            break;
       case HTTPMethodPUT: {
            task = [self.sessionManager PUT:requestPath parameters:parameters headers:headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(YES, responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
            
        case HTTPMethodDELETE: {
            task = [self.sessionManager DELETE:requestPath parameters:parameters headers:headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(YES, responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
            
      case HTTPMethodPATCH: {
             task = [self.sessionManager PATCH:requestPath parameters:parameters headers:headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 if (success) {
                     success(YES, responseObject);
                 }
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 if (failure) {
                     failure(error);
                 }
             }];
         }
             break;
       
    }
    return task;
}

#pragma mark 报错信息
/**
 处理报错信息
 
 @param error AFN返回的错误信息
 @param task 任务
 @return description
 */
- (NSString *)failHandleWithErrorResponse:( NSError * _Nullable )error task:( NSURLSessionDataTask * _Nullable )task {
    __block NSString *message = nil;
    // 这里可以直接设定错误反馈，也可以利用AFN 的error信息直接解析展示
    NSData *afNetworking_errorMsg = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
    NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: afNetworking_errorMsg options:kNilOptions error:nil];
    NSLog(@"error--%@",serializedData);
    //
    if (!afNetworking_errorMsg) {
        message = @"网络连接失败";
    }
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    NSInteger responseStatue = response.statusCode;
    if (responseStatue >= 500) {  // 网络错误
        message = @"服务器维护升级中,请耐心等待";
    } else if (responseStatue >= 400) {
        // 错误信息
        //  NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:afNetworking_errorMsg options:NSJSONReadingAllowFragments error:nil];
        //  message = responseObject[@"error"];
        message = @"网络连接失败";
    }
    return message;
}



- (void)errorDispose:(NSError * _Nonnull)error result:(nullable void(^)(BOOL result))resultBlock{
    
    if (resultBlock)
        resultBlock(YES);
    
}
-(void)goLogin
{
//    LoginViewController *log = [LoginViewController new];
//    YDLNavigationViewController *navi = [[YDLNavigationViewController alloc]initWithRootViewController:log];
//
//    log.isPresent=@"2";
//    [[UIApplication sharedApplication] keyWindow].rootViewController=navi;
    
}
@end
