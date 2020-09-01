//
//  ReportReasonView.m
//  Calsee2qdsme
//
//  Created by SCHENK on 2020/8/31.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import "ReportReasonView.h"

@interface ReportReasonView ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *reasonTX;
@property (weak, nonatomic) IBOutlet UIButton *cacelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@end

@implementation ReportReasonView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"ReportReasonView" owner:self options:nil];
        [self addSubview:_thisView];
        
        _cacelBtn.layer.masksToBounds = YES;
        _cacelBtn.layer.cornerRadius =15;
        _cacelBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
        _cacelBtn.layer.borderWidth=1;
        
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.layer.cornerRadius =15;
        _sureBtn.layer.borderColor=[UIColor colorWithRed:234/255.0 green:91/255.0 blue:30/255.0 alpha:1].CGColor;
        _sureBtn.layer.borderWidth=1;
        
       // _reasonTX.layer.masksToBounds = YES;
       // _reasonTX.layer.cornerRadius =15;
        _reasonTX.layer.borderColor=[UIColor lightGrayColor].CGColor;
        _reasonTX.layer.borderWidth=1;
        
        _reasonTX.delegate=self;
       
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _thisView.frame = self.bounds;
}
- (IBAction)cancelPress:(id)sender {
    [self removeFromSuperview];
}
- (IBAction)surePress:(id)sender {
    self.reasonBlock( _reasonTX.text);
    
    [self removeFromSuperview];
    
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text=@"";
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length==0) {
         textView.text=@"请输入举报理由";
    }
}
@end
