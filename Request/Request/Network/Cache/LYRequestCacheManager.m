//
//  LYRequestCacheManager.m
//  Request
//
//  Created by xly on 2018/10/24.
//  Copyright © 2018年 Xly. All rights reserved.
//

#import "LYRequestCacheManager.h"
#import "PINCache.h"
#import "LYRequest.h"
#import "NSDictionary+LYAddtion.h"
#import "NSString+LYAddtion.h"

@interface LYRequestCacheManager ()

@property (nonatomic, strong) PINCache *cache;

@end

@implementation LYRequestCacheManager

+ (LYRequestCacheManager *)sharedInstance {
    static LYRequestCacheManager *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[LYRequestCacheManager alloc] init];
    });
    return handler;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cache = [[PINCache alloc] initWithName:@"LYRequestCache"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lyRequestDidFinish:) name:KLYRequestDidFinish object:nil];
    }
    return self;
}

- (void)lyRequestDidFinish:(NSNotification *)noti {
    LYRequest *request = noti.object;
    if (request) {
        if (request.responseObject && request.cache) {
            [self storeRequest:request];
        }
    }
}

- (void)storeRequest:(LYRequest *)request {
    
    if (request && request.responseObject) {
        [self.cache setObject:request.responseObject forKey:request.md5Identifier];
    }
}

- (id)cacheRequestWithRequest:(LYRequest *)request {
    
    NSString *md5Identifier = request.md5Identifier;
    if (md5Identifier) {
        return [self.cache objectForKey:md5Identifier];
    }
    return nil;
}

- (id)cacheRequestWithUrl:(NSString *)url params:(NSDictionary *)params defaultParams:(NSDictionary *)defaultParams newparams:(NSDictionary *)newparams httpHeaders:(NSDictionary *)httpHeaders {
    
    NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
    if (defaultParams) {
        [params1 setValuesForKeysWithDictionary:defaultParams];
    }
    if (params) {
        [params1 setValuesForKeysWithDictionary:params];
    }
    if (newparams) {
        [params1 setValuesForKeysWithDictionary:newparams];
    }
    NSDictionary *headers = httpHeaders?:@{};
    
    NSString *md5Identifier = [[NSString stringWithFormat:@"url:%@;params:%@;httpHeaders:%@",url,[params1 toString],[headers toString]] md5String];
    return [self.cache objectForKey:md5Identifier];
    
}


- (void)removeCacheWithRequest:(LYRequest *)request {
    [self.cache removeObjectForKey:request.md5Identifier];
}

- (void)removeAllRequestCache {
    [self.cache removeAllObjects];
}

@end
