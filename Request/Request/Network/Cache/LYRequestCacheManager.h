//
//  LYRequestCacheManager.h
//  Request
//
//  Created by xly on 2018/10/24.
//  Copyright © 2018年 Xly. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LYRequest;

NS_ASSUME_NONNULL_BEGIN

@interface LYRequestCacheManager : NSObject

+ (LYRequestCacheManager *)sharedInstance;

- (void)storeRequest:(LYRequest *)request;

- (id)cacheRequestWithRequest:(LYRequest *)request;

- (id)cacheRequestWithUrl:(NSString *)url params:(NSDictionary *)params defaultParams:(NSDictionary *)defaultParams newparams:(NSDictionary *)newparams httpHeaders:(NSDictionary *)httpHeaders;

- (void)removeCacheWithRequest:(LYRequest *)request;

- (void)removeAllRequestCache;

@end

NS_ASSUME_NONNULL_END
