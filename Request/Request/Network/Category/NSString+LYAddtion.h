//
//  NSString+LYAddtion.h
//  Request
//
//  Created by xly on 2018/10/23.
//  Copyright © 2018年 Xly. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (LYAddtion)

- (NSString *)toString;
- (NSInteger)indexOfCharacter:(char)character;
- (NSString *)substring:(char)c len:(NSInteger)len;
+ (NSString *)stringWithString:(NSString *)str1 scale:(NSInteger)scale;

+ (NSString *)formaterStringWithStringOrNumber:(id)stringOrNumber;
+ (NSString *)formaterStringWithStringOrNumber:(id)stringOrNumber scale:(NSInteger)scale;
extern NSString *formaterString(id stringOrNumber,NSInteger scale);
extern NSString *scaleString(NSString *str,NSInteger scale);

extern NSString *noMoreZeroString(id stringOrNumber);

- (NSString *)md5String;

@end

NS_ASSUME_NONNULL_END
