//
//  ReportReasonView.h
//  Calsee2qdsme
//
//  Created by SCHENK on 2020/8/31.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ReportReasonViewBlock)(NSString *reason);
@interface ReportReasonView : UIView
@property (strong, nonatomic) IBOutlet UIView *thisView;
@property (nonatomic, copy) ReportReasonViewBlock reasonBlock ;
@end


NS_ASSUME_NONNULL_END
