//
//  ZJAudioToolboxTableViewController.m
//  ZJFoundation
//
//  Created by ZJ on 9/18/16.
//  Copyright © 2016 YunTu. All rights reserved.
//

#import "ZJAudioToolboxTableViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ZJNSObjectCategory.h"
#import "ZJViewHeaderFiles.h"

@interface ZJAudioToolboxTableViewController ()<UITableViewDataSource, UITableViewDelegate> {
    NSArray *_files, *_sectionTitles, *_cellTitles;
}

@end

NSString *TitleCell = @"cell";
NSString *kAudioPath1 = @"/System/Library/Audio/UISounds/";
NSString *kAudioPath2 = @"/System/Library/Sounds/";

@implementation ZJAudioToolboxTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
    [self initSettiing];
}

- (void)initAry {
    NSString *path = kIsAboveiOS11 ? kAudioPath2 : kAudioPath1;
    _files =  [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    _cellTitles = @[
                    @[@"Vibrate"],
                    @[@"alert_message"],
                    _files?:@"为空"
                    ];
    
    NSString *basePath = @"/System/Library/";
    NSArray *ary = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:basePath error:nil];
    for (NSString *str in ary) {
        NSLog(@"subFiles-->%@ = %@", str, [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSString stringWithFormat:@"/System/Library/%@", str] error:nil]);
    }
}

- (void)initSettiing {
    _sectionTitles = @[@"振动", @"用户音频", @"系统音频"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return _files.count;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TitleCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TitleCell];
    }

    cell.textLabel.text = _cellTitles[indexPath.section][indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _sectionTitles[section];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {           // 振动
        [UIApplication playSystemVibrate];
    }else if (indexPath.section == 1) {     // 用户音频
        [UIApplication playSoundWithResourceName:@"alert_message" type:@"wav"];
    }else {                                 // 系统音频
        NSString *basePath = kIsAboveiOS11 ? kAudioPath2 : kAudioPath1;
        [UIApplication playWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", basePath, _files[indexPath.row]]]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
