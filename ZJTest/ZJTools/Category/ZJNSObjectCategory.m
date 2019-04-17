//
//  ZJNSObjectCategory.m
//  ZJCustomTools
//
//  Created by ZJ on 6/13/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJNSObjectCategory.h"
#include <objc/runtime.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "sys/utsname.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <sys/stat.h>
#import <AudioToolbox/AudioToolbox.h>

// 方法弃用警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@implementation ZJNSObjectCategory

@end

@implementation NSObject (ZJObject)

- (NSArray *)objectProperties {
    u_int count;
    
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++) {
        const char* propertyName = property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    
    free(properties);
    
    return propertiesArray;
}

- (id)nextResponderWithTargetClassName:(NSString *)className {
    Class class = objc_getClass([className UTF8String]);
    
    if ([self isKindOfClass:class]) {
        return self;
    }
    return [[(id)self nextResponder] nextResponderWithTargetClassName:className];
}

- (void)writeToFileWithPathComponent:(NSString *)name {
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    NSError *error;
    NSLog(@"writePath = %@", [documentsPath stringByAppendingPathComponent:name]);
    [data writeToFile:[documentsPath stringByAppendingPathComponent:name] options:NSDataWritingAtomic error:&error];
    
    if (error) {
        NSLog(@"写入失败error:%@", error);
    }else {
        NSLog(@"写入成功");
    }
}

- (id)readFileWithPathComponent:(NSString *)name {
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSData *data = [NSData dataWithContentsOfFile:[documentsPath stringByAppendingPathComponent:name]];
    NSLog(@"readPath = %@", [documentsPath stringByAppendingPathComponent:name]);
    
    id value;
    if (data) {
        NSError *error;
        value =  [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            NSLog(@"读取文件失败error:%@", error);
        }else {
            NSLog(@"读取文件成功");
        }
    }
    
    return value;
}

- (void)removeFileWithPathComponent:(NSString *)name {
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:[documentsPath stringByAppendingPathComponent:name] error:&error];
    if (error) {
        NSLog(@"移除失败");
    }else {
        NSLog(@"移除成功");
    }
}

- (NSString *)jsonString {
    if (self == nil) return nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return str;
}

- (UIViewController *)createVCWithName:(NSString *)name title:(NSString *)title {
    return [self createVCWithName:name title:title isGroupTableVC:NO];
}

- (UIViewController *)createVCWithName:(NSString *)name title:(NSString *)title isGroupTableVC:(BOOL)isGroup {
    UIViewController *vc = [NSClassFromString(name) alloc];
    if ([vc isKindOfClass:[UITableViewController class]]) {
        vc = [(UITableViewController *)vc initWithStyle:isGroup ? UITableViewStyleGrouped : UITableViewStylePlain];
    }else {
        vc = [vc init];
        vc.view.backgroundColor = [UIColor whiteColor];;
    }
    
    if ([vc isKindOfClass:[UIViewController class]]) {
        vc.title = title;
    }
    
    return vc;
}

@end


/**
 ********************************************************
 *********************** 系统 ****************************
 ********************************************************
 */

#pragma mark - UIApplication

@implementation UIApplication (ZJApplication)

+ (UIViewController *)currentVC {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];    // UILayoutContainerView
    id nextResponder = [frontView nextResponder];               // ZJBaseTabBarViewController
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
        
        UIView *view = [self subViews:[frontView subviews][0]];
        if ([[view nextResponder] isKindOfClass:[UIViewController class]]) {
            result = (UIViewController *)[view nextResponder];
        }
    }
    
    else
        result = window.rootViewController;
    
    return result;
}

+ (UIView *)subViews:(UIView *)view {
    if (view.subviews.count) {
        for (UIView *subView in view.subviews) {
            if (![[view nextResponder] isKindOfClass:[UINavigationController class]] && [[view nextResponder] isKindOfClass:[UIViewController class]]) {
                return view;
            }else {
                return [self subViews:subView];
            }
        }
    }
    
    return view;
}

- (void)synCooks {
    NSMutableArray *cookieDictionary = [[NSUserDefaults standardUserDefaults] valueForKey:@"cookieArray"];
    
    for (int i = 0; i < cookieDictionary.count; i++) {
        NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults] valueForKey:[cookieDictionary objectAtIndex:i]];
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:dic];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
}

- (void)storeCooks {
    NSMutableArray *cookieArray = [[NSMutableArray alloc] init];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [cookieArray addObject:cookie.name];
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:cookie.name forKey:NSHTTPCookieName];
        [cookieProperties setObject:cookie.value forKey:NSHTTPCookieValue];
        [cookieProperties setObject:cookie.domain forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:cookie.path forKey:NSHTTPCookiePath];
        [cookieProperties setObject:[NSNumber numberWithUnsignedInteger:cookie.version] forKey:NSHTTPCookieVersion];
        [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
        
        [[NSUserDefaults standardUserDefaults] setValue:cookieProperties forKey:cookie.name];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:cookieArray forKey:@"cookieArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeCooks {
    NSMutableArray *cookieDictionary = [[NSUserDefaults standardUserDefaults] valueForKey:@"cookieArray"];
    
    for (int i = 0; i < cookieDictionary.count; i++) {
        NSMutableDictionary* dic = [[NSUserDefaults standardUserDefaults] valueForKey:[cookieDictionary objectAtIndex:i]];
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:dic];
        if (cookie) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:cookie.name];
        }
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cookieArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 系统声音

#ifndef AudioPath
#define AudioPath @"/System/Library/Audio/UISounds/"
#endif

+ (void)playSystemVibrate {
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

+ (void)playSystemSoundWithName:(NSString *)name {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", AudioPath, name]];
    
    [self playWithUrl:url];
}

+ (void)playSoundWithResourceName:(NSString *)name type:(NSString *)type {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    if (path) {
        [self playWithUrl:[NSURL fileURLWithPath:path]];
    }
}

+ (void)playWithUrl:(NSURL *)url {
    if (url) {
        SystemSoundID soundID;
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
        if (error == kAudioServicesNoError) {
            AudioServicesPlayAlertSound(soundID);
        }else {
            NSLog(@"******Failed to create sound********");
        }
    }
}

#pragma mark - 系统服务

+ (void)systemServiceWithPhone:(NSString *)phone type:(SystemServiceType)type {
    if (phone.length) {
        NSString *str;
        if (type == SystemServiceTypeOfPone) {                  // 电话
            str = [NSString stringWithFormat:@"tel:%@", phone];
        }else if (type == SystemServiceTypeOfMessage) {         // 信息
            str = [NSString stringWithFormat:@"sms:%@", phone];
        }
        
        [self openURLWithURLString:str completionHandler:^(BOOL success) {
            if (!success) {
                NSLog(@"******设备不支持此功能********");
            }
        }];
    }else {
        NSLog(@"******设备不支持此功能********");
    }
}

//
+ (void)openURLWithURLString:(NSString * _Nonnull )urlString completionHandler:(void (^)(BOOL success))completion {
    NSURL *url = [NSURL URLWithString:urlString];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            if (completion) {
                completion(success);
            }
        }];
    } else {
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }else {
            if (completion) {
                completion(NO);
            }
        }
    }
}

+ (void)openAppDownloadPage:(NSString *)appID {
    if (appID.length) {
        [self openURLWithURLString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8", appID] completionHandler:^(BOOL success) {
            if (!success) {
                NSLog(@"******下载地址出错********");
            }
        }];
    }else {
        NSLog(@"******下载地址出错********");
    }
}

#pragma mark - App info

+ (NSString *)appInfoWithType:(AppInfoType)type {
    NSArray *key = @[@"CFBundleDisplayName", @"CFBundleName", @"CFBundleShortVersionString", @"CFBundleVersion", @"CFBundleIdentifier"];
    NSDictionary *infoDictionary = [self appInfoDic];
    return [infoDictionary objectForKey:key[type]];
}

+ (NSDictionary *)appInfoDic {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return infoDictionary;
}

+ (BOOL)isComVersion {
    return [[self appInfoWithType:AppInfoTypeOfBundleIdentifier] hasPrefix:@"com"];
}

/**
 *  是否是简体中文
 */
+ (BOOL)isSimplifiedChinese {
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"zh-Hans-CN"]) {  // 简体中文
        return YES;
    }
    return NO;
}

// 根据缩写获取语言title
+ (NSString *)getLanguageTitleWithAbbr:(NSString *)abbr {
    for (NSDictionary *dic in [self languageInfo]) {
        if ([dic[@"abbr"] isEqualToString:abbr]) {
            return dic[@"title"];
        }
    }
    
    return @"获取失败";
}

+ (NSArray *)languageInfo {
    return @[
             @{
                 @"title" : @"简体中文", @"abbr" : @"zh-Hans-CN",
                 },
             @{
                 @"title" : @"繁体中文", @"abbr" : @"zh-Hant-CN",
                 },
             @{
                 @"title" : @"繁体中文(香港)", @"abbr" : @"zh-Hant-HK",
                 },
             @{
                 @"title" : @"繁体中文(澳门)", @"abbr" : @"zh-Hant-MO",
                 },
             @{
                 @"title" : @"繁体中文(台湾)", @"abbr" : @"zh-Hant-TW",
                 },
             @{
                 @"title" : @"英文", @"abbr" : @"en-CN",
                 },
             ];
}

#pragma mark - Network state

+ (NSString *)netWorkStates {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    NSString *state = [[NSString alloc] init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    break;
                case 1:
                    state =  @"2G";
                    break;
                case 2:
                    state =  @"3G";
                    break;
                case 3:
                    state =   @"4G";
                    break;
                case 5:
                    state =  @"wifi";
                    break;
                default:
                    break;
            }
        }
    }
    return state;
}
/*
 Access WiFi Infomation
 */
+ (id)fetchCurrentWiFiInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) {
            break;
        }
    }
    return info;
}

+ (NSString *)ipAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

#pragma mark - 判断是否安装某APP

+ (BOOL)installedQQ {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
}

+ (BOOL)installedWeiXin {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
}

+ (BOOL)installedAlipay {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]];
}

@end


#pragma mark - Device info

@implementation UIDevice (ZJDevice)

+ (CGFloat)systemVersion {
    return [UIDevice currentDevice].systemVersion.floatValue;
}

+ (BOOL)jailbroken {
    struct stat stat_info;
    if (0 == stat("/Applications/Cydia.app", &stat_info)) {
        NSLog(@"Device is jailbroken");
        return YES;
    }
    
    return NO;
}

@end


/// APP信息:
/*
 NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
 CFShow(infoDictionary);
 // app名称
 NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
 // app版本
 NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
 // app build版本
 NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
 
 //手机序列号
 NSString* identifierNumber = [[UIDevice currentDevice] uniqueIdentifier];
 NSLog(@"手机序列号: %@",identifierNumber);
 //手机别名： 用户定义的名称
 NSString* userPhoneName = [[UIDevice currentDevice] name];
 NSLog(@"手机别名: %@", userPhoneName);
 //设备名称
 NSString* deviceName = [[UIDevice currentDevice] systemName];
 NSLog(@"设备名称: %@",deviceName );
 //手机系统版本
 NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
 NSLog(@"手机系统版本: %@", phoneVersion);
 //手机型号
 NSString* phoneModel = [[UIDevice currentDevice] model];
 NSLog(@"手机型号: %@",phoneModel );
 //地方型号  （国际化区域名称）
 NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
 NSLog(@"国际化区域名称: %@",localPhoneModel );
 */
