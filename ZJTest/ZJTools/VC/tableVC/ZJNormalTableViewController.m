//
//  ZJNormalTableViewController.m
//  ZJTest
//
//  Created by ZJ on 2019/3/21.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJNormalTableViewController.h"

@interface ZJNormalTableViewController ()

@end

@implementation ZJNormalTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSuperSetting];
}

- (void)initSuperSetting {
    self.tableView.showsVerticalScrollIndicator = NO;
}

- (void)setNeedChangeContentInsetAdjust:(BOOL)needChangeContentInsetAdjust {
    _needChangeContentInsetAdjust = needChangeContentInsetAdjust;
    
    if (@available(iOS 11.0, *)) {
        if (_needChangeContentInsetAdjust) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
    }else {
        self.automaticallyAdjustsScrollViewInsets = !_needChangeContentInsetAdjust;
    }
}

- (void)setNavigationBarClear:(BOOL)clear {
#ifdef ZJNaviCtrl
    ((ZJNavigationController *)self.navigationController).hiddenShadowLine = clear;
    if (clear) {
        ((ZJNavigationController *)self.navigationController).navigationBarBgColor = [UIColor clearColor];
    }else {
        ((ZJNavigationController *)self.navigationController).navigationBarBgColor = UIColorFromHex(0x154992);
    }
#endif
    self.needChangeContentInsetAdjust = clear;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DefaultCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return DefaultSectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return FLT_EPSILON;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

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
