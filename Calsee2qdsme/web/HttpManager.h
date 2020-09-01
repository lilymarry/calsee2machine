//
//  Created by mac on 2019/10/17.
//  Copyright © 2019 sunjiayu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HttpSuccessBlock) (id Json);
typedef void(^HttpFailureBlock) (NSError * error);
@interface HttpManager : NSObject



+ (void)postWithUrl:(NSString *)url
                 baseurl:(NSString *)baseurl
           andParameters:(NSDictionary *)params
              andSuccess:(HttpSuccessBlock)success
                 andFail:(HttpFailureBlock)failure;

+ (void)getWithUrl:(NSString *)url  baseurl:(NSString *)baseurl andParameters:(NSDictionary *)params andSuccess:(HttpSuccessBlock)success andFail:(HttpFailureBlock)failure;

@end
