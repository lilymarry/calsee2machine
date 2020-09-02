//
//  HujiaoView.m
//  Calsee2qdsme
//
//  Created by zell on 2020/8/30.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import "HujiaoView.h"
@implementation HujiaoView


-(void)setviewInfo:(int)callOrRepace{
    
    UIImageView *headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/3, self.frame.size.height/4-(self.frame.size.width/3)/2, self.frame.size.width/3, self.frame.size.width/3)];
    [headerImageView setBackgroundColor:[UIColor blueColor]];
    headerImageView.layer.masksToBounds = YES;
    headerImageView.layer.cornerRadius = 4.0f;
//    [self addSubview:headerImageView];
    
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(20, headerImageView.frame.origin.y +headerImageView.frame.size.height+20, self.frame.size.width-40, 30)];
    nameLab.text = @"adasdasdasdsadadadasd";
    nameLab.textColor = [UIColor whiteColor];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.font = [UIFont systemFontOfSize:30];
//    [self addSubview: nameLab];
    
    UILabel *autoScrollLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, nameLab.frame.origin.y +nameLab.frame.size.height+20, self.frame.size.width-40, 14)];
//    autoScrollLabel.backgroundColor = [UIColor whiteColor];
    if (callOrRepace == 1) {
        autoScrollLabel.text = @"正在等待对方接受邀请";
    }else{
        
        autoScrollLabel.text = @"正在等待接受邀请";
    }
    
    autoScrollLabel.textColor = [UIColor whiteColor];
    autoScrollLabel.textAlignment = NSTextAlignmentCenter;
    autoScrollLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:autoScrollLabel];
    
    
    
    
    
    self.guaduanBtu = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    if (callOrRepace == 1) {
        [self.guaduanBtu setFrame:CGRectMake((self.frame.size.width-60)/2, self.frame.size.height-140, 60, 60)];
    }else{
        [self.guaduanBtu setFrame:CGRectMake((self.frame.size.width-120)/3, self.frame.size.height-140, 60, 60)];
        self.jietingBtu = [[UIButton alloc]initWithFrame:CGRectMake((self.frame.size.width-120)/3+60+(self.frame.size.width-120)/3, self.frame.size.height-140, 60, 60)];
//        [self.jietingBtu setBackgroundColor:[UIColor greenColor]];
        [self.jietingBtu setBackgroundImage:[UIImage imageNamed:@"jieting"] forState:UIControlStateNormal];
        [self addSubview:self.jietingBtu];
    }
    [self.guaduanBtu setBackgroundImage:[UIImage imageNamed:@"icon_call_reject_normal"] forState:UIControlStateNormal];
    [self addSubview:self.guaduanBtu];
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
