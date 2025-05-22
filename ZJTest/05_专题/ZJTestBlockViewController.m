//
//  ZJTestBlockViewController.m
//  ZJTest
//
//  Created by Zengjian on 2019/9/5.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJTestBlockViewController.h"
#import "ZJPerson.h"

typedef void(^XBTBlock)(void);

@interface ZJTestBlockViewController ()

@property (nonatomic, strong) XBTBlock block;

@end

XBTBlock tempBlock;

@implementation ZJTestBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self test1];
//    [self test3];
    [self test4];
}

- (void)test1 {
    auto int age = 10;
    static int num = 25;
    void (^Block)(void) = ^{
        NSLog(@"age:%d, num:%d",age, num);
    };
    age = 20;
    num = 11;
    Block();    // age:10, num:11
}

- (void)test2 {
    XBTBlock block; // 无泄漏
    {
        ZJPerson *p = [ZJPerson new];
        p.age = 20;
        block = ^{
            NSLog(@"====p.age = %ld", (long)p.age);
        };
        block();
    }
}

- (void)test3 { // 无泄漏
    ZJPerson *p = [ZJPerson new];
    p.age = 20;
    self.block = ^{
        NSLog(@"====p.age = %ld", (long)p.age);
    };
    self.block();
}

//栈空间上的block，不会持有对象；堆空间的block，会持有对象。
- (void)test4 { // 有泄漏
    ZJPerson *p = [ZJPerson new];
    p.age = 20;
    tempBlock = ^{
        NSLog(@"====p.age = %ld", (long)p.age);
    };
    tempBlock();
    tempBlock = nil;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

/*
 int age = 1;
 void (^block1)(void) = ^{
 NSLog(@"block1");
 };
 
 void (^block2)(void) = ^{
 NSLog(@"block2:%d",age);
 };
 
 NSLog(@"%@/%@/%@",[block1 class],[block2 class],[^{
 NSLog(@"block3:%d",age);
 } class]);
 
 __NSGlobalBlock __/__NSMallocBlock __/__NSStackBlock __
 
 __NSGlobalBlock __ 在数据区
 __NSMallocBlock __ 在堆区
 __NSStackBlock __ 在栈区
 堆：动态分配内存，需要程序员自己申请，程序员自己管理
 栈：自动分配内存，自动销毁，先入后出，栈上的内容存在自动销毁的情况
 
 没有访问auto变量的block是__NSGlobalBlock __ ，放在数据段
 访问了auto变量的block是__NSStackBlock __
 [__NSStackBlock __ copy]操作就变成了__NSMallocBlock
 
 __NSGlobalBlock __ 调用copy操作后，什么也不做
 __NSStackBlock __ 调用copy操作后，复制效果是：从栈复制到堆；副本存储位置是堆
 __NSStackBlock __ 调用copy操作后，复制效果是：引用计数增加；副本存储位置是堆
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
