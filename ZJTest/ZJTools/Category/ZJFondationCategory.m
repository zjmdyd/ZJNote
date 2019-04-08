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

#pragma mark - NSParagraphStyle

@implementation NSParagraphStyle (ZJParagraphStyle)

+ (NSParagraphStyle *)styleWithHeadIndent:(CGFloat)headIndent {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = headIndent;
    
    return style;
}

+ (NSParagraphStyle *)styleWithLineSpacing:(CGFloat)lineSpacing {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpacing;
    
    return style;
}

+ (NSParagraphStyle *)styleWithIndentSpacing:(CGFloat)indentSpacing lineSpace:(CGFloat)lineSpacing {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpacing;
    style.headIndent = indentSpacing;
    style.firstLineHeadIndent = indentSpacing;
    style.tailIndent = -indentSpacing;
    
    return style;
}

+ (NSParagraphStyle *)styleWithTextAlignment:(NSTextAlignment)alignment {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = alignment;
    
    return style;
}

+ (NSParagraphStyle *)styleWithTextAlignment:(NSTextAlignment)alignment lineSpacing:(CGFloat)lineSpacing {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = alignment;
    style.lineSpacing = lineSpacing;
    
    return style;
}

@end


#pragma mark - NSString

@implementation NSString (ZJString)

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

- (NSString *)birthDayStringWithSeparate:(NSString *)separate {
    if (self.length < 8) return @"";
    
    NSString *separateString = separate;
    if (separateString.length) {
        separateString = @"-";
    }
    NSString *year = [self substringToIndex:4];
    NSString *month = [self substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [self substringFromIndex:6];
    return [NSString stringWithFormat:@"%@%@%@%@%@", year, separateString, month, separateString ,day];
}

+ (NSString *)stringWithFileName:(NSString *)name {
    NSError *error;
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:name];
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"error = %@", error);
    }
    return string;
}

- (NSString *)pinYin {
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false);
    
    return mutableString;
}

- (NSDictionary *)jsonStringToDic {
    if (self == nil) return nil;
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    if(error) {
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
    return dic;
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

- (BOOL)isOnlinePic {
    if ([self hasPrefix:@"http:"] || [self hasPrefix:@"https:"]) {
        return YES;
    }
    
    return NO;
}

- (NSString *)pathWithParam:(id)param {
    return [NSString stringWithFormat:@"%@/%@", self, param];
}

// 去除标签的方法
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

#pragma mark - 属性字符串 1

/**
 文字颜色
 */
- (NSAttributedString *)attrWithForegroundColor:(UIColor *)color {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, str.length)];
    
    return [str copy];
}

/**
 文字字体
 */
- (NSAttributedString *)attrWithFont:(UIFont *)font {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, str.length)];
    
    return [str copy];
}

/**
 文字对齐
 */
- (NSAttributedString *)attrWithTextAlignment:(NSTextAlignment)alignment {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    NSParagraphStyle *style = [NSParagraphStyle styleWithTextAlignment:alignment];
    [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
    
    return [str copy];
}

/**
 文字缩进
 */
- (NSAttributedString *)attrWithFirstLineHeadIndent:(CGFloat)headIndent {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    NSParagraphStyle *style = [NSParagraphStyle styleWithHeadIndent:headIndent];
    [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
    
    return str;
}

/**
 下划线
 */
- (NSAttributedString *)attrWithUnderLine {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    return str;
}

/**
 文字缩进 颜色
 */
- (NSAttributedString *)attrWithFirstLineHeadIndent:(CGFloat)headIndent color:(UIColor *)color {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    NSParagraphStyle *style = [NSParagraphStyle styleWithHeadIndent:headIndent];
    
    NSRange range = NSMakeRange(0, str.length);
    [str addAttribute:NSParagraphStyleAttributeName value:style range:range];
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    return str;
}

/**
 行间距
 */
- (NSAttributedString *)attrWithLineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    NSParagraphStyle *style = [NSParagraphStyle styleWithLineSpacing:lineSpace];
    [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
    
    return str;
}

/**
 行间距 对齐
 */
- (NSAttributedString *)attrWithLineSpace:(CGFloat)lineSpace textAlignment:(NSTextAlignment)alignment {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange range = NSMakeRange(0, str.length);
    
    NSParagraphStyle *style = [NSParagraphStyle styleWithLineSpacing:lineSpace];
    [str addAttribute:NSParagraphStyleAttributeName value:style range:range];
    
    NSParagraphStyle *style2 = [NSParagraphStyle styleWithTextAlignment:alignment];
    [str addAttribute:NSParagraphStyleAttributeName value:style2 range:range];
    
    return str;
}

/**
 文字颜色、字体
 */
- (NSAttributedString *)attrWithForegroundColor:(UIColor *)color font:(UIFont *)font {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    
    NSRange range = NSMakeRange(0, str.length);
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    [str addAttribute:NSFontAttributeName value:font range:range];
    
    return [str copy];
}

/**
 文字颜色、对齐
 */
- (NSAttributedString *)attrWithForegroundColor:(UIColor *)color textAlignment:(NSTextAlignment)alignment {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    
    NSRange range = NSMakeRange(0, str.length);
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    NSParagraphStyle *style = [NSParagraphStyle styleWithTextAlignment:alignment];
    [str addAttribute:NSParagraphStyleAttributeName value:style range:range];
    
    return [str copy];
}

/**
 文字字体、对齐
 */
- (NSAttributedString *)attrWithFont:(UIFont *)font textAlignment:(NSTextAlignment)alignment {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    
    NSRange range = NSMakeRange(0, str.length);
    [str addAttribute:NSFontAttributeName value:font range:range];
    
    NSParagraphStyle *style = [NSParagraphStyle styleWithTextAlignment:alignment];
    [str addAttribute:NSParagraphStyleAttributeName value:style range:range];
    
    return [str copy];
}

/**
 文字颜色、字体、对齐
 */
- (NSAttributedString *)attrWithForegroundColor:(UIColor *)color font:(UIFont *)font textAlignment:(NSTextAlignment)alignment {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    
    NSRange range = NSMakeRange(0, str.length);
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    [str addAttribute:NSFontAttributeName value:font range:range];
    
    NSParagraphStyle *style = [NSParagraphStyle styleWithTextAlignment:alignment];
    [str addAttribute:NSParagraphStyleAttributeName value:style range:range];
    
    return [str copy];
}

/**
 文字颜色、背景色、对齐
 */
- (NSAttributedString *)attrWithForegroundColor:(UIColor *)color background:(UIColor *)bgColor textAlignment:(NSTextAlignment)alignment {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    
    NSRange range = NSMakeRange(0, str.length);
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    [str addAttribute:NSBackgroundColorAttributeName value:bgColor range:range];
    
    NSParagraphStyle *style = [NSParagraphStyle styleWithTextAlignment:alignment];
    [str addAttribute:NSParagraphStyleAttributeName value:style range:range];
    
    return [str copy];
}

#pragma mark - 属性字符串 2

- (NSAttributedString *)attributedWithRange:(NSRange)range attr:(NSDictionary *)attr {
    NSMutableAttributedString *backStr = [[NSMutableAttributedString alloc] initWithString:self];
    [backStr setAttributes:attr range:range];
    
    return [backStr copy];
}

- (NSAttributedString *)attrWithMatchString:(NSString *)string attr:(NSDictionary *)attr precises:(BOOL)precises {
    NSMutableArray *indexs = [NSMutableArray array];
    NSMutableAttributedString *backStr = [[NSMutableAttributedString alloc] initWithString:self];
    
    if (precises) {
        for (int i = 0; i < self.length;) {
            NSRange range = NSMakeRange(i, string.length);
            if (range.length + range.location <= backStr.length) {
                NSString *str = [self substringWithRange:range];
                if ([str isEqualToString:string]) {
                    [backStr setAttributes:attr range:range];
                    i += string.length;
                }else {
                    i++;
                }
            }else {     // 未找到匹配字符串则退出
                break;
            }
        }
    }else {
        for (int i = 0; i < string.length; i++) {
            NSString *s1 = [string substringWithRange:NSMakeRange(i, 1)];
            for (int j = 0; j < backStr.length; j++) {
                NSRange range = NSMakeRange(j, 1);
                NSString *s2 = [self substringWithRange:range];
                if ([s1 isEqualToString:s2] && [indexs containNumber:@(j)] == NO) {
                    [backStr setAttributes:attr range:range];
                    [indexs addObject:@(j)];
                    
                    break;
                }
            }
        }
    }
    
    
    return [backStr copy];
}

#pragma mark - 时间字符串

- (NSString *)timeForOneHourRegioString {
    NSArray *strs = [self componentsSeparatedByString:@":"];
    
    NSString *s0 = [NSString stringWithFormat:@"%zd", [strs.firstObject integerValue] + 1];
    return [NSString stringWithFormat:@"%@:%@-%@:%@", [strs[0] fillZeroStringOfDigitCount:1], strs[1], [s0 fillZeroStringOfDigitCount:1], strs[1]];
}

#pragma mark - 填充字符串

- (NSString *)fillZeroStringOfDigitCount:(NSInteger)count {
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@", self];
    
    if (self.integerValue < powl(10, count)) {
        NSInteger len = count + 1 - self.length;
        for (int i = 0; i < len; i++) {
            [str insertString:@"0" atIndex:0];
        }
    }
    return [str mutableCopy];
}

- (NSString *)fillTimeString {
    NSString *str = [self fillZeroStringOfDigitCount:1];
    return [NSString stringWithFormat:@"%@:00", str];
}

#pragma mark - 翻转字符串

- (NSString *)invertString {
    NSMutableString *str = [NSMutableString string];
    for (NSUInteger i = self.length; i > 0; i--) {
        [str appendString:[self substringWithRange:NSMakeRange(i-1, 1)]];
    }
    return [str mutableCopy];
}

#pragma mark - 进制转换

+ (NSString *)ToHex:(uint16_t)tmpid {
    NSString *nLetterValue;
    NSString *str = @"";
    uint16_t ttmpig;
    for (int i = 0; i < 9; i++) {
        ttmpig = tmpid % 16; // 256 % 16 = 0;  --> 0 --> 0
        tmpid = tmpid / 16;  // 256 / 16 = 16; --> 1 --> 0
        switch (ttmpig) {
            case 10:
                nLetterValue = @"A"; break;
            case 11:
                nLetterValue = @"B"; break;
            case 12:
                nLetterValue = @"C"; break;
            case 13:
                nLetterValue = @"D"; break;
            case 14:
                nLetterValue = @"E"; break;
            case 15:
                nLetterValue = @"F"; break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u", ttmpig];    //0 ----> 0 ----> 1
        }
        str = [nLetterValue stringByAppendingString:str];   // 0 ----> 00 ----> 100
        if (tmpid == 0) {
            break;
        }
    }
    return [str mutableCopy];
}

+ (NSString *)binaryToHex:(NSString *)binary {
    NSDictionary *hexDic = [NSDictionary HexDictionary];
    
    NSMutableString *HexString = [[NSMutableString alloc] init];
    for (int i = 0; i < binary.length; i+=4) {
        NSString *value = [binary substringWithRange:NSMakeRange(i, 4)];       // 取出二进制里面的每4位数对应的value
        for (NSString *key in hexDic.allKeys) {
            if ([[hexDic objectForKey:key] isEqualToString:value]) {
                [HexString appendString:key];
                break;
            }
        }
    }
    
    return [HexString mutableCopy];
}

+ (NSString *)HexToBinary:(NSString *)hexString {
    NSDictionary *hexDic = [NSDictionary HexDictionary];
    
    NSMutableString *binaryString = [[NSMutableString alloc] init];
    
    for (int i = 0; i < hexString.length; i++) {
        NSString *key = [hexString substringWithRange:NSMakeRange(i, 1)];       // 取出16进制里面的每一位数对应的key
        NSString *value = [NSString stringWithFormat:@"%@", [hexDic objectForKey:[key uppercaseString]]];
        binaryString = [NSString stringWithFormat:@"%@%@", binaryString, value].mutableCopy;
    }
    
    return [binaryString mutableCopy];
}

+ (NSData *)hexStringToDatas:(NSString *)hexString {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= hexString.length; idx += 2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString *hexStr = [hexString substringWithRange:range];
        NSScanner *scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

+ (NSString *)oppositiveBinary:(NSString *)binary {
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i < binary.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSUInteger value = [binary substringWithRange:range].integerValue;
        [str appendString:[NSString stringWithFormat:@"%zd", (value+1)%2]];
    }
    return [str mutableCopy];
}

// 1. 整形判断
- (BOOL)isPureInt {
    NSScanner* scan = [NSScanner scannerWithString:self];
    NSInteger val;
    return [scan scanInteger:&val] && [scan isAtEnd];
}

// 2.浮点形判断：
- (BOOL)isPureFloat {
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

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
        for(int i = 0;i < 17;i++)
        {
            NSInteger subStrIndex = [[self substringWithRange:NSMakeRange(i, 1)] integerValue];
            NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
            
            idCardWiSum+= subStrIndex * idCardWiIndex;
            
        }
        
        //计算出校验码所在数组的位置
        NSInteger idCardMod=idCardWiSum%11;
        
        //得到最后一位身份证号码
        NSString * idCardLast= [self substringWithRange:NSMakeRange(17, 1)];
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2)
        {
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
            {
                return YES;
            }else
            {
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]])
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
    }
}

@end


#pragma mark - NSMutableAttributedString

@implementation NSMutableAttributedString (ZJMutableAttributedString)

- (void)setLineSpacing:(CGFloat)space range:(NSRange)range {
    if (self) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:space];
        [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    }
}

@end


#pragma mark - NSArray

@implementation NSArray (ZJNSArray)

- (void)resetArrayWithValues:(NSArray *)values {
    for (int i = 0; i < values.count; i++) {
        id value = values[i];
        if ([value isKindOfClass:[NSArray class]]) {
            [self[i] resetArrayWithValues:value];
        }else {
            if ([self isKindOfClass:[NSMutableArray class]]) {
                ((NSMutableArray *)self)[i] = value;
            }
        }
    }
}

+ (NSInteger)sexIndexWithName:(NSString *)name {
    NSArray *sexs = [self sexStrings];
    for (int i = 0; i < sexs.count; i++) {
        NSString *str = sexs[i];
        if ([str isEqualToString:name]) {
            return i;
        }
    }
    
    return 0;
}

+ (NSArray *)sexStrings {
    return @[@"男", @"女"];
}

+ (NSArray *)hourStrings {
    NSMutableArray *ary = [NSMutableArray array];
    for (int i = 0; i < 24; i++) {
        [ary addObject:[NSString stringWithFormat:@"%02d", i]];
    }
    
    return ary;
}

+ (NSArray *)minuteStrings {
    NSMutableArray *ary = [NSMutableArray array];
    for (int i = 0; i < 60; i++) {
        [ary addObject:[NSString stringWithFormat:@"%02d", i]];
    }
    
    return ary;
}

+ (NSInteger)nationIndexWithName:(NSString *)name {
    NSArray *nations = [self nationArray];
    for (NSDictionary *dic in nations) {
        if ([dic[@"value"] isEqualToString:name]) {
            return [dic[@"key"] integerValue];
        }
    }
    
    return 1;
}

+ (NSArray *)nationArray {
    return @[
             @{
                 @"key": @"1", @"value": @"汉族"
                 },
             @{
                 @"key": @"2", @"value": @"蒙古族"
                 },
             @{
                 @"key": @"3", @"value": @"回族"
                 },
             @{
                 @"key": @"4", @"value": @"藏族"
                 },
             @{
                 @"key": @"5", @"value": @"维吾尔族"
                 },
             @{
                 @"key": @"6", @"value": @"苗族"
                 },
             @{
                 @"key": @"7", @"value": @"彝族"
                 },
             @{
                 @"key": @"8", @"value": @"壮族"
                 },
             @{
                 @"key": @"9", @"value": @"布依族"
                 },
             @{
                 @"key": @"10", @"value": @"朝鲜族"
                 },
             @{
                 @"key": @"11", @"value": @"满族"
                 },
             @{
                 @"key": @"12", @"value": @"侗族"
                 },
             @{
                 @"key": @"13", @"value": @"瑶族"
                 },
             @{
                 @"key": @"14", @"value": @"白族"
                 },
             @{
                 @"key": @"15", @"value": @"土家族"
                 },
             @{
                 @"key": @"16", @"value": @"哈尼族"
                 },
             @{
                 @"key": @"17", @"value": @"哈萨克族"
                 },
             @{
                 @"key": @"18", @"value": @"傣族"
                 },
             @{
                 @"key": @"19", @"value": @"黎族"
                 },
             @{
                 @"key": @"20", @"value": @"傈僳族"
                 },
             @{
                 @"key": @"21", @"value": @"佤族"
                 },
             @{
                 @"key": @"22", @"value": @"畲族"
                 },
             @{
                 @"key": @"23", @"value": @"高山族"
                 },
             @{
                 @"key": @"24", @"value": @"拉祜族"
                 },
             @{
                 @"key": @"25", @"value": @"水族"
                 },
             @{
                 @"key": @"26", @"value": @"东乡族"
                 },
             @{
                 @"key": @"27", @"value": @"纳西族"
                 },
             @{
                 @"key": @"28", @"value": @"景颇族"
                 },
             @{
                 @"key": @"29", @"value": @"柯尔克孜族"
                 },
             @{
                 @"key": @"30", @"value": @"土族"
                 },
             @{
                 @"key": @"31", @"value": @"达斡尔族"
                 },
             @{
                 @"key": @"32", @"value": @"仫佬族"
                 },
             @{
                 @"key": @"33", @"value": @"羌族"
                 },
             @{
                 @"key": @"34", @"value": @"布朗族"
                 },
             @{
                 @"key": @"35", @"value": @"撒拉族"
                 },
             @{
                 @"key": @"36", @"value": @"毛难族"
                 },
             @{
                 @"key": @"37", @"value": @"仡佬族"
                 },
             @{
                 @"key": @"38", @"value": @"锡伯族"
                 },
             @{
                 @"key": @"39", @"value": @"阿昌族"
                 },
             @{
                 @"key": @"40", @"value": @"普米族"
                 },
             @{
                 @"key": @"41", @"value": @"塔吉克族"
                 },
             @{
                 @"key": @"42", @"value": @"怒族"
                 },
             @{
                 @"key": @"43", @"value": @"乌孜别克族"
                 },
             @{
                 @"key": @"44", @"value": @"俄罗斯族"
                 },
             @{
                 @"key": @"45", @"value": @"鄂温克族"
                 },
             @{
                 @"key": @"46", @"value": @"崩龙族"
                 },
             @{
                 @"key": @"47", @"value": @"保安族"
                 },
             @{
                 @"key": @"48", @"value": @"裕固族"
                 },
             @{
                 @"key": @"49", @"value": @"京族"
                 },
             @{
                 @"key": @"50", @"value": @"塔塔尔族"
                 },
             @{
                 @"key": @"51", @"value": @"独龙族"
                 },
             @{
                 @"key": @"52", @"value": @"鄂伦春族"
                 },
             @{
                 @"key": @"53", @"value": @"赫哲族"
                 },
             @{
                 @"key": @"54", @"value": @"门巴族"
                 },
             @{
                 @"key": @"55", @"value": @"珞巴族"
                 },
             @{
                 @"key": @"56", @"value": @"基诺族"
                 }
             ];
}

#pragma mark - 处理数据

- (BOOL)containNumber:(NSNumber *)obj {
    for (NSNumber *num in self) {
        if ([obj isEqualToNumber:num]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)containString:(NSString *)obj {
    for (NSString *str in self) {
        if ([obj isEqualToString:str]) {
            return YES;
        }
    }
    
    return NO;
}

- (NSNumber *)maxValue {
    CGFloat max = FLT_MIN;
    for (int i = 0; i < self.count; i++) {
        NSNumber *value = self[i];
        if ([value isKindOfClass:[NSNumber class]]) {
            if (max < value.floatValue) {
                max = value.floatValue;
                break;
            }
        }
    }
    
    return @(max);
}

- (NSNumber *)minValue {
    CGFloat min = FLT_MAX;
    for (int i = 0; i < self.count; i++) {
        NSNumber *value = self[i];
        if ([value isKindOfClass:[NSNumber class]]) {
            if (min > value.floatValue) {
                min = value.floatValue;
                break;
            }
        }
    }
    
    return @(min);
}

- (NSNumber *)average {
    CGFloat sum = 0.0;
    for (int i = 0; i < self.count; i++) {
        NSNumber *value = self[i];
        if ([value isKindOfClass:[NSNumber class]]) {
            sum += value.floatValue;
        }
    }
    
    return @(sum/self.count);
}

#pragma mark - 处理数组

- (NSArray *)multiDimensionalArrayMutableCopy {
    NSMutableArray *array = [NSMutableArray array];
    for (id obj in self) {
        if ([obj isKindOfClass:[NSArray class]]) {
            [array addObject:[obj multiDimensionalArrayMutableCopy]];
        }else {
            [array addObject:[obj mutableCopy]];
        }
    }
    
    return [array mutableCopy];
}

+ (NSArray *)multiArrayWithTypes:(NSArray *)array {
    return [self multiArrayWithTypes:array value:@""];
}

+ (NSArray *)multiArrayWithTypes:(NSArray *)array value:(id)value {
    NSMutableArray *ary = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        NSMutableArray *sAry = [NSMutableArray arrayWithObject:value count:[array[i] count]];
        [ary addObject:sAry];
    }
    
    return ary;
}

- (NSString *)joinToStringWithSeparateString:(NSString *)str {
    return [self joinToStringWithSeparateString:str endIndex:self.count];
}

- (NSString *)joinToStringWithSeparateString:(NSString *)str endIndex:(NSInteger)endIndex {
    if (![self isKindOfClass:[NSArray class]]) return @"";
    
    NSMutableString *string = [NSMutableString string];
    for (int i = 0; i < endIndex; i++) {
        if (i < endIndex - 1) {
            [string appendString:[NSString stringWithFormat:@"%@%@", self[i], str]];
        }else {
            [string appendString:[NSString stringWithFormat:@"%@", self[i]]];
        }
    }
    return string;
}

- (NSString *)joinToStringWithSeparateString:(NSString *)str indexs:(NSArray *)indexs beganIdx:(NSInteger)index {
    if (![self isKindOfClass:[NSArray class]]) return @"";
    
    NSMutableString *string = [NSMutableString string];
    for (int i = 0; i < indexs.count; i++) {
        NSInteger idx = [indexs[i] integerValue];
        if (i < indexs.count - 1) {
            [string appendString:[NSString stringWithFormat:@"%@%@", self[idx-index], str]];
        }else {
            [string appendString:self[idx-index]];
        }
    }
    return string;
}

// 处理布尔值

- (BOOL)hasBoolObject {
    for (id obj in self) {
        if ([obj isKindOfClass:[NSArray class]]) {
            BOOL hasMatch = [obj hasBoolObject];
            if (hasMatch) {
                return YES;
            }
        }else {
            if ([obj boolValue]) {
                return YES;
            }
        }
    }
    
    return NO;
}

@end


#pragma mark - NSMutableArray

@implementation NSMutableArray (ZJMutableArray)

+ (NSMutableArray *)arrayWithObject:(id)obj count:(NSInteger)count {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        [array addObject:obj?:@""];
    }
    
    return array;
}

+ (NSMutableArray *)arrayWithEmptyObjectWithCount:(NSInteger)count {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        [array addObject:@""];
    }
    
    return array;
}

- (void)addObject:(id)obj toSubAry:(NSMutableArray *)subAry {
    if (subAry) {
        [subAry addObject:obj];
        if (![self containsObject:subAry]) {
            [self addObject:subAry];
        }
    }else {
        subAry = [NSMutableArray array];
        [subAry addObject:obj];
        [self addObject:subAry];
    }
}

- (void)replaceDicInfoAtIndex:(NSIndexPath *)indexPath value:(NSString *)value {
    NSDictionary *dic = self[indexPath.row];
    NSString *val = dic[dic.allKeys.firstObject];
    if ([val isEqualToString:value]) {  // 如果相同就不需要更新
        return;
    }
    
    dic = @{dic.allKeys.firstObject : value};
    [self replaceObjectAtIndex:indexPath.row withObject:dic];
}

- (NSString *)stringValueFormIndex:(NSInteger)index {
    NSMutableString *str = @"".mutableCopy;
    for (NSInteger i = index; i < self.count; i++) {
        [str appendString:self[i]];
    }
    
    return str;
}

- (void)resetBoolValues {
    for(int i = 0; i < self.count; i++) {
        if ([self[i] boolValue]) {
            self[i] = @(NO);
        }
    }
}

- (void)changeBoolValuesAtIndex:(NSInteger)index needReset:(BOOL)need {
    BOOL select = [self[index] boolValue];
    self[index] = @(!select);
    if (need) {
        for(int i = 0; i < self.count; i++) {
            if (i != index && [self[i] boolValue]) {
                self[i] = @(NO);
            }
        }
    }
}


@end


#pragma mark - NSDictionary

@implementation NSDictionary (ZJDictionary)

- (NSDictionary *)noNullDic {
    NSMutableDictionary *dic = self.mutableCopy;
    
    for (NSString *key in dic.allKeys) {
        if ([dic[key] isKindOfClass:[NSNull class]]) {
            dic[key] = @"";
        }
    }
    return dic;
}

- (void)jsonToModel:(id)obj {
    for (NSString *key in self.allKeys) {
        NSString *key0 = [key checkSysConflictKey];
        if ([[obj objectProperties] containString:key0]) {
            [obj setValue:self[key] forKey:key0];
        }
    }
}

- (void)noNullJsonToModel:(id)obj {
    [self noNullJsonToModel:obj withSpecifyKeys:nil];
}

- (void)noNullJsonToModel:(id)obj withSpecifyKeys:(NSArray *)keys {
    NSDictionary *dic = [self noNullDic];
    
    for (NSString *key in dic.allKeys) {
        if (keys && ![keys containString:key]) {
            continue;
        }
        NSString *key0 = [key checkSysConflictKey];
        if ([[obj objectProperties] containString:key0]) {
            [obj setValue:dic[key] forKey:key0];
        }
    }
}

- (BOOL)containsKey:(NSString *)key {
    for (NSString *str in self.allKeys) {
        if ([str isEqualToString:key]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)containsKeyCaseInsensitive:(NSString *)key {
    for (NSString *str in self.allKeys) {
        if ([str caseInsensitiveCompare:key] == NSOrderedSame) {
            return YES;
        }
    }
    
    return NO;
}

- (NSString *)httpParamsString {
    NSMutableString *str = [NSMutableString string];
    NSArray *keys = self.allKeys;
    for (int i = 0; i < keys.count; i++) {
        NSString *key = keys[i];
        if (i < keys.count-1) {
            [str appendString:[NSString stringWithFormat:@"%@=%@&", key, self[key]]];
        }else {
            [str appendString:[NSString stringWithFormat:@"%@=%@", key, self[key]]];
        }
    }
    
    return str.mutableCopy;
}

+ (NSDictionary *)HexDictionary {
    NSMutableDictionary *hexDic = hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    NSArray *keys = @[@"A", @"B", @"C", @"D", @"E", @"F"];
    NSArray *values = @[@"0000", @"0001", @"0010", @"0011", @"0100", @"0101", @"0110", @"0111", @"1000", @"1001", @"1010", @"1011", @"1100", @"1101", @"1110", @"1111"];
    for (int i = 0; i < values.count; i++) {
        [hexDic setObject:values[i] forKey:[NSString stringWithFormat:@"%@", i<10?@(i):keys[i-10]]];
    }
    
    return [hexDic mutableCopy];
}

@end


#pragma mark - NSDate

@implementation NSDate (CompareDate)

- (NSDateComponents *)components {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:self];
    
    return comps;
}

- (BOOL)isEqualToDate:(NSDate *)date {
    NSDateComponents *componentsA = self.components;
    NSDateComponents *componentsB = date.components;
    return componentsA.year == componentsB.year && componentsA.month == componentsB.month && componentsA.day == componentsB.day;
}

- (NSString *)timestampString {
    return @((NSInteger)[self timeIntervalSince1970]).stringValue;
}

+ (NSString *)todayTimestampString {
    return [[NSDate date] timestampString];
}

- (NSTimeInterval)timestampSpanWithOther:(NSDate *)date {
    NSTimeInterval time1 = [self timeIntervalSince1970];
    NSTimeInterval time2 = [date timeIntervalSince1970];
    
    return time1 - time2;
}

#pragma mark - 年龄

- (NSInteger)age {
    // 出生日期转换 年月日
    NSDateComponents *comp1 = [self components];
    NSInteger brithYear  = [comp1 year];
    NSInteger brithMonth = [comp1 month];
    NSInteger brithDay   = [comp1 day];
    
    // 获取系统当前 年月日
    NSDateComponents *comp2 = [[NSDate date] components];
    NSInteger currentYear  = [comp2 year];
    NSInteger currentMonth = [comp2 month];
    NSInteger currentDay   = [comp2 day];
    
    // 计算年龄
    NSInteger iAge = currentYear - brithYear - 1;
    if ((currentMonth > brithMonth) || (currentMonth == brithMonth && currentDay >= brithDay)) {
        iAge++;
    }
    
    return iAge;
}

+ (NSInteger)ageWithTimeIntervel:(NSInteger)timeInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [date age];
}

#pragma mark - 天数

- (NSInteger)numberOfDayInUnit:(NSCalendarUnit)unit {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange range = [cal rangeOfUnit:NSCalendarUnitDay inUnit:unit forDate:self];
    
    return range.length;
}

+ (NSInteger)daySpanFromDate:(NSDate *)date1 toDate:(NSDate *)date2 {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2];  // 设置每周的第一天从星期几开始，比如：1代表星期日开始，2代表星期一开始，以此类推。默认值是1
    
    NSDate *fromDate, *toDate;
    
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:date1];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:date2];
    
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    return dayComponents.day;
}

+ (NSDate *)dateWithDaySpan:(NSInteger)daySpan sinceDate:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [gregorian dateByAddingUnit:NSCalendarUnitDay value:daySpan toDate:date options:NSCalendarMatchStrictly];
}

#pragma mark - 星期

+ (NSString *)weekdayToChinese:(id)weekday {
    NSArray *weekdays = @[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"];
    for (int i = 0; i < weekdays.count; i++) {
        if (i+1 == [weekday integerValue]) return weekdays[i];
    }
    
    return @"参数错误";
}

+ (NSString *)gregorianWeekdayToChinese:(id)weekday {
    NSArray *weekdays = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    for (int i = 1; i <= weekdays.count; i++) {
        if (i+1 == [weekday integerValue]) return weekdays[i];
    }
    
    return @"参数错误";
}

- (NSInteger)weekDayIndex {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit
                                         fromDate:self];
    
    // 得到星期几
    // 1(星期天) 2(星期一) 3(星期二) 4(星期三) 5(星期四) 6(星期五) 7(星期六)
    NSInteger weekDay = [comp weekday];
    if (weekDay == 1) {
        return 7;
    }else {
        return weekDay - 1;
    }
}

- (NSDate *)firsDateOfWeek {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit
                                         fromDate:self];
    
    // 得到星期几
    // 1(星期天) 2(星期一) 3(星期二) 4(星期三) 5(星期四) 6(星期五) 7(星期六)
    NSInteger weekDay = [comp weekday];
    // 得到几号
    NSInteger day = [comp day];
    
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff;
    if (weekDay == 1) {
        firstDiff = -6;
    }else{
        firstDiff =  - (weekDay-2);
    }
    
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek = [calendar dateFromComponents:firstDayComp];
    
    return firstDayOfWeek;
}

- (NSDate *)lastDateOfWeek {
    NSDate *now = [NSDate dateWithDaySpan:3 sinceDate:[NSDate date]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit
                                         fromDate:now];
    
    // 得到星期几
    // 1(星期天) 2(星期一) 3(星期二) 4(星期三) 5(星期四) 6(星期五) 7(星期六)
    NSInteger weekDay = [comp weekday];
    // 得到几号
    NSInteger day = [comp day];
    
    // 计算当前日期和这周的星期一和星期天差的天数
    long lastDiff;
    if (weekDay == 1) {
        lastDiff = 1;
    }else{
        lastDiff = 9 - weekDay;
    }
    
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *lastDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek = [calendar dateFromComponents:lastDayComp];
    
    return lastDayOfWeek;
}

@end


#pragma mark - NSData

@implementation NSData (ZJData)

#pragma mark - Byte数值操作


- (NSInteger)valueWithIdx:(NSInteger)idx {
    Byte *bytes = (Byte *)self.bytes;
    
    return bytes[idx];
}

- (NSInteger)valueWithIdx1:(NSInteger)idx1 idx2:(NSInteger)idx2 {
    Byte *bytes = (Byte *)self.bytes;
    
    char chs[2];
    chs[0] = bytes[idx1];
    chs[1] = bytes[idx2];
    return *(short *)chs;
}

- (NSString *)dataToHexString {
    if (!self) return nil;
    
    Byte *bytes = (Byte *)[self bytes];
    NSMutableString *str = [NSMutableString stringWithCapacity:self.length * 2];
    for (int i = 0; i < self.length; i++){
        [str appendFormat:@"%02x", bytes[i]];
    }
    return [str mutableCopy];
}

// 0x1020
+ (uint32_t)bytesToInt:(Byte *)bytes len:(uint8_t)len {
    if (len == 2) {
        int16_t v0 = (bytes[0]<<8) & 0xff00;
        int16_t v1 = bytes[1] & 0xff;
        int16_t value = v0 + v1;
        
        return value;
    }else {
        uint32_t v0 = (bytes[0]<<24) & 0xff000000;
        uint32_t v1 = (bytes[1]<<16) & 0xff0000;
        uint32_t v2 = (bytes[2]<<8) & 0xff00;
        uint32_t v3 = bytes[3] & 0xff;
        uint32_t value = v0 + v1 + v2 + v3;
        
        return value;
    }
}

@end
