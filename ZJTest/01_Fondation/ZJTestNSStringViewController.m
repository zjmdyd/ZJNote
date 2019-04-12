//
//  ZJTestNSStringViewController.m
//  ZJTest
//
//  Created by ZJ on 2019/3/21.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJTestNSStringViewController.h"

@interface ZJTestNSStringViewController ()

@property (nonatomic, strong) NSString *strongString;
@property (nonatomic, copy) NSString *copyedString;

@end

@implementation ZJTestNSStringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test1];
    [self test2];
}

- (void)test1 {
    NSString *string = [NSString stringWithFormat:@"abc"];
    self.strongString = string;
    self.copyedString = string;
    NSLog(@"origin string: %p, %p", string, &string);
    NSLog(@"strong string: %p, %p", _strongString, &_strongString);
    NSLog(@"copy string: %p, %p", _copyedString, &_copyedString);
}

- (void)test2 {
    NSMutableString *string = [NSMutableString stringWithFormat:@"abc"];
    self.strongString = string;
    self.copyedString = string;
    NSLog(@"origin string: %p, %p", string, &string);
    NSLog(@"strong string: %p, %p", _strongString, &_strongString);
    NSLog(@"copy string: %p, %p", _copyedString, &_copyedString);
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
