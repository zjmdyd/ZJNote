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
    
    self.navigationItem.rightBarButtonItems = [self barButtonWithImageNames:@[@"ic_xiaoxi", @"ic_setting"]];
//    self.navigationItem.rightBarButtonItem = [self barButtonItemWithCustomViewWithImageNames:@[@"ic_xiaoxi", @"ic_setting"]];
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
