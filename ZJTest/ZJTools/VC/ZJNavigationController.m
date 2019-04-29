//
//  ZJNavigationController.m
//  SportWatch
//
//  Created by ZJ on 2/24/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJNavigationController.h"

@interface ZJNavigationController ()

@end

@implementation UIImage(NaviColor)

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self createImageWithColor:color frame:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
}

+ (UIImage *)imageWithColor:(UIColor *)color frame:(CGRect)frame {
    return [self createImageWithColor:color frame:frame];
}

+ (UIImage *)createImageWithColor:(UIColor *)color frame:(CGRect)frame {
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, frame);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

@implementation ZJNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.hidesBottomBarWhenPushed = YES;
    self.hiddenBackBarButtonItemTitle = YES;
    self.delegate = self;
}

- (void)setNavigationBarBgColor:(UIColor *)navigationBarBgColor {
    _navigationBarBgColor = navigationBarBgColor;
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:_navigationBarBgColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}

- (void)setNavigationBarTranslucent:(BOOL)navigationBarTranslucent {
    _navigationBarTranslucent = navigationBarTranslucent;
    
    self.navigationBar.translucent = _navigationBarTranslucent;
}

- (void)setHiddenShadowLine:(BOOL)hiddenShadowLine {
    _hiddenShadowLine = hiddenShadowLine;
    
    self.navigationBar.shadowImage = [UIImage new];
}

- (void)setNavigationBarShadowColor:(UIColor *)navigationBarShadowColor {
    _navigationBarShadowColor = navigationBarShadowColor;
    self.navigationBar.shadowImage = [UIImage imageWithColor:_navigationBarShadowColor];     // 分割线颜色
}

- (void)setNavigationBarTintColor:(UIColor *)navigationBarTintColor {
    _navigationBarTintColor = navigationBarTintColor;
    self.navigationBar.tintColor = _navigationBarTintColor;    // 对返回按钮颜色起作用
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:_navigationBarTintColor}];
}

- (void)setNavigationBarBgImage:(UIImage *)navigationBarBgImage {
    _navigationBarBgImage = navigationBarBgImage;
    
    [self.navigationBar setBackgroundImage:_navigationBarBgImage forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.hidesBottomBarWhenPushed) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

/**
 *  调用顺序:viewDidLoad-->viewWillAppear-->此方法-->viewDidAppear
 */
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.needChangeExtendedLayout) {
        if([viewController respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            viewController.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }else {
        if([viewController respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            viewController.edgesForExtendedLayout = UIRectEdgeAll;
        }
    }
    if (!self.hiddenBackBarButtonItemTitle) return;
    
    NSArray *viewControllerArray = self.viewControllers;
    
    long previousViewControllerIndex = [viewControllerArray indexOfObject:viewController] - 1;
    UIViewController *previous;
    
    if (previousViewControllerIndex >= 0) {
        previous = [viewControllerArray objectAtIndex:previousViewControllerIndex];
        previous.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                     initWithTitle:@""
                                                     style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:nil];
    }
}

@end
