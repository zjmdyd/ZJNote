//
//  ZJValueObject.h
//  CanShengHealth
//
//  Created by ZJ on 26/02/2018.
//  Copyright © 2018 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJValueObject : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *value;

@property (nonatomic, strong) NSNumber *objID;
@property (nonatomic, strong) NSNumber *status;

@property (nonatomic, getter=isSelect) BOOL select;

@end
