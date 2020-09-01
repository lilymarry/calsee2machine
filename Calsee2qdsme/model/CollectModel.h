//
//  CollectModel.h
//  Calsee2qdsme
//
//  Created by SCHENK on 2020/8/31.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^CollectModelSuccessBlock)(NSString *code,NSString* message  ,id data);
typedef void(^CollectModelFaiulureBlock)(NSError *error);
@interface CollectModel : NSObject
@property(nonatomic,copy )NSString *exhiid;
@property(nonatomic,copy )NSString *lang;
@property(nonatomic,copy )NSString *ubh;
@property(nonatomic,copy )NSString *lx;//类型1-人才，2-参展商，3-采购商，4-金融机构，5-商品

@property(nonatomic,copy )NSString *id; //被收藏者id
@property(nonatomic,copy )NSString *type; //1收藏 2 取消收藏
-(void)CollectModelSuccessBlock:(CollectModelSuccessBlock)success andFailure:(CollectModelFaiulureBlock)failure;
@end


NS_ASSUME_NONNULL_END
