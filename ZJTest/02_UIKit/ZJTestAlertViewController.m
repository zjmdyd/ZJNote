//
//  ZJTestAlertViewController.m
//  ZJTest
//
//  Created by ZJ on 2019/4/12.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJTestAlertViewController.h"

@interface ZJTestAlertViewController ()

@end

@implementation ZJTestAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    ZJAlertObject *obj = [ZJAlertObject new];
    obj.title = @"呵呵";
    [self alertWithAlertObject:obj];
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
