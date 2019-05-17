//
//  ZJTestNSDataViewController.m
//  ZJTest
//
//  Created by ZJ on 2019/4/27.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJTestNSDataViewController.h"

@interface ZJTestNSDataViewController ()

@end

@implementation ZJTestNSDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    Byte bytes[] = {0xff, 0x20, 0x22, 0x30};
    Byte bytes[] = {0x10, 0x20, 0x30, 0x40, 0x50, 0x60};

    uint8_t len = sizeof(bytes)/sizeof(Byte);
    NSData *data = [NSData dataWithBytes:bytes length:len];
    NSLog(@"len = %ld", (long)len);
    NSLog(@"data = %@", data);
    
    Byte notBytes[len];
    [NSData bitwiseNot:bytes desBytes:notBytes len:len];
    NSData *notData = [NSData dataWithBytes:notBytes length:len];
    NSLog(@"notData = %@", notData);
    NSLog(@"backdata = %@", [data bitwiseNot]);
    NSLog(@"value = %d", [data valueWithRange:NSMakeRange(2, 1)]);
    
    NSLog(@"str = %@", [data dataToHexString]);
    NSLog(@"data = %@", [NSData dataWithHexString:@"f01020a030"]);
    
    NSLog(@"\n\n");
    
    Byte tt[4];
    [NSData valueToBytes:tt value:12345];
    NSLog(@"data = %@", [NSData dataWithBytes:tt length:4]);
    
}

/*
 8位有符号数:-128
 (-1) + (-127) = [1000 0001]原 + [1111 1111]原 = [1111 1111]补 + [1000 0001]补 = [1000 0000]补
 */
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
