//
//  ZJAlertObject.m
//  KeerZhineng
//
//  Created by ZJ on 2019/2/19.
//  Copyright © 2019 HY. All rights reserved.
//

#import "ZJAlertObject.h"

@implementation ZJAlertObject

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cancelTitle = @"取消";
        self.otherTitle = @"确定";
    }
    return self;
}

@end
