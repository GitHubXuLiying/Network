//
//  NSDictionary+LYAddtion.m
//  Request
//
//  Created by xly on 2018/10/23.
//  Copyright © 2018年 Xly. All rights reserved.
//

#import "NSDictionary+LYAddtion.h"
#import "NSArray+LYAddtion.h"
#import "NSString+LYAddtion.h"

@implementation NSDictionary (LYAddtion)

- (NSString *)toStrong {
    NSMutableString *string = [NSMutableString string];
    [string appendString:@"{"];
    NSArray *array = [[self allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    for (NSString *key in array) {
        [string appendFormat:@"%@=",key];
        id obj = self[key];
        if ([obj isKindOfClass:NSDictionary.class]) {
            [string appendString:[obj toStrong]];
        }   if ([obj isKindOfClass:NSArray.class]) {
            [string appendString:[obj toStrong]];
        } else if ([obj isKindOfClass:NSString.class]) {
            [string appendString:[obj toStrong]];
        } else if ([obj isKindOfClass:NSNumber.class]) {
            [string appendFormat:@"%@",obj];
        }
        [string appendString:@"&"];
    }
    if ([string hasSuffix:@"&"]) {
        [string deleteCharactersInRange:NSMakeRange(string.length - 1, 1)];
    }
    [string appendString:@"}"];
    return string;
}


@end
