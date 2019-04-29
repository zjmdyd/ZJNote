//
//  ZJFondationCategory.m
//  ZJCustomTools
//
//  Created by ZJ on 6/13/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJFondationCategory.h"
#import <CommonCrypto/CommonDigest.h>

// 方法弃用警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@implementation ZJFondationCategory

@end


#pragma mark - NSString

@implementation NSString (ZJString)

- (NSString *)pathWithParam:(id)param {
    return [NSString stringWithFormat:@"%@/%@", self, param];
}

- (BOOL)isOnlinePic {
    if ([self hasPrefix:@"http:"] || [self hasPrefix:@"https:"]) {
        return YES;
    }
    
    return NO;
}

- (NSString *)checkSysConflictKey {
    NSArray *sysKeys = @[@"operator", @"intValue"];
    for (NSString *key in sysKeys) {
        if ([self isEqualToString:key]) {
            return [NSString stringWithFormat:@"i_%@", self];
        }
    }
    
    return self;
}

/**
 去除字符串HTML标签
 */
- (NSString *)filterHTML {
    NSString *html = self;
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd] == NO) {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        //去除空格
        html = [html stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return html;
}

/**
 翻转字符串
 */
- (NSString *)invertString {
    NSMutableString *str = [NSMutableString string];
    for (NSUInteger i = self.length; i > 0; i--) {
        [str appendString:[self substringWithRange:NSMakeRange(i-1, 1)]];
    }
    return [str mutableCopy];
}

/**
 汉字转拼音
 */
- (NSString *)pinYin {
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false);
    
    return mutableString;
}

#pragma MD5加密

- (NSString *)hy_md5 {
    return [self hy_md5WithType:MD5Type32BitLowercase];
}

- (NSString *)hy_md5WithType:(MD5Type)type {
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02X", result[i]];
    
    NSString *MD5Strubg = @"";
    
    switch (type) {
        case MD5Type16BitLowercase:
            MD5Strubg = [[hash lowercaseString] substringWithRange:NSMakeRange(8, 16)];
            break;
        case MD5Type16BitUppercase:
            MD5Strubg = [[hash uppercaseString] substringWithRange:NSMakeRange(8, 16)];
            break;
        case MD5Type32BitLowercase:
            MD5Strubg = [hash lowercaseString];
            break;
        case MD5Type32BitUppercase:
            MD5Strubg = [hash uppercaseString];
            break;
    }
    return MD5Strubg;
}

#pragma 字符串编码

- (NSString *)URLEncodedString {
    NSString *unencodedString = self;
    if (!unencodedString) return nil;
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

/**
 *  URLDecode
 */
- (NSString *)URLDecodedString {
    NSString *encodedString = self;
    if (!encodedString) return nil;
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

// 1. 整形判断
- (BOOL)isPureInt {
    NSScanner *scan = [NSScanner scannerWithString:self];
    NSInteger val;
    return [scan scanInteger:&val] && [scan isAtEnd];
}

// 2.浮点形判断：
- (BOOL)isPureFloat {
    NSScanner *scan = [NSScanner scannerWithString:self];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

#pragma mark - 正则

- (BOOL)hasNumber {
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合数字条件的有几个字节
    NSUInteger count = [reg numberOfMatchesInString:self
                                            options:NSMatchingReportProgress
                                              range:NSMakeRange(0, self.length)];
    return count > 0;
}

//手机号正则
- (BOOL)isValidPhone {
    NSString * MOBIL = @"^1(3[0-9]|4[579]|5[0-35-9]|7[01356]|8[0-9]|9[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    if ([regextestmobile evaluateWithObject:self]) {
        return YES;
    }
    
    return NO;
}

//身份证号正则
- (BOOL)isValidID {
    //长度不为18的都排除掉
    if (self.length != 18) return NO;
    
    //校验格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    BOOL flag = [identityCardPredicate evaluateWithObject:self];
    
    if (!flag) {
        return flag;    // 格式错误
    }else {
        //格式正确在判断是否合法
        
        //将前17位加权因子保存在数组里
        NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
        
        //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
        
        //用来保存前17位各自乖以加权因子后的总和
        NSInteger idCardWiSum = 0;
        for(int i = 0;i < 17;i++) {
            NSInteger subStrIndex = [[self substringWithRange:NSMakeRange(i, 1)] integerValue];
            NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
            
            idCardWiSum+= subStrIndex * idCardWiIndex;
        }
        
        //计算出校验码所在数组的位置
        NSInteger idCardMod=idCardWiSum%11;
        
        //得到最后一位身份证号码
        NSString * idCardLast= [self substringWithRange:NSMakeRange(17, 1)];
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2) {
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
                return YES;
            }else {
                return NO;
            }
        }else {
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
                return YES;
            }else {
                return NO;
            }
        }
    }
}

@end


#pragma mark - NSArray

@implementation NSArray (ZJNSArray)

@end


#pragma mark - NSMutableArray

@implementation NSMutableArray (ZJMutableArray)

@end


#pragma mark - NSDictionary

@implementation NSDictionary (ZJDictionary)


@end


#pragma mark - NSData

@implementation NSData (ZJData)

#pragma mark - Byte数值操作

// NSData按位取反运算
- (NSData *)bitwiseNot {
    Byte *bytes = (Byte *)self.bytes;
    uint8_t len = self.length;
    Byte reBytes[len];
    for (int i = 0; i < len; i++) {
        Byte byte = bytes[i];
        reBytes[i] = ~byte;
    }
    
    NSData *reData = [NSData dataWithBytes:reBytes length:len];
    return reData;
}

// byte数组取反运算
+ (void)bitwiseNot:(Byte *)bytes reBytes:(Byte *)reBytes len:(uint8_t)len {
    for (int i = 0; i < len; i++) {
        Byte byte = bytes[i];
        reBytes[i] = ~byte;
    }
}

// 根据范围获取data的值
- (uint32_t)valueWithRange:(NSRange)range {
    Byte *bytes = (Byte *)self.bytes;
    NSUInteger len = range.length;
    uint32_t value = 0;
    for (int i = 0; i < len; i++) {
        NSUInteger offset = 8 * (len-1-i);
        uint32_t v = (bytes[range.location+i] << offset) & (0xff << offset);
        value += v;
    }
    
    return value;
}

/**
 *  NSData<Byte*> --> 十六进制字符串
 */
- (NSString *)dataToHexString {
    if (!self) return nil;
    
    Byte *bytes = (Byte *)[self bytes];
    NSMutableString *str = [NSMutableString stringWithCapacity:self.length * 2];
    for (int i = 0; i < self.length; i++) {
        [str appendFormat:@"%02x", bytes[i]];
    }
    return str;
}

/**
 *  十六进制字符串 --> NSData<Byte*>
 */
+ (NSData *)dataWithHexString:(NSString *)hexString {
    NSMutableData *data = [NSMutableData data];
    for (int idx = 0; idx < hexString.length; idx += 2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString *hexStr = [hexString substringWithRange:range];
        NSScanner *scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

@end
