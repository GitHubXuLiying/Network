//
//  NSDictionary+Addtion.m
//  afnet
//
//  Created by xuliying on 16/2/22.
//  Copyright © 2016年 xly. All rights reserved.
//

#import "NSDictionary+Addtion.h"

@implementation NSDictionary (Addtion)
- (NSString *)keyValueString
{
    NSMutableString *string = [NSMutableString stringWithString:@"?"];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [string appendFormat:@"%@=%@&",key,obj];
    }];
    
    if ([string rangeOfString:@"&"].length) {
        [string deleteCharactersInRange:NSMakeRange(string.length - 1, 1)];
    }
    
    return string;
}
@end
