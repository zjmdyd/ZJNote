//
//  ZJMainTabBarViewController.m
//  ZJTest
//
//  Created by ZJ on 2019/3/26.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJMainTabBarViewController.h"

@interface ZJMainTabBarViewController ()

@end

@implementation ZJMainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSetting];
}

- (void)initSetting {
    NSArray *titles = @[@"Fondation", @"UIKit", @"System", @"CAAnimation", @"专题"];
    NSArray *image = @[@"1", @"2", @"3", @"3", @"3"];
    NSArray *selectImage = @[@"1-1", @"2-1", @"3-1", @"3-1", @"3-1"];
    NSArray *nibNames = @[@"ZJTestFodationTableViewController", @"ZJTestUIKitTableViewController", @"ZJTestSystemTableViewController", @"ZJTestCAAnimationTableViewController", @"ZJTestSubjectTableViewController"];
    
    NSMutableArray *ary = [NSMutableArray array];
    for (int i = 0; i < nibNames.count; i++) {
        UIViewController *vc = [self createVCWithName:nibNames[i] title:titles[i] isGroupTableVC:YES];
        ZJNavigationController *navi = [[ZJNavigationController alloc] initWithRootViewController:vc];
        navi.navigationBarTintColor = [UIColor whiteColor];
        navi.navigationBarBgColor = UIColorFromHex(0x154992);
        navi.navigationBarTranslucent = YES;
        navi.tabBarItem.image = [[UIImage imageNamed:image[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        navi.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [navi.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromHex(0x154992)} forState:UIControlStateSelected];
        [ary addObject:navi];
    }
    
    self.tabBar.translucent = NO;   // 防止tabBar返回首页时文字隐藏, 跟系统版本有关
    self.viewControllers = [ary copy];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
