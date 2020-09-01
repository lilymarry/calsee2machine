//
//  HasKeFuModel.m
//  Calsee2qdsme
//
//  Created by SCHENK on 2020/8/31.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import "HasKeFuModel.h"

@implementation HasKeFuModel
-(void)HasKeFuModelSuccess:(HasKeFuModelSuccessBlock)success andFailure:(HasKeFuModelFaiulureBlock)failure
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
         
   
    
        [HttpManager postWithUrl:@"haskf" baseurl:Base_url andParameters:para andSuccess:^(id Json) {
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
