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

- (void)pushViewController:(UIViewController *)viewController direction:(CATransitionSubtype)direction {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.type = kCATransitionMoveIn;
    transition.subtype = direction;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.view.layer addAnimation:transition forKey:kCATransition];
    [self pushViewController:viewController animated:NO];
}

- (void)popViewControllerFromDirection:(CATransitionSubtype)direction {
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionReveal;
    transition.subtype = direction;
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.view.layer addAnimation:transition forKey:kCATransition];
    [self popViewControllerAnimated:NO];
}

@end

#define  barItemAction @"barItemAction:"

@implementation UIViewController (ZJViewController)

- (UIViewController *)preControllerWithIndex:(NSInteger)index {
    NSArray *ary = self.navigationController.viewControllers;
    return ary[ary.count - (index + 1)];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UIBarButtonItem

- (UIBarButtonItem *)barbuttonWithSystemType:(UIBarButtonSystemItem)type {
    SEL s = NSSelectorFromString(barItemAction);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:type target:self action:s];
    
    return item;
}

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
    
    CGFloat width = 35;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width*images.count+DefaultSpan, width)];
    NSInteger count = images.count;
    if (count > 2) count = 2;
    for (int i = 0; i < count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.tag = i;
        btn.frame = CGRectMake(view.width-(width*(i+1) + DefaultSpan*i), 0, width, width);
        [btn setImage:[[UIImage imageNamed:images[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    return item;
}

#pragma mark - alert
/* UIAlertController改标题颜色
 [[alert valueForKey:@"alertController"] setValue:[@"aa" attrWithForegroundColor:[UIColor redColor]] forKey:@"attributedTitle"];
 */
// input
- (void)alertWithAlertObject:(ZJAlertObject *)object {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:object.title message:object.msg delegate:object.delegate cancelButtonTitle:object.cancelTitle otherButtonTitles:object.otherTitle, nil];
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
