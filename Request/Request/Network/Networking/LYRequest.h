//
//  Request.h
//  afnet
//
//  Created by xuliying on 16/2/22.
//  Copyright © 2016年 xly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYRequestHandle.h"
#import <UIKit/UIKit.h>
#import "LYRequestDefine.h"
#import "LYRequestDelegate.h"

@interface LYRequest : NSObject

@property (nonatomic, assign) LYRequestMethod requestMethod;
@property (nonatomic, assign) LYRequestType requestType;
@property (nonatomic, strong) NSURLSessionDataTask *task;


@property (nonatomic, copy)   NSString *baseURL;
@property (nonatomic, copy)   NSString *url;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, copy)   NSDictionary *defaultParams;
@property (nonatomic, copy)   NSString *md5Identifier;

@property (nonatomic, weak) id<LYRequestDelegate> delegate;
@property (nonatomic, weak) id<RequestDeallocDelegate> deallocDelegate;
@property (nonatomic, weak) id<UploadImageProgressDelegate> uploadImageProgressDelegate;

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;

@property (nonatomic, copy) LYRequestSucBlock successBlock;
@property (nonatomic, copy) LYRequestSucBlock failureBlock;
@property (nonatomic, copy) LYRequestStartBlock startBlock;
@property (nonatomic, copy) LYRequestEndBlock endBlock;


@property (nonatomic, strong) id responseObject;
@property (nonatomic, strong) NSError *error;


@property (nonatomic,assign,readonly) BOOL isRunning;
@property (nonatomic,assign,readonly) BOOL isSuspended;
@property (nonatomic,assign,readonly) BOOL isCanceling;
@property (nonatomic,assign,readonly) BOOL isCompleted;

@property (nonatomic, assign) BOOL finished;
/**
 * 请求被取消是否回调  默认为YES
 */
@property (nonatomic, assign) BOOL callBackIfCanceled;

/**
 * 忽略已存在的请求,再发起一个  默认为NO
 */

@property (nonatomic, assign) BOOL ignoreExistRequest;

/**
 * 重复发起的请求 是否回调  默认为YES
 */
@property (nonatomic, assign) BOOL callBackIfIsRepeatRequest;

@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@property(nonatomic,assign) NSInteger identifyTag;//自定义identifyTag

- (instancetype)initWithUrl:(NSString *)url requestMethod:(LYRequestMethod)method params:(NSDictionary *)params delegate:(id)delegate target:(id)target action:(SEL)action successBlock:(LYRequestSucBlock)successBlock failureBlock:(LYRequestFailBlock)failureBlock;

- (void)initDefaultConfig;

- (instancetype)initWithImage:(UIImage *)image url:(NSString *)url params:(NSDictionary *)params fileName:(NSString *)fileName name:(NSString *)name delegate:(id)delegate target:(id)target action:(SEL)action successBlock:(LYRequestSucBlock)successBlock failureBlock:(LYRequestFailBlock)failureBlock;

+ (instancetype)requestWithURL:(NSString *)url requestMethod:(LYRequestMethod)method params:(NSDictionary *)params delegate:(id)delegate target:(id)target action:(SEL)action successBlock:(LYRequestSucBlock)successBlock failureBlock:(LYRequestFailBlock)failureBlock;


+ (instancetype)requestWithImage:(UIImage *)image url:(NSString *)url params:(NSDictionary *)params fileName:(NSString *)fileName name:(NSString *)name delegate:(id)delegate target:(id)target action:(SEL)action successBlock:(LYRequestSucBlock)successBlock failureBlock:(LYRequestFailBlock)failureBlock;


- (void)resume;


+ (instancetype)getRequstWithURL:(NSString *)url
                       params:(NSDictionary *)params
                 successBlock:(LYRequestSucBlock)successBlock
                 failureBlock:(LYRequestFailBlock)failureBlock;

+ (instancetype)getRequstWithURL:(NSString *)url
                       params:(NSDictionary *)params
                     delegate:(id<LYRequestDelegate>)delegate;

+ (instancetype)getRequstWithURL:(NSString *)url
                       params:(NSDictionary*)params
                       target:(id)target
                       action:(SEL)action;

/********************************************************************************************************/

+ (instancetype)postRequstWithURL:(NSString *)url
                        params:(NSDictionary *)params
                  successBlock:(LYRequestSucBlock)successBlock
                  failureBlock:(LYRequestFailBlock)failureBlock;

+ (instancetype)postRequstWithURL:(NSString *)url
                        params:(NSDictionary*)params
                      delegate:(id<LYRequestDelegate>)delegate;

+ (instancetype)postRequstWithURL:(NSString *)url
                        params:(NSDictionary*)params
                        target:(id)target
                        action:(SEL)action;

/********************************************************************************************************/

+ (instancetype)requestWithImage:(UIImage *)image url:(NSString *)url params:(NSDictionary *)params fileName:(NSString *)fileName name:(NSString *)name delegate:(id<LYRequestDelegate>)delegate;

+ (instancetype)requestWithImage:(UIImage *)image url:(NSString *)url params:(NSDictionary *)params fileName:(NSString *)fileName name:(NSString *)name target:(id)target action:(SEL)action;

+ (instancetype)requestWithImage:(UIImage *)image url:(NSString *)url params:(NSDictionary *)params fileName:(NSString *)fileName name:(NSString *)name successBlock:(LYRequestSucBlock)successBlock failureBlock:(LYRequestFailBlock)failureBlock;

@end
