//
//  LivechatModel.m
//  Calsee2qdsme
//
//  Created by SCHENK on 2020/8/31.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import "LivechatModel.h"

@implementation LivechatModel
-(void)LivechatModelSuccess:(LivechatModelSuccessBlock)success andFailure:(LivechatModelFaiulureBlock)failure
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
          if (SWNOTEmptyStr(self.nr)) {
                  [para setValue:self.nr forKey:@"nr"];
              }
   
    
        [HttpManager postWithUrl:@"livechat" baseurl:Base_url andParameters:para andSuccess:^(id Json) {
               NSDictionary * dic = (NSDictionary *)Json;
    //         [SearchGoodsModel mj_setupObjectClassInArray:^NSDictionary *{
    //              return @{@"products":@"SearchGoodsModel"
    //                       };
    //          }];
         //  success(dic[@"code"],dic[@"message"],[SearchGoodsModel mj_objectWithKeyValues:dic]);
               
           } andFail:^(NSError *error) {
               failure(error);
           }];
}
@end
