//
//  ZJTestSelectBtnViewController.m
//  ZJTest
//
//  Created by ZJ on 2019/4/11.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJTestSelectBtnViewController.h"

@interface ZJTestSelectBtnViewController ()

@end

@implementation ZJTestSelectBtnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    ZJSelectButton *btn = [[ZJSelectButton alloc] initWithFrame:CGRectMake(50, 150, 200, 200)];
    btn.backgroundColor = [UIColor greenColor];
//    btn.select = YES;
    btn.unSelectImgName = @"icon_02";
    btn.selectImgName = @"icon_03";
    [btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnEvent:(ZJSelectButton *)sender {
    NSLog(@"%s", __func__);
    sender.select = !sender.select;
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
