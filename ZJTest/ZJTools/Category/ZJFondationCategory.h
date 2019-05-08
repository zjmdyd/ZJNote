//
//  ZJFondationCategory.h
//  ZJCustomTools
//
//  Created by ZJ on 6/13/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZJFondationCategory : NSObject

@end


#pragma mark - NSString

@interface NSString (ZJString)

- (NSString *)pathWithParam:(id)param;
- (NSDictionary *)stringToJson;
- (BOOL)isOnlinePic;

/**
 去除字符串HTML标签
 */
- (NSString *)filterHTML;
- (NSString *)checkSysConflictKey;

/**
 *  字符串翻转
 */
- (NSString *)invertString;

/**
 汉字转拼音
 */
- (NSString *)pinYin;

#pragma mark - MD5

typedef NS_ENUM(NSInteger, MD5Type) {
    MD5Type32BitLowercase = 0,
    MD5Type32BitUppercase = 1,
    MD5Type16BitLowercase = 2,
    MD5Type16BitUppercase = 3,
};

- (NSString *)hy_md5;
- (NSString *)hy_md5WithType:(MD5Type)type;

#pragma 字符串编码

/**
 URL编码
 */
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

- (BOOL)isPureInt;
- (BOOL)isPureFloat;

#pragma mark - 正则

- (BOOL)hasNumber;
- (BOOL)isValidPhone;
- (BOOL)isValidID;

@end


#pragma mark - NSArray

@interface NSArray (ZJNSArray)

@end


#pragma mark - NSMutableArray

@interface NSMutableArray (ZJMutableArray)

@end


#pragma mark - NSDictionary

@interface NSDictionary (ZJDictionary)

- (NSDictionary *)noNullDic;
- (void)jsonToModel:(id)obj;
- (void)noNullJsonToModel:(id)obj;
- (void)noNullJsonToModel:(id)obj withSpecifyKeys:(NSArray *)keys;

@end


#pragma mark - NSDate

@implementation NSDate (CompareDate)

@end


#pragma mark - NSData

@interface NSData (ZJData)

#pragma mark - Byte数值操作


/**
 NSData按位取反运算
 */
- (NSData *)bitwiseNot;

/**
 Byte数组取反运算

 @param bytes 元byte数组
 @param reBytes 取反结果byte数组
 @param len 数组长度
 */
+ (void)bitwiseNot:(Byte *)bytes reBytes:(Byte *)reBytes len:(uint8_t)len;


/**
 根据范围获取data的值   (4字节32位)
 */
- (uint32_t)valueWithRange:(NSRange)range;

/**
 *  NSData<Byte*> --> 十六进制字符串
 */
- (NSString *)dataToHexString;

/**
 *  十六进制字符串 --> NSData<Byte*>
 */
+ (NSData *)dataWithHexString:(NSString *)hexString;

@end
