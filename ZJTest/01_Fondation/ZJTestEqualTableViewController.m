//
//  ZJTestEqualTableViewController.m
//  ZJTest
//
//  Created by ZJ on 2019/5/6.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJTestEqualTableViewController.h"

@interface ZJTestEqualTableViewController ()

@end

@implementation ZJTestEqualTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
    [self initSettiing];
}

- (void)initAry {
    
}

- (void)initSettiing {
    NSArray *ary = @[@(YES), @(YES), @(YES)];
    NSLog(@"ary = %@", ary);
    for (id obj in ary) {
        NSLog(@"%@, %p, %p", obj, obj, &obj);
    }
    [NSMutableArray arrayWithObjects:<#(id  _Nonnull const __unsafe_unretained * _Nonnull)#> count:<#(NSUInteger)#>];
}

- (void)test1 {
    // 1.0
    /*
     2019-05-06 16:34:34.617214+0800 ZJTest[1733:115655] str1的地址:0x87d6e993d623b117, str2的地址:0x87d6e993d623b117
     2019-05-06 16:34:34.617319+0800 ZJTest[1733:115655] == 1
     2019-05-06 16:34:34.617398+0800 ZJTest[1733:115655] isEqual--1
     2019-05-06 16:34:34.617453+0800 ZJTest[1733:115655] isEqualToString--1
     */
    NSString *str1 = [NSString stringWithFormat:@"icon_01"];
    NSString *str2 = [NSString stringWithFormat:@"icon_01"];
    NSLog(@"str1的地址:%p, str2的地址:%p", str1, str2);
    NSLog(@"== %d", str1 == str2);
    NSLog(@"isEqual--%d", [str1 isEqual:str2]);
    NSLog(@"isEqualToString--%d", [str1 isEqualToString:str2]);
    
    // 2.0
    /*
     2019-05-06 16:34:34.618033+0800 ZJTest[1733:115655] image1的地址:0x282c2bdb0, image2的地址:0x282c2bdb0
     2019-05-06 16:34:34.618088+0800 ZJTest[1733:115655] == 1
     2019-05-06 16:34:34.618176+0800 ZJTest[1733:115655] isEqual--1
     */
    UIImage *image1 = [UIImage imageNamed:str1];
    UIImage *image2 = [UIImage imageNamed:str2];
    NSLog(@"image1的地址:%p, image2的地址:%p", image1, image2);
    NSLog(@"== %d", image1 == image2);
    NSLog(@"isEqual--%d", [image1 isEqual:image2]);
    
    // 3.0
    /*
     2019-05-06 16:34:34.618531+0800 ZJTest[1733:115655] imageView1地址:0x10dd2f720, imageView2地址:0x10dd127d0
     2019-05-06 16:34:34.618583+0800 ZJTest[1733:115655] == 0
     2019-05-06 16:34:34.618633+0800 ZJTest[1733:115655] isEqual--0
     */
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:image1];
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:image2];
    NSLog(@"imageView1地址:%p, imageView2地址:%p", imageView1,imageView2);
    NSLog(@"== %d", imageView1 == imageView2);
    NSLog(@"isEqual--%d", [imageView1 isEqual:imageView2]);
}

/*
 2019-05-06 17:29:03.296967+0800 ZJTest[1755:124237] 地址-->str1:0x102c714a0, str2:0xbf45d9eb8670ab2d
 2019-05-06 17:29:03.297159+0800 ZJTest[1755:124237] ==:0
 2019-05-06 17:29:03.297273+0800 ZJTest[1755:124237] isEqual:1
 2019-05-06 17:29:03.297374+0800 ZJTest[1755:124237] isEqualToString:1
 */
- (void)test2 {
    NSString *str1 = @"aa";
    NSString *str2 = [NSString stringWithFormat:@"aa"];
    NSMutableString *str3 = [NSMutableString stringWithFormat:@"aa"];

    NSLog(@"地址-->str1:%p, str2:%p", str1, str2);
    NSLog(@"==:%d", str1 == str2);
    NSLog(@"isEqual:%d", [str1 isEqual:str2]);
    NSLog(@"isEqualToString:%d", [str1 isEqualToString:str2]);
    
    NSLog(@"Mutable isEqual:%d", [str1 isEqual:str3]);
    NSLog(@"Mutable isEqualToString:%d", [str1 isEqualToString:str3]);
}

- (void)test3 {
    NSArray *ary = @[@"aa", @"bb"];
    NSString *str = [NSString stringWithFormat:@"aa"];
    NSLog(@"containsObject = %d", [ary containsObject:str]);
}

- (void)test4 {
    NSArray *ary = @[@"aa", @"bb"];
    NSString *str = @"aa";
    NSLog(@"containsObject = %d", [ary containsObject:str]);
}

/*
 "==" ，是判断两个对象的引用（reference）是否一样，也就是内存地址是否一样。
 isEqual ，判断是一个类方法，判断连个对象在类型和值上是否一样。
 */

/*
 苹果官方重写isEqual方法
 - (BOOL)isEqual:(id)other {
     if (other == self)
        return YES;
     if (!other || ![other isKindOfClass:[self class]])
        return NO;
     return [self isEqualToWidget:other];
}
 
 - (BOOL)isEqualToWidget:(MyWidget *)aWidget {
     if (self == aWidget)
        return YES;
     if (![(id)[self name] isEqual:[aWidget name]])
        return NO;
     if (![[self data] isEqualToData:[aWidget data]])
        return NO;
     return YES;
 }
 */

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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
