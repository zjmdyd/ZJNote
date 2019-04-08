//
//  ZJOtherDefines.h
//  ZJTest
//
//  Created by ZJ on 2019/4/4.
//  Copyright © 2019 HY. All rights reserved.
//

#ifndef ZJOtherDefines_h
#define ZJOtherDefines_h


#ifndef DefaultAnimationDuration
#define DefaultAnimationDuration 0.5
#endif

#ifndef DefaultTimeoutInterval
#define DefaultTimeoutInterval 15
#endif

#ifndef ZJNaviCtrl
#define ZJNaviCtrl navigationController
#endif

#ifndef textViewPlacehold
#define textViewPlacehold textViewPlacehold
#endif

#define kRGBA(r, g, b, a)       [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]
#define UIColorFromHex(s)  [UIColor colorWithRed:(((s&0xFF0000) >> 16))/255.0 green:(((s&0x00FF00) >> 8))/255.0 blue:(s&0x0000FF)/255.0 alpha:1.0]
#define UIColorFromHexA(s, a)  [UIColor colorWithRed:(((s&0xFF0000) >> 16))/255.0 green:(((s&0x00FF00) >> 8))/255.0 blue:(s&0x0000FF)/255.0 alpha:a]

#endif /* ZJOtherDefines_h */
