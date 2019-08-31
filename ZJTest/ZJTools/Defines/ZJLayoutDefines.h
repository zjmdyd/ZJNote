//
//  ZJLayoutDefines.h
//  ZJTest
//
//  Created by ZJ on 2019/4/4.
//  Copyright © 2019 HY. All rights reserved.
//

#ifndef ZJLayoutDefines_h
#define ZJLayoutDefines_h

#ifndef Window
#define Window [UIApplication sharedApplication].window
#endif

#ifndef KeyWindow
#define KeyWindow [UIApplication sharedApplication].keyWindow
#endif

#ifndef kScreenW
#define kScreenW    ([UIScreen mainScreen].bounds.size.width)
#define kScreenH    ([UIScreen mainScreen].bounds.size.height)
#endif

#ifndef kStatusBarH
#define kStatusBarH 20
#endif

#ifndef kNaviBarHeight
#define kNaviBarHeight 44
#endif

#ifndef kNaviBottoom
#define kNaviBottoom (kIsIphoneX ? 88 : 64)
#endif

#ifndef kTabBarHeight
#define kTabBarHeight (kIsIphoneX ? 83 : 49)
#endif

#ifndef kIsAboveI5
#define kIsAboveI5 (kScreenW > 320)     // 是否是iPhone5以上的手机
#endif

#ifndef kIsIplus
#define kIsIplus (kScreenW > 375)       // 是否是plus系列
#endif

#ifndef kIsIphoneX
#define kIsIphoneX (kScreenH > 736)       // 是否是iphoneX系列
#endif

#ifndef kIsIphoneXMax
#define kIsIphoneXMax (kScreenH > 812)       // 是否是iphoneX Max系列
#endif

#define kIsAboveiOS11 [UIDevice currentDevice].systemVersion.integerValue >= 11

#endif /* ZJLayoutDefines_h */
