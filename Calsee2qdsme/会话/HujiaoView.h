//
//  HujiaoView.h
//  Calsee2qdsme
//
//  Created by zell on 2020/8/30.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HujiaoView : UIView
@property (nonatomic,strong) UIButton *guaduanBtu;
@property (nonatomic,strong) UIButton *jietingBtu;
//@property (nonatomic,strong) UILabel *callStateLab;
-(void)setviewInfo:(int)callOrRepace;
@end

NS_ASSUME_NONNULL_END
