//
//  ZJNSObjectCategory.h
//  ZJCustomTools
//
//  Created by ZJ on 6/13/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZJNSObjectCategory : NSObject

@end

typedef NS_ENUM(NSInteger, SystemServiceType) {
    SystemServiceTypeOfPone,
    SystemServiceTypeOfMessage,
};

typedef NS_ENUM(NSInteger, AppInfoType) {
    AppInfoTypeOfDisplayName,
    AppInfoTypeOfBundleName,
    AppInfoTypeOfVersion,
    AppInfoTypeOfBundleVersion,
    AppInfoTypeOfBundleIdentifier
};

@interface NSObject (ZJObject)

/**
 * 获取对象的所有属性
 */
- (NSArray *)objectProperties;
- (id)nextResponderWithTargetClassName:(NSString *)className;

/**
 *  保存 读取 删除文件
 */
- (void)writeToFileWithPathComponent:(NSString *)name;
- (id)readFileWithPathComponent:(NSString *)name;
- (void)removeFileWithPathComponent:(NSString *)name;

- (NSString *)jsonString;

/**
 *  根据控制器名字创建控制器
 */
- (UIViewController *)createVCWithName:(NSString *)name title:(NSString *)title;
- (UIViewController *)createVCWithName:(NSString *)name title:(NSString *)title isGroupTableVC:(BOOL)isGroup;

/**
 ********************************************************
 *********************   系统    *************************
 ********************************************************
 */

@end


#pragma mark - UIApplication

@interface UIApplication (ZJApplication)

/**
 获取当前屏幕显示的viewcontroller
 */
+ (UIViewController *)currentVC;

/**
 *  Cookie
 */
- (void)synCooks;
- (void)storeCooks;
- (void)removeCooks;

#pragma mark - 声音

/**
 *  系统震动音
 */
+ (void)playSystemVibrate;

/**
 *  根据系统声音名播放声音
 *
 *  @param name 系统提供的声音名
 */
+ (void)playSystemSoundWithName:(NSString *)name;

/**
 根据地址播放音频
 */
+ (void)playWithUrl:(NSURL *)url;

/**
 *  播放用户提供的音频文件
 *
 *  @param name 文件名
 *  @param type         文件类型(.mp3 .wav等)
 */
+ (void)playSoundWithResourceName:(NSString *)name type:(NSString *)type;

#pragma mark - 系统服务

+ (void)systemServiceWithPhone:(NSString *)phone type:(SystemServiceType)type;
+ (void)openURLWithURLString:(NSString *)urlString completionHandler:(void (^)(BOOL success))completion;
+ (void)openAppDownloadPage:(NSString *)appID;

#pragma mark - App info

+ (NSString *)appInfoWithType:(AppInfoType)type;
+ (BOOL)isComVersion;

/**
 简体中文判断
 */
+ (BOOL)isSimplifiedChinese;
+ (NSString *)getLanguageTitleWithAbbr:(NSString *)abbr;

#pragma mark - Network state

/**
 *  获取网络状态
 */
+ (NSString *)netWorkStates;

/**
 * 获取当前WiFi信息 {
 BSSID = "82:89:17:c4:b2:43";
 SSID = hanyou03;
 SSIDDATA = <68616e79 6f753033>;
 }*/
+ (id)fetchCurrentWiFiInfo;

+ (NSString *)ipAddress;


//#pragma mark - 判断是否安装某APP
//
//+ (BOOL)installedQQ;
//+ (BOOL)installedWeiXin;
//+ (BOOL)installedAlipay;

@end


#pragma mark - Device info

@interface UIDevice (ZJDevice)

/**
 *  设备型号
 *
 *  @return iphone5, iphone6....
 */
+ (NSString *)deviceType;

+ (CGFloat)systemVersion;

/**
 检测设备是否越狱
 */
+ (BOOL)jailbroken;

@end
