//
//  NSDictionary+Addtion.m
//  afnet
//
//  Created by xuliying on 16/2/22.
//  Copyright © 2016年 xly. All rights reserved.
//

#import "NSDictionary+Addtion.h"

@implementation NSDictionary (Addtion)

- (NSString *)keyValueString {
    if (self.count == 0) {
        return nil;
    }
    NSMutableString *string = [NSMutableString stringWithString:@"?"];

    NSArray *keys = self.allKeys;
    if (keys) {
        keys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];

        for (NSString *key in keys) {
            id obj = self[key];
            [string appendFormat:@"%@=%@&",key,obj];
        }
    }
    
    if ([string rangeOfString:@"&"].length) {
        [string deleteCharactersInRange:NSMakeRange(string.length - 1, 1)];
    }
    
    return string;
}

@end
