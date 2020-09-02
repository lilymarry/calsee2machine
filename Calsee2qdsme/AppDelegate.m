//
//  AppDelegate.m
//  PushDemo_OC
//
//  Created by Admin on 2018/6/7.
//  Copyright © 2018年 Rock. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
// 导入 Push_SDK 头文件

// iOS 10 Notification
#import <UserNotifications/UserNotifications.h>
#import <AVFoundation/AVFoundation.h>
#import "TXLiveBase.h"  //TRTC
#import "LoginBL.h"
#import "OneToOneViewController.h"
// appkey & AppSecret
static NSString *const testAppKey = @"31100769";
static NSString *const testAppSecret = @"e3029b663f420b93e90a6ff60f388267";

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate {
    // iOS 10 通知中心
    UNUserNotificationCenter * _notificationCenter;
}

/*
 iOS 如何判断是 *点击推送信息进入程序* 还是 *点击app图标进入程序*  ???
 当设备接到 apns 发来的通知，应用处理通知有以下几种情况:
 
 1. 应用还没有加载
 
 1.1 这时如果点击 通知的显示按钮，
 会调用   didFinishLaunchingWithOptions 方法，
 不会调用  didReceiveRemoteNotification 方法。
 
 1.2 如果点击通知的关闭按钮，再点击应用，
 只会调用 didFinishLaunchingWithOptions 方法。
 
 2. 应用加载过了
 
 2.1 应用在前台（foreground)
 这时如果收到通知，会触发 didReceiveRemoteNotification 方法。
 
 2.2 应用在后台
 此时如果收到通知，点击显示按钮，会调用 didReceiveRemoteNotification 方法。
 点击关闭再点击应用，则上面两个方法都不会被调用这时，只能在 applicationWillEnterForeground 或者 applicationDidBecomeActive, 根据发过来通知中的 badge 进行判断是否有通知，然后发请求获取数据。
 */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // APNs注册，获取deviceToken并上报
    [self registerAPNS:application];
    
    // 初始化SDK
    [self initCloudPush];
    
    // 监听推送通道打开动作
    [self listenerOnChannelOpened];
    
    // 监听推送消息到达
    [self registerMessageReceive];
    
    // 点击通知将 App 从关闭状态启动时，将通知打开回执上报 // 计算点击 OpenCount
    // [CloudPushSDK handleLaunching:launchOptions];(Deprecated from v1.8.1)
    [CloudPushSDK sendNotificationAck:launchOptions];
    
    // 主动获取设备通知是否授权 (iOS 10+)
    [self getNotificationSettingStatus];
    
    
    /*
     
     当程序处于关闭状态 (APP未运行) 收到推送通知时，
     点击 图标 会调用该方法 didFinishLaunchingWithOptions:
     那么通知可以通过 launchOptions 这个参数获取到。
     在该方法中 didFinishLaunchingWithOptions: 这个函数 在正常启动下 launchOptions 是空，
     如果你是从点击推送通知过来的，那么 laungchOptions 里面会包含你的推送的内容。
     在这里就可以进行相应的处理，你就可以发一个通知，可以在 rootViewController 中接收执行相应的操作
     */
    
    // 当APP为关闭状态 收到推送通知，点击 图标 会调用该方法 didFinishLaunchingWithOptions:
    if (launchOptions) {
        NSLog(@"\n ====== launchOptions: %@",launchOptions);
        NSDictionary *pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (pushNotificationKey) {
            // 这里定义自己的处理方式
            // 如需要代码控制 BadgeNum (icon右上角的数字)
            [UIApplication sharedApplication].applicationIconBadgeNumber = 10;
        }
    }
    
    /* 当APP为关闭状态，收到推送通知, 点击 通知栏 跳转到指定的页面 */
    [self jumpViewController:launchOptions];
    
    
    [TXLiveBase setLicenceURL:@"http://license.vod2.myqcloud.com/license/v1/5f901ebb7ffb139ab68f6d7343011500/TXLiveSDK.licence" key:@"9a344e2f2cf615b2d44fc65342a19c73"];
    
    [NSThread sleepForTimeInterval:3.0]; //引导页休眠时间
    MainViewController *main=[[MainViewController  alloc]init];
    UINavigationController *navi=[[UINavigationController alloc]initWithRootViewController:main];
    
    self.window.rootViewController=navi;
    
    return YES;
}


/**
 *    向APNs注册，获取deviceToken 用于推送
 *    @param  application
 */
- (void)registerAPNS:(UIApplication *)application {
    
    float systemVersionNum = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersionNum >= 10.0) {
        
        // iOS 10 notifications
        _notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
        
        // 创建 category，并注册到通知中心
        [self createCustomNotificationCategory];
        
        // 遵循协议
        _notificationCenter.delegate = self;
        
        // 请求客户推送通知权限，以及推送的类型
        [_notificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            if (granted) {
                // granted
                NSLog(@"\n ====== User authored notification.");
                
                // 向APNs注册，获取deviceToken  // 要求在主线程中
                dispatch_async(dispatch_get_main_queue(), ^{
                    [application registerForRemoteNotifications];
                });
                
            } else {
                // not granted
                NSLog(@"\n ====== User denied notification.");
                
                // 即使客户不允许通知也想让它通知 // 待测试
                // 向APNs注册，获取deviceToken  // 要求在主线程中
                dispatch_async(dispatch_get_main_queue(), ^{
                    [application registerForRemoteNotifications];
                });
                
            }}];
        
        /**
         *  主动获取设备通知是否授权 (iOS 10+)
         */
        [_notificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
            // 进行判断做出相应的处理
            if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
                NSLog(@"\n ====== 未选择是否允许通知");
            } else if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
                NSLog(@"\n ====== 未授权允许通知");
            } else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized){
                NSLog(@"\n ====== 已授权允许通知");
            }
        }];
        
        
    } else if (systemVersionNum >= 8.0) { // 适配 iOS_8, iOS_10.0
        
        // iOS 8 Notifications
        // 不会有黄色叹号
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [application registerForRemoteNotifications];
        
        /*
         // 提出弹窗，授权是否允许通知
         UIUserNotificationSettings * settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
         [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
         
         // 注册远程通知 (iOS_8+)
         [[UIApplication sharedApplication] registerForRemoteNotifications];
         
         if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIUserNotificationTypeNone) { //判断用户是否打开通知开关
         NSLog(@"没有打开");
         } else {
         NSLog(@"已经打开");
         }
         */
        
#pragma clang diagnostic pop
    } else {
        
        // iOS < 8 Notifications
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
        /*
         UIRemoteNotificationType types = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert;
         [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
         
         if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes]  == UIRemoteNotificationTypeNone) { //判断用户是否打开通知开关
         }
         */
        
#pragma clang diagnostic pop
    }
}

/**
 *  主动获取设备通知是否授权 (iOS 10+) 可以单独调用
 */
- (void)getNotificationSettingStatus {
    [_notificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
            NSLog(@"\n ====== User authed.");
        } else {
            NSLog(@"\n ======  User denied.");
        }}];
}


/**
 *  创建并注册通知category (iOS 10+)
 */
- (void)createCustomNotificationCategory {
    // 自定义 action1 和 action2
    UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action1" title:@"test1" options: UNNotificationActionOptionNone];
    UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"action2" title:@"test2" options: UNNotificationActionOptionNone];
    // 创建id为`test_category`的category，并注册两个action到category
    // UNNotificationCategoryOptionCustomDismissAction 表明可以触发通知的 dismiss 回调
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"test_category" actions:@[action1, action2] intentIdentifiers:@[] options: UNNotificationCategoryOptionCustomDismissAction];
    // 注册category到通知中心
    [_notificationCenter setNotificationCategories:[NSSet setWithObjects:category, nil]];
}


/*
 *  APNs注册成功回调，将返回的deviceToken上传到CloudPush服务器
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken NS_AVAILABLE_IOS(3_0) {
    NSLog(@"Upload deviceToken to CloudPush server.");
    //   NSString* newToken = [deviceToken description];
    //
    //   newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    //
    //   newToken = [newToken stringByReplacingOccurrencesOfString:@" "
    //                                                  withString:@""];
    
    
    
    [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"\n ====== Register deviceToken success, deviceToken: %@", [CloudPushSDK getApnsDeviceToken]);
            
        } else {
            NSLog(@"\n ====== Register deviceToken failed, error: %@", res.error);
        } }];
}

/*
 *  APNs注册失败回调
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"\n ====== didFailToRegisterForRemoteNotificationsWithError %@", error);
}

#pragma mark SDK Init
- (void)initCloudPush {
    // 正式上线建议关闭
    [CloudPushSDK turnOnDebug];
    // SDK初始化
    [CloudPushSDK asyncInit:testAppKey appSecret:testAppSecret callback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"\n ====== Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
            NSString* newToken = [CloudPushSDK getDeviceId];
            [[NSUserDefaults standardUserDefaults]setObject:newToken forKey:@"deviceToken"];
            NSMutableDictionary *dictoken = [[NSMutableDictionary alloc]init];
            NSString *userbh = [[NSUserDefaults standardUserDefaults] objectForKey:Userbh];
            if (userbh.length>0) {
                [dictoken setObject:userbh forKey:@"ubh"];
                [dictoken setObject:exhiid2 forKey:@"exhiid"];
                [dictoken setObject:newToken forKey:@"devicetoken"];
                [LoginBL updevicetoken:dictoken success:^(NSMutableDictionary *returnValue) {
                    
                } failure:^(NSString *errorMessage) {
                    
                }];
            }
        } else {
            NSLog(@"\n ====== Push SDK init failed, error: %@", res.error);
        }
    }];
}


/**
 *  注册推送通道 打开 监听
 */
- (void)listenerOnChannelOpened {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onChannelOpened:)
                                                 name:@"CCPDidChannelConnectedSuccess"
                                               object:nil];
    
}
/**
 *   推送通道打开回调
 *   @param notification
 */
- (void)onChannelOpened:(NSNotification *)notification {
    NSLog(@"\n ====== 温馨提示,消息通道建立成功,该通道创建成功表示‘在线’，可以接收到推送的消息");
}



/**
 *  注册推送消息 到来 监听
 */
- (void)registerMessageReceive {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMessageReceived:)
                                                 name:@"CCPDidReceiveMessageNotification"
                                               object:nil];
}

/**
 *    处理到来推送消息
 *    @param notification
 */
- (void)onMessageReceived:(NSNotification *)notification {
    NSLog(@"\n ====== Receive one message !!!!!!!");
    CCPSysMessage *message = [notification object];
    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
    NSLog(@"\n ====== Receive message title: %@, content: %@.", title, body);
    NSLog(@"\n ====== 当前线程 %@",[NSThread currentThread]);
    
}

#pragma mark —页面跳转
- (void)jumpViewController:(NSDictionary *)tfdic {
    
    NSDictionary *remoteNotification = [tfdic objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    for (NSString *tfStr in remoteNotification) {
        
        // 通知里面的内容需要包含 " "
        //        if ([tfStr isEqualToString:@"careline"]) {
        //            JumpViewController *_viewController =  [[JumpViewController alloc]init];
        //            UINavigationController *nav= (UINavigationController *)self.window.rootViewController;
        //            [nav pushViewController:_viewController animated:YES];
        //        }
    }
}


/**
 *  iOS 10 + 实现两个代理方法之一。
 *  当APP处于后台  点击通知栏通知
 *  触发通知动作时回调，比如点击、删除通知和点击自定义 action(iOS 10+)
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    
    NSString *userAction = response.actionIdentifier;
    
    // 点击通知打开
    if ([userAction isEqualToString:UNNotificationDefaultActionIdentifier]) {
        NSLog(@"\n ====== User opened the notification.");
        // 处理iOS 10通知，并上报通知打开回执
        [self handleiOS10Notification:response.notification];
    }
    // 通知dismiss，category 创建时传入 UNNotificationCategoryOptionCustomDismissAction 才可以触发
    if ([userAction isEqualToString:UNNotificationDismissActionIdentifier]) {
        NSLog(@"\n ====== User dismissed the notification.");
    }
    NSString *customAction1 = @"action1";
    NSString *customAction2 = @"action2";
    
    // 点击用户自定义Action1
    if ([userAction isEqualToString:customAction1]) {
        NSLog(@"User custom action1.");
    }
    
    // 点击用户自定义Action2
    if ([userAction isEqualToString:customAction2]) {
        NSLog(@"User custom action2.");
    }
    completionHandler();
}


/**
 *  App 处于前台时收到通知 (iOS 10+ )
 *  iOS 10 + 实现两个代理方法之一。
 *  只有当应用程序位于前台时，该方法才会在委托上调用。如果方法未被执行或处理程序没有及时调用，则通知将不会被提交。
 *  应用程序可以选择将通知呈现为声音、徽章、警报和/或通知列表中。此决定应基于通知中的信息是否对用户可见。
 */
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
//    NSLog(@"\n ====== App 处于前台时收到通知 (iOS 10+ ) Receive a notification in foregound.");
//
//    //音效文件路径
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"PushSound" ofType:@"caf"];
//    // 这里是指你的音乐名字和文件类型
//    NSLog(@"path-----------------------%@",path);
//
//    //组装并播放音效
//    SystemSoundID soundID;
//    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
//    AudioServicesPlaySystemSound(soundID);
//
//    // 处理iOS 10通知，并上报通知打开回执
//    [self handleiOS10Notification:notification];
//
//    /*
//     处理完成后调用 completionHandler ，用于指示在前台显示通知的形式
//     completionHandler() 功能：可设置是否在应用内弹出通知
//     在 iOS 10 中 通知在前台的显示设置：
//     */
//
//    // 1、通知在前台不显示
//    // 如果调用下面代码： 通知不在前台弹出也不在通知栏显示
//    // completionHandler(UNNotificationPresentationOptionNone);
//
//    // 2、通知在前台显示
//    // 如果调用下面代码： 通知在前台弹出也在通知栏显示
//    // completionHandler(UNNotificationPresentationOptionAlert);
//
//
//    // 3、通知在前台显示 并带有声音
//    // 如果调用下面代码：通知弹出，且带有声音、内容和角标
//    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
//}

/**
 *  处理App 处于前台时收到通知 (iOS 10+ )
 */
- (void)handleiOS10Notification:(UNNotification *)notification {
    
    UNNotificationRequest *request = notification.request;
    UNNotificationContent *content = request.content;
    
    NSDictionary *userInfo = content.userInfo;
    // 通知时间
    NSDate *noticeDate = notification.date;
    // 标题
    NSString *title = content.title;
    // 副标题
    NSString *subtitle = content.subtitle;
    // 内容
    NSString *body = content.body;
    // 角标
    int badge = [content.badge intValue];
    // 取得通知自定义字段内容，例：获取key为"Extras"的内容
    NSString *extras = [userInfo valueForKey:@"Extras"];
    // 通知角标数清0
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // 同步角标数到服务端 SDK1.9.5 以后才支持
    // [self syncBadgeNum:0];
    
    // 通知打开回执上报
    [CloudPushSDK sendNotificationAck:userInfo];
    
    NSLog(@"\n ====== App 处于前台时收到通知 (iOS 10+ ) Notification, == date: %@, == title: %@, == subtitle: %@, == body: %@, == badge: %d, == extras: %@.", noticeDate, title, subtitle, body, badge, extras);
    NSDictionary *alertDic = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    NSString *bodyStr = [alertDic objectForKey:@"body"];
    NSData *jsonData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary * arr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers error:&err];
    NSDictionary *detailDic = [arr objectForKey:@"detail"];
    UIViewController *viewController = [AppDelegate currentViewController];
    [viewController.navigationController setNavigationBarHidden:YES animated:YES];
    OneToOneViewController *play=[[OneToOneViewController alloc]init];
    play.callFrom = 2;
    play.roomid = [detailDic objectForKey:@"roomid"];
    [viewController.navigationController pushViewController:play animated:YES];
    
    
    
}

/* 同步通知角标数到服务端 */
- (void)syncBadgeNum:(NSUInteger)badgeNum {
    [CloudPushSDK syncBadgeNum:badgeNum withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"\n ====== Sync badge num: [%lu] success.", (unsigned long)badgeNum);
        } else {
            NSLog(@"\n ====== Sync badge num: [%lu] failed, error: %@", (unsigned long)badgeNum, res.error);
        }
    }];
}

// iOS (3_0, 10_0) App 处于前台,如果收到 远程通知 则调用该处理方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // 通过远程通知进入应用时候
    application.applicationIconBadgeNumber = 0;
    /*
     1、  在 iOS7 上时，只要收到通知，就会调起 didReceiveRemoteNotification
     1.2、当程序处于前台工作时，这时候若收到消息推送，会调用该这个方法
     1.3、当程序处于后台运行时，这时候若收到消息推送，如果点击消息或者点击消息图标时，也会调用该这个方法
     2、  但在 iOS_8 上时，只有app前台运行或充电时，才会调起didReceiveRemoteNotification
     2.1、并且 iOS_8 得开启后台模式下接收远程通知。工程配置 TARGATES --> Capabilities BackgroundModes -> ON 选择 RemoteNotification
     */
    
    // 2.2、处理方法：
    if (application.applicationState == UIApplicationStateActive) {
        //前台时候
        if ([[userInfo objectForKey:@"aps"] objectForKey:@"alert"]!= NULL) {
            //处理情况
        }
    } else {
        //后台时候
        //这里定义自己的处理方式
    }
}

// iOS(8_0, 10_0） 当应用程序被用户从远程通知中选择操作时激活,调用该方法处理程序（
- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(nonnull void (^)(void))completionHandler {
    
    
    
    
    
    
}

// iOS 7+ 不论是前台还是后台只要有远程推送都会调用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler  NS_AVAILABLE_IOS(7_0) {
    
    NSLog(@"\n ====== iOS 7+ 前台后台都会调用");
    
    /*
     建议使用该方法，还有一个作用。根据苹果给出的文档，系统给出30s的时间对推送的消息进行处理，此后就会运行CompletionHandler 程序块。
     在处理这类推送消息（即程序被启动后接收到推送消息）的时候，通常会遇到这样的问题 :
     就是当前的推送消息是当前程序正在前台运行时接收到的，还是说是程序在后台运行，用户点击系统消息通知栏对应项进入程序时而接收到的？这个其实很简单，用下面的代码就可以解决：
     */
    
    // 做相应的判断是前台还是后台
    if (application.applicationState == UIApplicationStateActive) {
        
        // 程序当前正处于前台 如果不做处理里面不用写 就可以了
        
        /*
         关于userInfo的结构，参照苹果的官方结构：
         {
         "aps" : {
         "alert" : "You got your emails.",
         "badge" : 9,
         "sound" : "bingbong.aiff"
         "acme1" : "bar",
         "acme2" : 42
         }
         
         即key aps 对应了有一个字典，里面是该次推送消息的具体信息。具体跟我们注册的推送类型有关。另外剩下的一些key就是用户自定义的了。
         */
        
        NSDictionary *alertDic = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        NSString *bodyStr = [alertDic objectForKey:@"body"];
        NSData *jsonData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary * arr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers error:&err];
        NSDictionary *detailDic = [arr objectForKey:@"detail"];
        UIViewController *viewController = [AppDelegate currentViewController];
        [viewController.navigationController setNavigationBarHidden:YES animated:YES];
        OneToOneViewController *play=[[OneToOneViewController alloc]init];
        play.callFrom = 2;
        play.roomid = [detailDic objectForKey:@"roomid"];
        [viewController.navigationController pushViewController:play animated:YES];
        
    } else if (application.applicationState == UIApplicationStateInactive) {
        NSDictionary *alertDic = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        NSString *bodyStr = [alertDic objectForKey:@"body"];
        NSData *jsonData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary * arr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers error:&err];
        NSDictionary *detailDic = [arr objectForKey:@"detail"];
        UIViewController *viewController = [AppDelegate currentViewController];
        [viewController.navigationController setNavigationBarHidden:YES animated:YES];
        OneToOneViewController *play=[[OneToOneViewController alloc]init];
        play.callFrom = 2;
        play.roomid = [detailDic objectForKey:@"roomid"];
        [viewController.navigationController pushViewController:play animated:YES];
        // 程序处于后台 做相应的处理
        //        for (NSString *tfStr in userInfo) {
        //            if ([tfStr isEqualToString:@"careline"]) {
        //                JumpViewController *_viewController =  [[JumpViewController alloc]init];
        //                UINavigationController *nav= (UINavigationController *)self.window.rootViewController;
        //                [nav pushViewController:_viewController animated:YES];
        //            }
        //        }
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    NSLog(@" \n ------ App 在后台运行 点击 icon 激活的APP ------");
    
    if (application.applicationIconBadgeNumber != 0) {
        
        // 发起请求获取未读消息的内容
        
        // 点击 icon 从后台进入应用时, 对 badge 的处理
        application.applicationIconBadgeNumber = 0;
        
        // 清除导航栏未读的通知
        [_notificationCenter removeAllDeliveredNotifications];
        
    }
    
    /* 备注：
     APP在后台：  如果不是点击通知栏进入APP， 是通过点击icon 进入程序是拿不到推送消息的。
     原因是这样的：如果堆积了多条应用，回调将会变得复杂，而且没用。
     正确的做法是，服务器要缓存好当前的未读消息，进入应用的时候去获取未读消息。
     */
}

- (void)applicationWillTerminate:(UIApplication *)application { }

+ (UIViewController*)currentViewController{
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1) {
        
        if ([vc isKindOfClass:[UITabBarController class]]) {
            
            vc = ((UITabBarController*)vc).selectedViewController;
            
        }
        
        
        
        if ([vc isKindOfClass:[UINavigationController class]]) {
            
            vc = ((UINavigationController*)vc).visibleViewController;
            
        }
        
        
        
        if (vc.presentedViewController) {
            
            vc = vc.presentedViewController;
            
        }else{
            
            break;
            
        }
        
        
        
    }
    
    
    
    return vc;
}
@end
