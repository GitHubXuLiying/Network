//
//  NSArray+LYAddtion.m
//  Request
//
//  Created by xly on 2018/10/23.
//  Copyright © 2018年 Xly. All rights reserved.
//

#import "NSArray+LYAddtion.h"
#import "NSDictionary+LYAddtion.h"
#import "NSString+LYAddtion.h"

@implementation NSArray (LYAddtion)

- (NSString *)toString {
    NSMutableString *string = [NSMutableString string];
    [string appendString:@"["];
    for (id obj in self) {
        if ([obj isKindOfClass:NSDictionary.class]) {
            [string appendString:[obj toString]];
        }   if ([obj isKindOfClass:NSArray.class]) {
            [string appendString:[obj toString]];
        } else if ([obj isKindOfClass:NSString.class]) {
            [string appendString:[obj toString]];
        } else if ([obj isKindOfClass:NSNumber.class]) {
            [string appendFormat:@"%@",obj];
        }
        if ([string hasSuffix:@","] == NO) {
            [string appendString:@","];
        }
    }
    if ([string hasSuffix:@","]) {
        [string deleteCharactersInRange:NSMakeRange(string.length - 1, 1)];
    }
    [string appendString:@"]"];
    return string;
}

@end
