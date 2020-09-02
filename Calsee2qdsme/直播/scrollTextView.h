//
//  scrollTextView.h
//  Calsee2qdsme
//
//  Created by zell on 2020/8/30.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface scrollTextView : UIView
@property (nonatomic) int viewHeight;
@property (nonatomic) int viewWidth;
-(void)setViewInfo:(NSDictionary *)textStr;
@end

NS_ASSUME_NONNULL_END
