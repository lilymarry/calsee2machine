//
//  AccusationModel.m
//  Calsee2qdsme
//
//  Created by SCHENK on 2020/8/31.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import "AccusationModel.h"

@implementation AccusationModel
-(void)AccusationModelSuccess:(void (^)(NSMutableDictionary *returnValue))success
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
          if (SWNOTEmptyStr(self.roomid)) {
              [para setValue:self.roomid forKey:@"roomid"];
          }
          if (SWNOTEmptyStr(self.content)) {
                  [para setValue:self.content forKey:@"content"];
              }
   
    
           [[OAAPIClient sharedInstance] POST:@"/api/api/accusation" parameters:para success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if (responseObject) {
                  success(responseObject);
            }
           
          
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            failure(@"登录失败，请重试");
            
        }];
}
@end
