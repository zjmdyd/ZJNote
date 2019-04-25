//
//  ZJTestBarButtonItemViewController.m
//  ZJTest
//
//  Created by ZJ on 2019/4/17.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJTestBarButtonItemViewController.h"

@interface ZJTestBarButtonItemViewController ()

@end

@implementation ZJTestBarButtonItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZJIconBadgeButton *btn = [ZJIconBadgeButton buttonWithFrame:CGRectMake(0, 0, 25, 25) target:self];
    [btn setImage:[UIImage imageNamed:@"ic_xiaoxi"] forState:UIControlStateNormal];
    [btn setBadgeTitle:@"100" badgeBgColor:[UIColor redColor]];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barbuttonWithCustomView:btn];
    
//    self.navigationItem.rightBarButtonItems = [self barButtonWithImageNames:@[@"ic_xiaoxi", @"ic_setting"]];
//    self.navigationItem.rightBarButtonItem = [self barButtonItemWithCustomViewWithImageNames:@[@"ic_xiaoxi", @"ic_setting"]];
}

- (void)badgeBtnEvent:(ZJIconBadgeButton *)sender {
    NSLog(@"%s", __func__);
    sender.hidesBadge = !sender.hidesBadge;
}

- (void)barItemAction:(UIBarButtonItem *)sender {
    NSLog(@"tag = %ld, sender = %@", (long)sender.tag, sender);
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
