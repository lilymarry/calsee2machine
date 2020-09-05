//
//  TimeExchange.m
//  YDLSHOPPING
//
//  Created by mac on 2019/10/18.
//  Copyright © 2019 sunjiayu. All rights reserved.
//

#import "HelpCommon.h"

@implementation HelpCommon
//时间戳转时间
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString  andFormatter:(NSString *)format
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
     formatter.timeZone = [NSTimeZone localTimeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    NSDate* date ;
    // 毫秒值转化为秒 // *1000 是精确到毫秒，不乘就是精确到秒
    if(timeString.length>13)
        
    {
        date = [NSDate dateWithTimeIntervalSince1970:[timeString longLongValue]/ 1000.0]; //返回的是13位的时间戳的话,是精确到了毫秒,需要除以1000
    }
    else
    {
        date = [NSDate dateWithTimeIntervalSince1970:[timeString longLongValue]];
    }
    
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
#pragma mark - 将某个时间转化成 时间戳
+(NSString *)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format
{    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format];
    //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    
    //NSLog(@"将某个时间转化成 时间戳&&&&&&&timeSp:%ld",(long)timeSp); //时间戳的值
    NSString *str =[NSString stringWithFormat:@"%ld",(long)timeSp];
    return str;
    
}
//邮箱验证
+ (BOOL) validateEmail:(NSString *)email

{ NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
 NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
  BOOL isTrue =[emailTest evaluateWithObject:email];
    return isTrue;
   
}

//压缩图片为指定大小
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

+(NSString*)ArrToJSONString:(NSArray  *)arr{
    
    NSError*error =nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr
                        
                                                       options:kNilOptions
                        
                                                         error:&error];
    
    
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                            
                                                 encoding:NSUTF8StringEncoding];
    
    return jsonString;
    
}

//字典转json

+ (NSString*)dicToJSONString:(NSDictionary  *)arr
{
    NSError*error =nil;
    NSData*jsonData =nil;
    if(!self) {
        return nil;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [arr enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key,id  _Nonnull obj,BOOL*_Nonnull stop) {
        NSString*keyString =nil;
        NSString*valueString =nil;
        
        if ([key isKindOfClass:[NSString class]]) {
            
            keyString = key;
            
        }else{
            
            keyString = [NSString stringWithFormat:@"%@",key];
            
        }
        
        
        
        if ([obj isKindOfClass:[NSString class]]) {
            
            valueString = obj;
            
        }else{
            
            valueString = [NSString stringWithFormat:@"%@",obj];
            
        }
        
        
        
        [dict setObject:valueString forKey:keyString];
        
    }];
    
    jsonData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&error];
    
    if([jsonData length] == 0 || error !=nil) {
        
        return nil;
        
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
    
    
    
}

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    
    // strip 0X if it appears
    
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    
    range.location = 0;
    
    range.length = 2;
    
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
            
                           green:((float) g / 255.0f)
            
                            blue:((float) b / 255.0f)
            
                           alpha:1.0f];
    
}
/**
将UTC日期字符串转为本地时间字符串
eg: 2017-10-25 02:07:39  -> 2017-10-25 10:07:39
*/
+ (NSString *)getLocalDateFormateUTCDate:(NSString *)utcStr {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    format.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDate *utcDate = [format dateFromString:utcStr];
    format.timeZone = [NSTimeZone localTimeZone];
    NSString *dateString = [format stringFromDate:utcDate];
    return dateString;
}

//+(UIImage *)zipImage:(UIImage *)image
//{
//    CGSize imagesize = image.size;
//    float XX=imagesize.width/ScreenWidth;//宽度比
//    float YY=imagesize.height/XX;//在屏幕上的高度
//    imagesize.width = ScreenWidth;//放大倍数
//    imagesize.height =YY;
//    UIImage *ima = [HelpCommon scaleToSize:image size:imagesize];
//    
//    return ima;
//}
#pragma mark 字符串高宽、自定字体
//+ ( CGSize )stringSize:(NSString *)str size:(CGSize)size fontWithName:(NSString *)fontName size:(NSInteger)fontSize
//{
//    CGSize labelsize1  = [str
//                    boundingRectWithSize:size
//        options:NSStringDrawingUsesLineFragmentOrigin
//        attributes:@{NSFontAttributeName: [UIFont fontWithName:fontName size:fontSize]}
//            context:nil].size;
//    return labelsize1;
//}
#pragma mark 字符串高宽、系统字体
//+ ( CGSize )stringSystemSize:(NSString *)str size:(CGSize)size  fontSize:(NSInteger)fontSize
//{
//    CGSize labelsize1  = [str
//                    boundingRectWithSize:size
//        options:NSStringDrawingUsesLineFragmentOrigin
//        attributes:@{NSFontAttributeName: font(fontSize)}
//            context:nil].size;
//    return labelsize1;
//}
@end
