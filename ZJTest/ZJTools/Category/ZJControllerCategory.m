//
//  ZJControllerCategory.m
//  ButlerSugar
//
//  Created by ZJ on 3/4/16.
//  Copyright © 2016 csj. All rights reserved.
//

#import "ZJControllerCategory.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ZJDefine.h"

@implementation ZJControllerCategory

@end

@implementation UINavigationController (ZJNavigationController)

- (void)pushViewControllerFromBottom:(UIViewController *)viewController {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.35;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.view.layer addAnimation:transition forKey:kCATransition];
    [self pushViewController:viewController animated:NO];
}

- (void)popViewControllerFromDirection:(TransitionDerection)direction {
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionReveal;
    NSArray *types = @[kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom];
    transition.subtype = types[direction];
    transition.duration = 0.35;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.view.layer addAnimation:transition forKey:kCATransition];
    [self popViewControllerAnimated:NO];
}

@end


#define  barItemAction @"barItemAction:"

@implementation UIViewController (ZJViewController)

#pragma mark - 系统分享

- (void)systemShareWithIcon:(NSString *)icon path:(NSString *)path {
    //分享的标题
    NSString *textToShare = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    //分享的图片
    UIImage *imageToShare = [UIImage imageNamed:icon];
    //分享的url
    NSURL *urlToShare = [NSURL URLWithString:path];
    //在这里呢 如果想分享图片 就把图片添加进去  文字什么的通上
    NSArray *activityItems = @[textToShare, imageToShare, urlToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    //不出现在活动项目
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityVC animated:YES completion:nil];
    // 分享之后的回调
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"completed");
            //分享 成功
        } else  {
            NSLog(@"cancled");
            //分享 取消
        }
        NSLog(@"activityError = %@", activityError);
    };
}

- (UIViewController *)preControllerWithIndex:(NSInteger)index {
    NSArray *ary = self.navigationController.viewControllers;
    return ary[ary.count - (index + 1)];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UIBarButtonItem

- (UIBarButtonItem *)barbuttonWithTitle:(NSString *)title {
    SEL s = NSSelectorFromString(barItemAction);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:s];
    
    return item;
}

- (UIBarButtonItem *)barButtonWithImageName:(NSString *)imgName {
    SEL s = NSSelectorFromString(barItemAction);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:s];
    
    return item;
}

- (UIBarButtonItem *)barbuttonWithSystemType:(UIBarButtonSystemItem)type {
    SEL s = NSSelectorFromString(barItemAction);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:type target:self action:s];
    
    return item;
}

- (NSArray *)barButtonWithImageNames:(NSArray *)imgNames {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < imgNames.count; i++) {
        UIBarButtonItem *item = [self barButtonWithImageName:imgNames[i]];
        item.tag = i;
        
        [array addObject:item];
    }
    
    return [array copy];
}

- (UIBarButtonItem *)barButtonItemWithCustomViewWithImageNames:(NSArray *)images {
    SEL sel = NSSelectorFromString(barItemAction);
    
    CGFloat width = 30;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width*images.count+DefaultMargin, width)];
    NSInteger count = images.count;
    if (count > 2) count = 2;
    for (int i = 0; i < count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.tag = i;
        btn.frame = CGRectMake(i*(view.frame.size.width-width), 0, width, width);
        [btn setImage:[[UIImage imageNamed:images[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    return item;
}

- (void)popToVCWithIndex:(NSInteger)index {
    NSArray *vcs = self.navigationController.viewControllers;
    [self.navigationController popToViewController:vcs[index] animated:YES];
}

- (void)popToVCWithName:(NSString *)name {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(name)]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}

#pragma mark - MentionView

#define MentionViewTag 9999
#define kSuperView self.view

- (void)showMentionViewWithImgName:(NSString *)name text:(NSString *)text animated:(BOOL)animated {
    [self showMentionViewWithImgName:name text:text animated:animated superView:nil];
}

- (void)showMentionViewWithImgName:(NSString *)name text:(NSString *)text animated:(BOOL)animated superView:(UIView *)superView {
    if (!superView) superView = kSuperView;
    
    if (![superView viewWithTag:MentionViewTag]) {
        [self createMentionViewWithSuperView:superView];
    }
    
    [self showWithSuperView:superView imgName:name text:text animated:animated];
}

- (void)hiddenMentionView:(BOOL)hidden animated:(BOOL)animated {
    [self hiddenMentionView:hidden animated:animated superView:nil];
}

- (void)hiddenMentionView:(BOOL)hidden animated:(BOOL)animated superView:(UIView *)superView {
    if (!superView) superView = kSuperView;
    UIView *view = [superView viewWithTag:MentionViewTag];
    if (view) {
        [self hiddenView:view hidden:hidden animated:animated];
    }
}

- (UIView *)mentionViewWithImgName:( NSString * _Nonnull )name text:(NSString *)text frame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    iv.center = CGPointMake(view.center.x, view.frame.size.height/2);
    iv.contentMode = UIViewContentModeScaleAspectFit;
    iv.image = [UIImage imageNamed:name];
    [view addSubview:iv];
    
    CGFloat bottom = iv.frame.origin.y + iv.frame.size.height;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, bottom+DefaultMargin, view.frame.size.width, 21)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    label.text = text;
    [view addSubview:label];
    
    return view;
}

/**
 *  private method
 */
- (void)createMentionViewWithSuperView:(UIView *)superView {
    UIView *view = [self mentionViewWithImgName:nil text:nil frame:superView.bounds];
    view.tag = MentionViewTag;
    view.alpha = 0.0;
    view.hidden = YES;
    view.backgroundColor = [UIColor whiteColor];
    [superView addSubview:view];
}

- (void)showWithSuperView:(UIView *)superView imgName:(NSString *)name text:(NSString *)text animated:(BOOL)animated {
    UIView *view = [superView viewWithTag:MentionViewTag];
    
    for (UIView *v in view.subviews) {
        if ([v isMemberOfClass:[UIImageView class]]) {
            ((UIImageView *)v).image = [UIImage imageNamed:name];
            
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            BOOL b1 = self.edgesForExtendedLayout == UIRectEdgeAll || self.edgesForExtendedLayout == UIRectEdgeTop;
            BOOL b2 = [window isEqual:superView];
            if (!b1 && !b2) {
                v.center = CGPointMake(v.center.x, v.center.y-64);
            }
        }
        if ([v isMemberOfClass:[UILabel class]]) {
            ((UILabel *)v).text = text;
        }
    }
    if (view) {
        [self hiddenView:view hidden:NO animated:animated];
    }
}

- (void)hiddenView:(UIView *)view hidden:(BOOL)hidden animated:(BOOL)animated {
    if (hidden) {
        if (view.isHidden == NO) {
            if (animated) {
                [UIView animateWithDuration:DefaultAnimationDuration animations:^{
                    view.alpha = 0.0;
                } completion:^(BOOL finished) {
                    view.hidden = hidden;
                }];
            }else {
                view.alpha = 0.0;
                view.hidden = hidden;
            }
        }
    }else {
        if (view.isHidden) {
            view.hidden = hidden;
            if (animated) {
                [UIView animateWithDuration:DefaultAnimationDuration animations:^{
                    view.alpha = 1.0;
                }];
            }else {
                view.alpha = 1.0;
            }
        }
    }
}

#pragma mark - alert

- (void)alertWithTitle:(NSString *)title delegate:(id<UIAlertViewDelegate>)delegate {
    [self alertWithTitle:title tag:0 delegate:delegate];
}

- (void)alertWithTitle:(NSString *)title msg:(NSString *)msg delegate:(id<UIAlertViewDelegate>)delegate {
    [self alertWithTitle:title tag:0 msg:msg delegate:delegate];
}

- (void)alertWithTitle:(NSString *)title tag:(NSInteger)tag delegate:(id<UIAlertViewDelegate>)delegate {
    [self alertWithTitle:title tag:tag msg:nil delegate:delegate];
}

- (void)alertWithTitle:(NSString *)title tag:(NSInteger)tag msg:(NSString *)msg delegate:(id<UIAlertViewDelegate>)delegate {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = tag;
    [alert show];
}

// input
- (void)alertWithAlertObject:(ZJAlertObject *)object {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:object.title message:object.msg delegate:object.delegate cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = object.alertViewStyle;
    alert.tag = object.tag;
    
    if (alert.alertViewStyle != UIAlertViewStyleDefault) {
        UITextField *tf = [alert textFieldAtIndex:0];
        tf.textAlignment = NSTextAlignmentCenter;
        tf.placeholder = [NSString stringWithFormat:@"请输入%@", object.title];
        tf.keyboardType = object.keyboardType;
        tf.text = object.value;
    }
    
    [alert show];
}

#pragma mark - NSNotificationCenter

- (void)removeNotificationObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
