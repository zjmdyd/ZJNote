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

typedef NS_ENUM(NSInteger, TransitionDerection) {
    TransitionDerectionOfRght,
    TransitionDerectionOfLeft,
    TransitionDerectionOfTop,
    TransitionDerectionOfBottom,
};

@interface UINavigationController (ZJNavigationController)

- (void)pushViewControllerFromBottom:(UIViewController *)viewController;
- (void)popViewControllerFromDirection:(TransitionDerection)direction;

@end

#pragma mark - UIViewController

@interface UIViewController (ZJViewController)

#pragma mark - 系统分享

- (void)systemShareWithIcon:(NSString *)icon path:(NSString *)path;

- (UIViewController *)preControllerWithIndex:(NSInteger)index;

#pragma mark - UIBarButtonItem

- (UIBarButtonItem *)barbuttonWithTitle:(NSString *)title;
- (UIBarButtonItem *)barButtonWithImageName:(NSString *)imgName;
- (UIBarButtonItem *)barbuttonWithSystemType:(UIBarButtonSystemItem)type;

/**
 *  创建多个UIBarButtonItem(系统默认)此方法效果不好,建议使用barbuttonWithCustomViewWithImageNames:
 */
- (NSArray *)barButtonWithImageNames:(NSArray *)imgNames;

/**
 *  自定义UIBarButtonItem
 *
 *  @param images 数组元素个数最多为2
 */
- (UIBarButtonItem *)barButtonItemWithCustomViewWithImageNames:(NSArray *)images;
- (void)popToVCWithIndex:(NSInteger)index;
- (void)popToVCWithName:(NSString *)name;

#pragma mark - MentionView

/**
 *  在self.view上显示包含一张图片和文字的view
 *
 */
- (void)showMentionViewWithImgName:(NSString *)name text:(NSString *)text animated:(BOOL)animated;

/**
 *  在指定view上显示包含一张图片和文字的view
 */
- (void)showMentionViewWithImgName:(NSString *)name text:(NSString *)text animated:(BOOL)animated superView:(UIView *)superView;

- (void)hiddenMentionView:(BOOL)hidden animated:(BOOL)animated;
- (void)hiddenMentionView:(BOOL)hidden animated:(BOOL)animated superView:(UIView *)superView;

- (UIView *)mentionViewWithImgName:(NSString *)name text:(NSString *)text frame:(CGRect)frame;

#pragma mark - alert

- (void)alertWithAlertObject:(ZJAlertObject *)object;
- (void)alertWithTitle:(NSString *)title tag:(NSInteger)tag delegate:(id<UIAlertViewDelegate>)delegate;

- (void)alertWithTitle:(NSString *)title msg:(NSString *)msg delegate:(id<UIAlertViewDelegate>)delegate;
- (void)alertWithTitle:(NSString *)title tag:(NSInteger)tag msg:(NSString *)msg delegate:(id<UIAlertViewDelegate>)delegate;

#pragma mark - NSNotificationCenter

- (void)removeNotificationObserver;

@end
