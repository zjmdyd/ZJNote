//
//  ZJWrapView.h
//  WeiMing
//
//  Created by ZJ on 13/04/2018.
//  Copyright © 2018 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJWrapView : UIView

@property (nonatomic, strong) UIView *wrapView;

+ (UIView *)createSysViewWithName:(NSString *)name frame:(CGRect)frame;
+ (UIView *)createSysViewWithName:(NSString *)name frame:(CGRect)frame needWrap:(BOOL)need;

+ (UIView *)createNibViewWithNibName:(NSString *)name frame:(CGRect)frame;
+ (UIView *)createNibViewWithNibName:(NSString *)name frame:(CGRect)frame needWrap:(BOOL)need;

@end
