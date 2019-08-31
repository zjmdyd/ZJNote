//
//  ZJControllerCategory.h
//  ButlerSugar
//
//  Created by ZJ on 3/4/16.
//  Copyright © 2016 csj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZJAlertObject.h"

@interface ZJControllerCategory : NSObject

@end

#pragma mark - UINavigationController

@interface UINavigationController (ZJNavigationController)

- (void)pushViewController:(UIViewController *)viewController direction:(CATransitionSubtype)direction;
- (void)popViewControllerFromDirection:(CATransitionSubtype)direction;

@end

#pragma mark - UIViewController

@interface UIViewController (ZJViewController)

- (UIViewController *)preControllerWithIndex:(NSInteger)index;
- (void)popToVCWithIndex:(NSInteger)index;
- (void)popToVCWithName:(NSString *)name;

#pragma mark - UIBarButtonItem

- (UIBarButtonItem *)barbuttonWithSystemType:(UIBarButtonSystemItem)type;
- (UIBarButtonItem *)barbuttonWithTitle:(NSString *)title;
- (UIBarButtonItem *)barButtonWithImageName:(NSString *)imgName;

/**
 *  创建多个UIBarButtonItem(系统默认)此方法效果不好,建议使用barbuttonWithCustomViewWithImageNames:
 */
- (NSArray *)barButtonWithImageNames:(NSArray *)imgNames;

/**
 *  自定义UIBarButtonItem
 *
 *  @param images 数组最多支持2张图片
 */
- (UIBarButtonItem *)barButtonItemWithCustomViewWithImageNames:(NSArray *)images;

#pragma mark - alert

- (void)alertWithAlertObject:(ZJAlertObject *)object;
- (void)alertSheetWithWithAlertObject:(ZJAlertObject *)object;

#pragma mark - 系统分享

- (void)systemShareWithIcon:(NSString *)icon path:(NSString *)path;

#pragma mark - NSNotificationCenter

- (void)removeNotificationObserver;

@end
