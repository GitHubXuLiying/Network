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
@property (nonatomic, strong) NSRecursiveLock *lock;

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
        self.manager = [AFHTTPSessionManager manager];
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

    LYRequest *ret;
    [self.lock lock];
    for (NSArray *arr in self.requestItems.allValues) {
        for (LYRequest *re in arr) {
            if (re.md5Identifier == request.md5Identifier && re.isRunning) {
                ret = re;
                break;
            }
        }
    }
    [self.lock unlock];
    return ret;
}

- (NSArray *)requestsWithMD5Identifier:(NSString *)MD5Identifier {
    return self.requestItems[MD5Identifier];
}

- (void)addReuest:(LYRequest *)request {
    [self.lock lock];
    [self addRequest:request MD5Identifier:request.md5Identifier];
    [self.lock unlock];
}

- (NSMutableDictionary *)requestItems {
    if (!_requestItems) {
        _requestItems = [[NSMutableDictionary alloc] init];
    }
    return _requestItems;
}


- (void)addRequest:(LYRequest *)request MD5Identifier:(NSString *)MD5Identifier {
    if (request) {
        [self.lock lock];
        NSString *taskID = MD5Identifier;
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
    if (request) {
        [self.lock lock];
        NSString *taskID = request.md5Identifier;
        NSMutableArray *requests = self.requestItems[taskID];
        if (requests && [requests containsObject:request]) {
            [requests removeObject:request];
            [self.requestItems setObject:requests forKey:taskID];
        }
        [self.lock unlock];
    }
}

- (void)deleteRequestsWithMD5Identifier:(NSString *)MD5Identifier {
    NSString *taskID = MD5Identifier;
    [self.lock lock];
    NSMutableArray *requests = self.requestItems[taskID];
    if (requests) {
        [requests removeAllObjects];
        [self.requestItems setObject:requests forKey:taskID];
    }
    [self.lock unlock];
}

- (void)cancelRequestWithMD5Identifier:(NSString *)MD5Identifier {
    NSString *taskID = MD5Identifier;
    [self.lock lock];
    NSMutableArray *requests = self.requestItems[taskID];
    if (requests && requests.count) {
        for (LYRequest *re in requests) {
            [self cancelRequest:re];
        }
    }
    [self.lock unlock];
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
        [self deleteRequest:request];
        [self.lock unlock];
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
                NSLog(@"无法连接");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi");
                break;
                
            default:
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

@end
