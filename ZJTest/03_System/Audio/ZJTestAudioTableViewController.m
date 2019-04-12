//
//  ZJTestAudioTableViewController.m
//  ZJTest
//
//  Created by ZJ on 2019/4/12.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJTestAudioTableViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ZJTestAudioTableViewController ()

@end

static NSMutableArray *_systemSounds = nil;

@implementation ZJTestAudioTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
    [self initSettiing];
}

- (void)initAry {
    
}

- (void)initSettiing {
    [self accessSystemSoundsList];
}

- (void)accessSystemSoundsList {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _systemSounds                 = [NSMutableArray array];
            // 读取文件系统
            NSFileManager *fileManager  = [[NSFileManager alloc] init];
            NSURL         *directoryURL = [NSURL URLWithString:@"/System/Library/Audio/UISounds"];
            NSArray       *keys         = [NSArray arrayWithObject:NSURLIsDirectoryKey];
            NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtURL:directoryURL
                                                  includingPropertiesForKeys:keys
                                                                     options:0
                                                                errorHandler:^(NSURL *url, NSError *error) {
                                                                    return YES;
                                                                }];
            for (NSURL *url in enumerator) {
                NSError  *error;
                NSNumber *isDirectory = nil;
                
                if ([url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error]) {
                    if (!isDirectory.boolValue) {
                        [_systemSounds addObject:url];
                    }
                    NSLog(@"目录url = %@, isDirectory = %@", url, isDirectory);
                    NSLog(@"lastPathComponent = %@", url.lastPathComponent);
                }else{
                    NSLog(@"获取资源失败url = %@", url);
                }
            }
        });
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _systemSounds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZJNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SystemTableViewCell];
    if (!cell) {
        cell = [[ZJNormalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SystemTableViewCell];
    }
    NSURL *url = _systemSounds[indexPath.row];
    cell.textLabel.text = url.lastPathComponent;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSURL *url = _systemSounds[indexPath.row];
    [UIApplication playWithUrl:url];
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
