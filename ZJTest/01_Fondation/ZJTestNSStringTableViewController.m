//
//  ZJTestNSStringTableViewController.m
//  ZJTest
//
//  Created by ZJ on 2019/4/27.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJTestNSStringTableViewController.h"

@interface ZJTestNSStringTableViewController ()

@property (nonatomic, strong) NSString *strongString;
@property (nonatomic, copy) NSString *copyedString;

@end

@implementation ZJTestNSStringTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
    [self initSettiing];
}

- (void)initAry {
    
}

- (void)initSettiing {
    NSLog(@"%@", [@"abcd" invertString]);
    NSLog(@"%@", [@"哈哈" pinYin]);
}

#pragma mark - strong / copy

/*
 2019-04-27 14:37:55.520864+0800 ZJTest[1782:655539] origin string: 0xfe25a1f0325aaa43, 0x16f406208
 2019-04-27 14:37:55.521013+0800 ZJTest[1782:655539] strong string: 0xfe25a1f0325aaa43, 0x10201f608
 2019-04-27 14:37:55.521071+0800 ZJTest[1782:655539] copy   string: 0xfe25a1f0325aaa43, 0x10201f610
 */
- (void)test1 {
    NSString *string = [NSString stringWithFormat:@"abc"];
    self.strongString = string;
    self.copyedString = string;
    NSLog(@"origin string: %p, %p", string, &string);
    NSLog(@"strong string: %p, %p", _strongString, &_strongString);
    NSLog(@"copy string: %p, %p", _copyedString, &_copyedString);
}

/*
 2019-04-27 14:41:22.889511+0800 ZJTest[1785:656037] origin string: 0x2839e90e0, 0x16fbae208
 2019-04-27 14:41:22.889717+0800 ZJTest[1785:656037] strong string: 0x2839e90e0, 0x10101d208
 2019-04-27 14:41:22.889809+0800 ZJTest[1785:656037] copy   string: 0x93083224729dfcb3, 0x10101d210
 */
- (void)test2 {
    NSMutableString *string = [NSMutableString stringWithFormat:@"abc"];
    self.strongString = string;
    self.copyedString = string;
    NSLog(@"origin string: %p, %p", string, &string);
    NSLog(@"strong string: %p, %p", _strongString, &_strongString);
    NSLog(@"copy string: %p, %p", _copyedString, &_copyedString);
}
/*
 当源字符串是NSString时，由于字符串是不可变的，所以，不管是strong还是copy属性的对象，都是指向源对象，copy操作只是做了次浅拷贝
 当源字符串是NSMutableString时，strong属性只是增加了源字符串的引用计数，
 而copy属性则是对源字符串做了次深拷贝，产生一个新的对象，且copy属性对象指向这个新的对象
 
 所以，在声明NSString属性时，到底是选择strong还是copy，可以根据实际情况来定。
 不过，一般我们将对象声明为NSString时，都不希望它改变，所以大多数情况下，我们建议用copy，以免因可变字符串的修改导致的一些非预期问题。
 另外需要注意的是，这个copy属性对象的类型始终是NSString，而不是NSMutableString，因此其是不可变的
 */

#pragma mark - 字面量 copy / mutableCopy

/*
 2019-04-27 15:00:33.219326+0800 ZJTest[1804:659749] str0: 0x10138df50, 0x16eaae208
 2019-04-27 15:00:33.219506+0800 ZJTest[1804:659749] str1: 0x10138df50, 0x16eaae200
 2019-04-27 15:00:33.219564+0800 ZJTest[1804:659749] str2: 0x2815ece70, 0x16eaae1f8
 */
- (void)test3 {
    NSString *str0 = @"abc";
    NSString *str1 = [str0 copy];        // 做了一次浅拷贝
    NSString *str2 = [str0 mutableCopy]; // 做了一次深拷贝
    NSLog(@"str0: %p, %p", str0, &str0);
    NSLog(@"str1: %p, %p", str1, &str1);
    NSLog(@"str2: %p, %p", str2, &str2);
    NSLog(@"\n\n");
    
    str0 = @"abcdef";
    /*
     2019-04-27 15:00:33.219811+0800 ZJTest[1804:659749] str0: 0x10138e050, 0x16eaae208
     2019-04-27 15:00:33.219860+0800 ZJTest[1804:659749] str1: 0x10138df50, 0x16eaae200
     2019-04-27 15:00:33.219908+0800 ZJTest[1804:659749] str2: 0x2815ece70, 0x16eaae1f8
     */
    NSLog(@"str0 = %@", str0);
    NSLog(@"str1 = %@", str1);  // 这个copy属性对象的类型始终是NSString，而不是NSMutableString，因此其是不可变的
    NSLog(@"str2 = %@", str2);
    NSLog(@"str0: %p, %p", str0, &str0);
    NSLog(@"str1: %p, %p", str1, &str1);
    NSLog(@"str2: %p, %p", str2, &str2);
}

#pragma mark - NSString copy / mutableCopy

/*
 2019-04-27 15:08:43.025720+0800 ZJTest[1815:661502] str0: 0x8890c8cebd401d4c, 0x16faf2208
 2019-04-27 15:08:43.025933+0800 ZJTest[1815:661502] str1: 0x8890c8cebd401d4c, 0x16faf2200
 2019-04-27 15:08:43.026030+0800 ZJTest[1815:661502] str2: 0x283578bd0, 0x16faf21f8
 */
- (void)test4 {
    NSString *str0 = [NSString stringWithFormat:@"abc"];
    NSString *str1 = [str0 copy];        // 做了一次浅拷贝
    NSString *str2 = [str0 mutableCopy]; // 做了一次深拷贝
    NSLog(@"str0: %p, %p", str0, &str0);
    NSLog(@"str1: %p, %p", str1, &str1);
    NSLog(@"str2: %p, %p", str2, &str2);
    NSLog(@"\n\n");
    
    str0 = [NSString stringWithFormat:@"abcdef"];
    /*
     2019-04-27 15:08:43.027084+0800 ZJTest[1815:661502] str0: 0x8896ae98fd401d49, 0x16faf2208
     2019-04-27 15:08:43.027158+0800 ZJTest[1815:661502] str1: 0x8890c8cebd401d4c, 0x16faf2200
     2019-04-27 15:08:43.027231+0800 ZJTest[1815:661502] str2: 0x283578bd0, 0x16faf21f8
     */
    NSLog(@"str0 = %@", str0);
    NSLog(@"str1 = %@", str1);  // 这个copy属性对象的类型始终是NSString，而不是NSMutableString，因此其是不可变的
    NSLog(@"str2 = %@", str2);
    NSLog(@"str0: %p, %p", str0, &str0);
    NSLog(@"str1: %p, %p", str1, &str1);
    NSLog(@"str2: %p, %p", str2, &str2);
}

#pragma mark - NSMutableString copy / mutableCopy

/*
 2019-04-27 15:13:35.948228+0800 ZJTest[1818:662217] str0: 0x2832ef030, 0x16f38e208
 2019-04-27 15:13:35.948436+0800 ZJTest[1818:662217] str1: 0xde7089103de8bcc5, 0x16f38e200
 2019-04-27 15:13:35.948527+0800 ZJTest[1818:662217] str2: 0x2832ef060, 0x16f38e1f8
 */
- (void)test5 {
    NSMutableString *str0 = [NSMutableString stringWithFormat:@"abc"];
    NSMutableString *str1 = [str0 copy];        // 做了一次深拷贝
    NSMutableString *str2 = [str0 mutableCopy]; // 做了一次深拷贝
    NSLog(@"str0: %p, %p", str0, &str0);
    NSLog(@"str1: %p, %p", str1, &str1);
    NSLog(@"str2: %p, %p", str2, &str2);
    NSLog(@"\n\n");
    
    str0 = [NSMutableString stringWithFormat:@"abcdef"];
    /*
     2019-04-27 15:13:35.949421+0800 ZJTest[1818:662217] str0: 0x2832ef090, 0x16f38e208
     2019-04-27 15:13:35.949516+0800 ZJTest[1818:662217] str1: 0xde7089103de8bcc5, 0x16f38e200
     2019-04-27 15:13:35.949591+0800 ZJTest[1818:662217] str2: 0x2832ef060, 0x16f38e1f8
     */
    NSLog(@"str0 = %@", str0);
    NSLog(@"str1 = %@", str1);  // 这个copy属性对象的类型始终是NSString，而不是NSMutableString，因此其是不可变的
    NSLog(@"str2 = %@", str2);
    NSLog(@"str0: %p, %p", str0, &str0);
    NSLog(@"str1: %p, %p", str1, &str1);
    NSLog(@"str2: %p, %p", str2, &str2);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZJNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SystemTableViewCell];
    if (!cell) {
        cell = [[ZJNormalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SystemTableViewCell];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"test%ld", (long)indexPath.row + 1];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSelector:NSSelectorFromString(cell.textLabel.text) withObject:nil];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
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
