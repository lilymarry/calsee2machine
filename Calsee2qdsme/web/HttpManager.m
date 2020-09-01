//
//  Created by mac on 2019/10/17.
//  Copyright © 2019 sunjiayu. All rights reserved.
//

#import "HttpManager.h"
#import "BaseAFNetworkingManager.h"
@interface HttpManager ()

@end

@implementation HttpManager

// 默认请求二进制
// 默认响应是JSON

+ (void)postWithUrl:(NSString *)url
       baseurl:(NSString *)baseurl
      andParameters:(NSDictionary *)params
         andSuccess:(HttpSuccessBlock)success
            andFail:(HttpFailureBlock)failure
{
    if (url == nil) {
        url = @"";
    }
    if (params == nil) {
        params = @{};
    }
 
    BaseAFNetworkingManager *baseAFNetworkingManager = [BaseAFNetworkingManager defaultManager];
    [baseAFNetworkingManager sendRequestMethod:HTTPMethodPOST url:baseurl apiPath:url parameters:params progress:nil header:nil success:^(BOOL isSuccess, id  _Nullable responseObject) {
        if (success == nil) return ;
        success(responseObject);
    } failure:^(NSError * _Nullable error) {
        if (failure == nil) return ;
        failure(error);
    }];
}
+ (void)getWithUrl:(NSString *)url
           baseurl:(NSString *)baseurl
     andParameters:(NSDictionary *)params
        andSuccess:(HttpSuccessBlock)success
           andFail:(HttpFailureBlock)failure
{
    if (url == nil) {
        url = @"";
    }
    if (params == nil) {
        params = @{};
    }
    NSLog(@"sss %@",params);
    BaseAFNetworkingManager *baseAFNetworkingManager = [BaseAFNetworkingManager defaultManager];
    [baseAFNetworkingManager sendRequestMethod:HTTPMethodGET url:baseurl apiPath:url parameters:params progress:nil header:nil success:^(BOOL isSuccess, id  _Nullable responseObject) {
        if (success == nil) return ;
        success(responseObject);
    } failure:^(NSError * _Nullable error) {
        if (failure == nil) return ;
        failure(error);
    }];
}

@end
