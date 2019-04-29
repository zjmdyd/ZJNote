//
//  ZJTestNSScannerViewController.m
//  ZJTest
//
//  Created by ZJ on 2019/4/27.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJTestNSScannerViewController.h"

@interface ZJTestNSScannerViewController ()

@end

@implementation ZJTestNSScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%d", [@"3.14a" isPureFloat]);   // NO
    NSLog(@"%d", [@"3.14" isPureFloat]);    // YES
    
    NSString *apple = @"132 fushi pingguo of apple";
    // scanner在任何操作时会跳过空白字符之后才开始
    NSScanner *aScanner = [NSScanner scannerWithString:apple];
    
    NSInteger anInteger;
    //得到数量132
    [aScanner scanInteger:&anInteger];
    NSLog(@"%ld", (long)anInteger);
    
    // 在扫描完一个整数之后，scanner的位置将变成3
    NSString *separateString = @" of";
    NSString *name;
    
    //得到名称fushi pingguo
    [aScanner scanUpToString:separateString intoString:&name];

    NSLog(@"name = %@", name);
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
