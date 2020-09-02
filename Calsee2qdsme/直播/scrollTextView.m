//
//  scrollTextView.m
//  Calsee2qdsme
//
//  Created by zell on 2020/8/30.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import "scrollTextView.h"

@implementation scrollTextView

-(void)setViewInfo:(NSDictionary *)textStr{
    
    UIImageView *headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(3, 3, 38, 38)];
    [headerImage setBackgroundColor:[UIColor whiteColor]];
    headerImage.layer.masksToBounds = YES;
    headerImage.layer.cornerRadius = 19;
    
//    [self addSubview:headerImage];
    NSDictionary *dict =@{NSFontAttributeName:[UIFont systemFontOfSize:11.f ]};
    CGSize infoSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-18-64-63+38, MAXFLOAT);
    //默认的
    // 参数1: 自适应尺寸,提供一个宽度,去自适应高度
    // 参数2:自适应设置 (以行为矩形区域自适应,以字体字形自适应)
    // 参数3:文字属性,通常这里面需要知道是字体大小
    // 参数4:绘制文本上下文,做底层排版时使用,填nil即可
    //上面方法在计算文字高度的时候可能得到的是带小数的值,如果用来做视图尺寸的适应的话,需要使用更大一点的整数值.取整的方法使用ceil函数
    CGSize size = [[textStr objectForKey:@"nr"] boundingRectWithSize:infoSize options:NSStringDrawingUsesLineFragmentOrigin  | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    
    CGSize sizename = [[textStr objectForKey:@"mc"] boundingRectWithSize:infoSize options:NSStringDrawingUsesLineFragmentOrigin  | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    if (size.width < sizename.width) {
        size.width = sizename.width;
    }else{
        
    }
    UILabel *companyLab = [[UILabel alloc]initWithFrame:CGRectMake(46-38, 9, size.width, 10)];
    companyLab.textAlignment = NSTextAlignmentLeft;
    companyLab.textColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.8f];
    companyLab.text = [textStr objectForKey:@"mc"];
    companyLab.font = [UIFont systemFontOfSize:10];
    [self addSubview:companyLab];
    
    UILabel *textlab = [[UILabel alloc]initWithFrame:CGRectMake(46-38, 25, size.width, size.height)];
    textlab.textAlignment = NSTextAlignmentLeft;
    textlab.textColor = [UIColor whiteColor];
    textlab.font = [UIFont systemFontOfSize:11];
    textlab.text = [textStr objectForKey:@"nr"];
    textlab.numberOfLines = 0;
    [self addSubview:textlab];
    
    self.viewHeight = 9+10+6+size.height+3;
    self.viewWidth = 46+size.width+16;
    if (self.viewHeight > 38+6) {
        
    }else{
        self.viewHeight = 44;
    }
    [self setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.4f]];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 22;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
