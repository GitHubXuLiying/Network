//
//  NSString+LYAddtion.m
//  Request
//
//  Created by xly on 2018/10/23.
//  Copyright © 2018年 Xly. All rights reserved.
//

#import "NSString+LYAddtion.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (LYAddtion)

- (NSString *)toStrong {
    if (self && self.length) {
        if ([self isPureInt]) {
            return self;
        }
        if ([self isPureFloat]) {
            return noMoreZeroString(self);
        }
    }
    return self;
}

- (BOOL)isPureInt {
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isPureFloat {
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

- (NSInteger)indexOfCharacter:(char)character
{
    for(NSUInteger i = 0; i < [self length]; i++)
    {
        if([self characterAtIndex:i] == character)
        {
            return i;
        }
    }
    
    return -1;
}

- (NSString *)substring:(char)c len:(NSInteger)len {
    NSInteger index = [self indexOfCharacter:c];
    if (index+len+1 > self.length || index == -1) {
        return self;
    }
    NSString *str = [self substringToIndex:index + len + 1];
    return  str;
}

+ (NSString *)stringWithString:(NSString *)str1 scale:(NSInteger)scale {
    if (!str1) {
        return @"";
    }
    NSString *str = [NSString stringWithFormat:@"%@",str1];
    if (str && str.length) {
        if ([str rangeOfString:@"."].length == 1) {//有小数点
            NSArray *arr = [str componentsSeparatedByString:@"."];
            if (scale > 0) {
                NSInteger count = [arr[1] length];
                for (NSInteger i = count; i<scale; i++) {
                    str = [str stringByAppendingString:@"0"];
                }
                return str;
            }else{
                return arr[0];
            }
        }else{//没有小数点
            if ([str rangeOfString:@"."].length) {
                return @"";
            }
            if (scale > 0) {
                str = [str stringByAppendingString:@"."];
                for (int i = 0; i<scale; i++) {
                    str = [str stringByAppendingString:@"0"];
                }
                return str;
            }else{
                return str;
            }
        }
    }else{
        return @"";
    }
}

+ (NSString *)formaterStringWithStringOrNumber:(id)stringOrNumber {
    
    if (stringOrNumber == nil || [stringOrNumber isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 10;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    formatter.locale = locale;
    
    if ([stringOrNumber isKindOfClass:[NSNumber class]]) {
        return [formatter stringFromNumber:stringOrNumber];
    }
    if ([stringOrNumber isKindOfClass:[NSString class]]) {
        return [formatter stringFromNumber:[formatter numberFromString:stringOrNumber]];
    }
    return nil;
}

+ (NSString *)formaterStringWithStringOrNumber:(id)stringOrNumber scale:(NSInteger)scale {
    if (stringOrNumber == nil || [stringOrNumber isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return [NSString stringWithString:[NSString formaterStringWithStringOrNumber:stringOrNumber] scale:scale];
}


NSString *formaterString(id stringOrNumber,NSInteger scale){
    return [NSString formaterStringWithStringOrNumber:stringOrNumber scale:scale];
}
NSString *scaleString(NSString *str,NSInteger scale){
    return [NSString stringWithString:str scale:scale];
}

+ (NSString *)noMoreZeroStringWithStringOrNumber:(id)stringOrNumber {
    if (stringOrNumber == nil) {
        return nil;
    }
    
    NSString *str = [self formaterStringWithStringOrNumber:stringOrNumber];
    if (str) {
        if (str && str.length) {
            if ([str rangeOfString:@","].length) {
                return [NSString stringWithFormat:@"%@",[NSDecimalNumber decimalNumberWithString:[str stringByReplacingOccurrencesOfString:@"," withString:@""]]];
            }else{
                return [NSString stringWithFormat:@"%@",[NSDecimalNumber decimalNumberWithString:str]];
            }
        }else
            return @"";
    }else
        return nil;
    
}

NSString *noMoreZeroString(id stringOrNumber){
    return [NSString noMoreZeroStringWithStringOrNumber:stringOrNumber];
}

- (NSString *)md5String {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSString *md5Result = [NSString stringWithFormat:
                           @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return md5Result;
}

@end
