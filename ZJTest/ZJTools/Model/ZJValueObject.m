//
//  ZJValueObject.m
//  CanShengHealth
//
//  Created by ZJ on 26/02/2018.
//  Copyright © 2018 HY. All rights reserved.
//

#import "ZJValueObject.h"

@implementation ZJValueObject

- (id)copyWithZone:(NSZone *)zone {
    ZJValueObject *obj = [[ZJValueObject allocWithZone:zone] init];
    obj.name = self.name;
    obj.objID = self.objID;
    obj.select = self.select;
    
    return obj;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    ZJValueObject *obj = [[ZJValueObject allocWithZone:zone] init];
    obj.name = self.name;
    obj.objID = self.objID;
    obj.select = self.select;
    
    return obj;
}

- (BOOL)isEqual:(id)object {
    if (self.objID.integerValue == [object objID].integerValue) {
        return YES;
    }
    return NO;
}

@end
