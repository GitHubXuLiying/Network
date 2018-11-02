//
//  RequestHandler.m
//  afnet
//
//  Created by xuliying on 16/2/22.
//  Copyright © 2016年 xly. All rights reserved.
//

#import "LYRequestHandle.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "LYRequest.h"

@interface LYRequestHandle ()

@property(nonatomic,strong) NSMutableDictionary *requestItems;

@end

@implementation LYRequestHandle

+ (LYRequestHandle *)sharedInstance {
    static LYRequestHandle *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[LYRequestHandle alloc] init];
    });
    return handler;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.lock = [[NSRecursiveLock alloc] init];
        self.networkError = YES;
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    }
    return self;
}

- (NSString *)jsonStringWithDict:(NSDictionary *)dict {
    if (!dict) {
        return nil;
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        return nil;
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

- (LYRequest *)existRequest:(LYRequest *)request {
    NSString *md5ID = request.identifier;
    if (md5ID && md5ID.length) {
        LYRequest *ret;
        [self.lock lock];
        NSArray *requests = [self requestsWithIdentifier:md5ID];
        for (LYRequest *re in requests) {
            if ([re.identifier isEqualToString:md5ID] && re.isRunning) {
                ret = re;
                break;
            }
        }
        [self.lock unlock];
        return ret;
    } else {
        return nil;
    }
    
}

- (NSArray *)requestsWithIdentifier:(NSString *)identifier {
    if (!identifier || identifier.length == 0) {
        return nil;
    }
    return self.requestItems[identifier];
}

- (void)addReuest:(LYRequest *)request {
    NSString *md5Id = request.identifier;
    if (md5Id && md5Id.length) {
        [self.lock lock];
        [self addRequest:request identifier:md5Id];
        [self.lock unlock];
    }
}

- (NSMutableDictionary *)requestItems {
    if (!_requestItems) {
        _requestItems = [[NSMutableDictionary alloc] init];
    }
    return _requestItems;
}


- (void)addRequest:(LYRequest *)request identifier:(NSString *)identifier {
    if (request && identifier && identifier.length) {
        [self.lock lock];
        NSString *taskID = identifier;
        NSMutableArray *requests = self.requestItems[taskID];
        if (requests == nil) {
            requests = [NSMutableArray array];
        }
        [requests addObject:request];
        [self.requestItems setObject:requests forKey:taskID];
        [self.lock unlock];
    }
}

- (void)deleteRequest:(LYRequest *)request {
    NSString *taskID = request.identifier;
    if (request && taskID && taskID.length) {
        [self.lock lock];
        NSMutableArray *requests = self.requestItems[taskID];
        if (requests && [requests containsObject:request]) {
            [requests removeObject:request];
            [self.requestItems setObject:requests forKey:taskID];
        }
        [self.lock unlock];
    }
}

- (void)deleterequestsWithIdentifier:(NSString *)identifier {
    NSString *taskID = identifier;
    if (taskID && taskID.length) {
        [self.lock lock];
        NSMutableArray *requests = self.requestItems[taskID];
        if (requests && requests.count) {
            [requests removeAllObjects];
            [self.requestItems setObject:requests forKey:taskID];
        }
        [self.lock unlock];
    }
}

- (void)cancelRequestWithIdentifier:(NSString *)identifier {
    if (identifier && identifier.length) {
        NSString *taskID = identifier;
        [self.lock lock];
        NSMutableArray *requests = self.requestItems[taskID];
        if (requests && requests.count) {
            for (LYRequest *re in requests) {
                [self cancelRequest:re];
            }
        }
        [self.lock unlock];
    }
}

- (void)cancelAllRequest {
    [self.lock lock];
    for (NSArray *arr in self.requestItems.allValues) {
        for (LYRequest *req in arr) {
            [req.task cancel];
        }
    }
    [self.requestItems removeAllObjects];
    [self.lock unlock];
}

- (void)cancelRequestWithDelegate:(id)delegate{
    
    if (delegate) {
        [self.lock lock];
        for (NSArray *arr in self.requestItems.allValues) {
            for (LYRequest *req in arr) {
                if (req.delegate == delegate) {
                    [self cancelRequest:req];
                }
            }
        }
        [self.lock unlock];
    }
}

- (void)cancelRequestWithUrl:(NSString *)url{
    [self.lock lock];
    if (url && url.length) {
        for (NSArray *arr in self.requestItems.allValues) {
            for (LYRequest *req in arr) {
                if ([req.url isEqualToString:url]) {
                    [self cancelRequest:req];
                }
            }
        }
    }
    [self.lock unlock];
}

- (void)cancelRequestWithUrl:(NSString *)url params:(NSDictionary *)params {
    [self.lock lock];
    for (NSArray *arr in self.requestItems.allValues) {
        for (LYRequest *req in arr) {
            if ([req.url isEqualToString:url] && [req.params isEqualToDictionary:params]) {
                [self cancelRequest:req];
            }
        }
    }
    [self.lock unlock];
}

- (void)cancelRequest:(LYRequest *)request{
    if (request) {
        [self.lock lock];
        [[request task] cancel];
//        [self deleteRequest:request];
        [self.lock unlock];
    }
}

- (void)cancelRequests:(NSArray *)requests {
    for (LYRequest *request in requests) {
        [self cancelRequest:request];
    }
}

- (void)requestWillDealloc:(LYRequest *)request {
    if (request) {
        [self deleteRequest:request];
    }
}

- (void)startMonitoring {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        BOOL ret = [AFNetworkReachabilityManager sharedManager].isReachable;
        self.networkError = !ret;
        if (self.networkStatusBlock) {
            self.networkStatusBlock(status);
        }
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                break;
            case AFNetworkReachabilityStatusNotReachable:
                LYLog(@"无法连接");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                LYLog(@"蜂窝");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                LYLog(@"wifi");
                break;
                
            default:
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

@end
