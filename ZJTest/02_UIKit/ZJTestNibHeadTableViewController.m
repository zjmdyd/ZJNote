//
//  ZJTestNibHeadTableViewController.m
//  ZJTest
//
//  Created by ZJ on 2019/4/13.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJTestNibHeadTableViewController.h"

@interface ZJTestNibHeadTableViewController ()

@end

@implementation ZJTestNibHeadTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%s", __func__);
    NSLog(@"frame = %@", NSStringFromCGRect(self.tableView.frame));
    [self initAry];
    [self initSettiing];
}

- (void)initAry {
    
}

- (void)initSettiing {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZJNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SystemTableViewCell];
    if (!cell) {
        cell = [[ZJNormalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SystemTableViewCell];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"row:%ld", (long)indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

/**
 在viewWillAppear加载tableView头视图(nib创建的)不会引起设置frame的大小不对
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    ZJAboutView *view = (ZJAboutView *)[self createNibName:@"ZJAboutView" frame:CGRectMake(0, 0, kScreenW, kScreenW)];
    view.icon = @"icon_04";
    view.backgroundColor = [UIColor orangeColor];
    self.tableView.tableHeaderView = view;
}

- (UIView *)createNibName:(NSString *)name frame:(CGRect)frame {
    ZJAboutView *view = [[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil].firstObject;
    view.frame = frame;
    return view;
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
