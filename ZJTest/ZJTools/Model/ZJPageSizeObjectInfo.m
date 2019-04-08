//
//  ZJPageSizeObjectInfo.m
//  PhysicalDate
//
//  Created by ZJ on 3/24/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJPageSizeObjectInfo.h"

@implementation ZJPageSizeObjectInfo

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentPage = 1;
    }
    return self;
}

- (void)appendObjects:(ZJPageSizeObjectInfo *)obj {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.objects];
    [array addObjectsFromArray:obj.objects];
    
    self.objects = [array mutableCopy];
}

@end
