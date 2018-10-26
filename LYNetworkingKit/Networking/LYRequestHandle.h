//
//  RequestHandler.h
//  afnet
//
//  Created by xuliying on 16/2/22.
//  Copyright © 2016年 xly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LYRequestDefine.h"
#import "LYRequestDelegate.h"
@class LYRequest;

@class AFHTTPSessionManager;

@interface LYRequestHandle : NSObject <LYRequestDelegate,RequestDeallocDelegate>

@property (nonatomic, assign) BOOL networkError;//未设置
@property (nonatomic, assign) BOOL debugLogEnabled;
@property (nonatomic, strong) NSRecursiveLock *lock;


@property (nonatomic, copy) AFNetworkReachabilityBlock networkStatusBlock;

+ (LYRequestHandle *)sharedInstance;


- (void)addRequest:(LYRequest *)request MD5Identifier:(NSString *)MD5Identifier;
- (void)cancelRequestWithMD5Identifier:(NSString *)MD5Identifier;
- (void)cancelAllRequest;
- (void)cancelRequest:(LYRequest *)request;
- (void)cancelRequests:(NSArray *)requests;
- (void)cancelRequestWithDelegate:(id)delegate;
- (void)cancelRequestWithUrl:(NSString *)url;
- (void)cancelRequestWithUrl:(NSString *)url params:(NSDictionary *)params;
- (NSArray *)requestsWithMD5Identifier:(NSString *)MD5Identifier;
- (void)deleteRequestsWithMD5Identifier:(NSString *)MD5Identifier;
- (void)deleteRequest:(LYRequest *)request;

- (LYRequest *)existRequest:(LYRequest *)request;
- (void)addReuest:(LYRequest *)request;

- (void)startMonitoring;

@end
