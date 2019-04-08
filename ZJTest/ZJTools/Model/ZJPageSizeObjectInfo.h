//
//  ZJPageSizeObjectInfo.h
//  PhysicalDate
//
//  Created by ZJ on 3/24/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJPageSizeObjectInfo : NSObject

@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSArray *objects;

@property (nonatomic, assign) BOOL needRefresh;
@property (nonatomic, strong) NSDictionary *accessoryInfo;

- (void)appendObjects:(ZJPageSizeObjectInfo *)obj;

@end
