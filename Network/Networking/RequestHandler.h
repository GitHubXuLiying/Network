//
//  RequestHandler.h
//  afnet
//
//  Created by xuliying on 16/2/22.
//  Copyright © 2016年 xly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RequestDefine.h"
#import "Request.h"
@class AFHTTPSessionManager;
@interface RequestHandler : NSObject<RequestDelegate,RequestDeallocDelegate>

@property(nonatomic,strong) NSMutableDictionary *requestItems;
@property(nonatomic,strong) Request *request;
@property(nonatomic,assign) BOOL networkError;//未设置
@property(nonatomic,strong) AFHTTPSessionManager *manager;

@property(nonatomic,strong) NSDictionary *defaultParams;
@property (nonatomic, copy) NSString *baseUrl;

@property(nonatomic,strong) NSMutableDictionary *exceptionUrlDict;//特殊的请求 设置相对应的baseurl

@property(nonatomic,assign) NSTimeInterval timeoutInterval;//超时时间 默认是60s

+(RequestHandler *)sharedInstance;

-(Request *)requestWithURL:(NSString *)url requestMethod:(RequestMethod)method params:(NSMutableDictionary *)params delegate:(id)delegate showHUDMessage:(NSString *)message target:(id)target action:(SEL)action successBlock:(RequestSucBlock)successBlock failureBlock:(RequestFailBlock)failureBlock;


-(Request *)requestWithImage:(UIImage *)image url:(NSString *)url params:(NSDictionary *)params fileName:(NSString *)fileName name:(NSString *)name delegate:(id)delegate target:(id)target action:(SEL)action showHUDMessage:(NSString *)message successBlock:(PostImageSucBlock)successBlock failureBlock:(PostImageFailBlock)failureBlock;

+(void)cancelAllRequest;
+(void)cancelRequest:(Request *)request;
+(void)cancelRequestWithDelegate:(id)delegate;
+(void)cancelRequestWithUrl:(NSString *)url;
+(void)startMonitoring;

@end
