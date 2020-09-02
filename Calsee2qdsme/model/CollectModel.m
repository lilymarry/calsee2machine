//
//  CollectModel.m
//  Calsee2qdsme
//
//  Created by SCHENK on 2020/8/31.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import "CollectModel.h"

@implementation CollectModel
-(void)CollectModelSuccessBlock:(void (^)(NSMutableDictionary *returnValue))success
failure:(void (^)(NSString *errorMessage))failure;
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
          if (SWNOTEmptyStr(self.id)) {
              [para setValue:self.id forKey:@"id"];
          }
          if (SWNOTEmptyStr(self.lx)) {
                  [para setValue:self.lx forKey:@"lx"];
              }
    NSString *url=@"/api/api/like_add";
    if([_type isEqualToString:@"2"])
    {
         url=@"/api/api/like_del";
    }
        [[OAAPIClient sharedInstance] POST:url parameters:para success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if (responseObject) {
                  success(responseObject);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            failure(@"登录失败，请重试");
            
        }];

}
@end
