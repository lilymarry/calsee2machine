//
//  IntoroomModel.m
//  Calsee2qdsme
//
//  Created by SCHENK on 2020/9/2.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import "IntoroomModel.h"

@implementation IntoroomModel
-(void)IntoroomModelSuccess:(void (^)(NSMutableDictionary *returnValue))success
failure:(void (^)(NSString *errorMessage))failure
{
     NSMutableDictionary *para = [NSMutableDictionary dictionary];
           
           if (SWNOTEmptyStr(self.exhiid)) {
               [para setValue:self.exhiid forKey:@"exhiid"];
           }
           if (SWNOTEmptyStr(self.lang)) {
               [para setValue:self.lang forKey:@"lang"];
           }
          if (SWNOTEmptyStr(self.ubh)) {
              [para setValue:self.ubh forKey:@"ubh"];
          }
          if (SWNOTEmptyStr(self.cid)) {
              [para setValue:self.cid forKey:@"cid"];
          }
    
    [[OAAPIClient sharedInstance] POST:@"/api/api/intoroom" parameters:para success:^(NSURLSessionDataTask *task, id responseObject) {
                    
                    if (responseObject) {
                          success(responseObject);
                    }
                   
                  
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    failure(@"登录失败，请重试");
                    
                }];
}
@end
