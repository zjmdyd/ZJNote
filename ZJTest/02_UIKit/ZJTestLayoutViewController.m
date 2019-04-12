//
//  ZJTestLayoutViewController.m
//  ZJTest
//
//  Created by ZJ on 2019/4/12.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJTestLayoutViewController.h"

@interface ZJTestLayoutViewController ()

@end

@implementation ZJTestLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%s", __func__);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"%s", __func__);
}


/*
 viewDidLoad
 viewWillAppear
 myview updateConstraints //子视图updateContrains先调用
 updateViewConstraints
 viewWillLayoutSubviews
 viewDidLayoutSubviews
 layoutSubviews
 drawRect:
 viewDidAppear
 ---------------------
 作者：anjuncc
 来源：CSDN
 原文：https://blog.csdn.net/anjuncc/article/details/45558583
 版权声明：本文为博主原创文章，转载请附上博文链接！
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
