//
//  ZJTestImageViewController.m
//  ZJTest
//
//  Created by ZJ on 2019/4/17.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJTestImageViewController.h"

@interface ZJTestImageViewController ()

@end

@implementation ZJTestImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(16, 100, 350, 350)];
    iv.image = [UIImage qrImageWithContent:@"hahaha" size:100 red:255 green:255 blue:0];
    [iv setBorderWidth:1 color:[UIColor blackColor]];
    [self.view addSubview:iv];
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
