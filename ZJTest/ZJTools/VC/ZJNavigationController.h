//
//  ZJNavigationController.h
//  SportWatch
//
//  Created by ZJ on 2/24/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJNavigationController : UINavigationController <UINavigationControllerDelegate>

/**
 *  导航栏是否半透明效果，默认为YES
 */
@property (nonatomic, assign) BOOL navigationBarTranslucent;

/**
 *  push VC时是否默认隐藏tabBar, 默认为YES
 */
@property (nonatomic, assign) BOOL hiddenShadowLine;
@property (nonatomic, assign) BOOL hiddenBackBarButtonItemTitle;    // 默认为YES
@property (nonatomic, assign) BOOL needChangeExtendedLayout;        // 默认为UIRectEdgeAll

@property (nonatomic, strong) UIColor *navigationBarBgColor;
@property (nonatomic, strong) UIColor *navigationBarTintColor;
@property (nonatomic, strong) UIColor *navigationBarShadowColor;

@property (nonatomic, strong) UIImage *navigationBarBgImage;

@end
