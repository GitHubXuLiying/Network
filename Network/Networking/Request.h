//
//  Request.h
//  afnet
//
//  Created by xuliying on 16/2/22.
//  Copyright © 2016年 xly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RequestDefine.h"
#import "RequestDelegate.h"
#import "NSObject+Addition.h"
@interface Request : NSObject

@property(nonatomic,assign) RequestMethod requestMethod;
@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) NSDictionary *params;
@property(nonatomic,assign) id<RequestDelegate> delegate;
@property(nonatomic,assign) id<RequestDeallocDelegate> deallocDelegate;
@property(nonatomic,assign) id<UploadImageProgressDelegate> uploadImageProgressDelegate;
@property(nonatomic,assign) id target;
@property(nonatomic,assign) SEL action;
@property(nonatomic,strong) NSURLSessionDataTask *task;

@property(nonatomic,strong) NSDictionary *dataDict;
@property(nonatomic,strong) NSArray *dataArray;
@property(nonatomic,strong) UIImage* dataImage;
@property(nonatomic,strong) id responseData;
@property(nonatomic,strong) NSError *error;

@property (nonatomic, copy) NSString *hudMessage;


@property(nonatomic,assign,readonly) BOOL isRunning;
@property(nonatomic,assign,readonly) BOOL isSuspended;
@property(nonatomic,assign,readonly) BOOL isCanceling;
@property(nonatomic,assign,readonly) BOOL isCompleted;

@property(nonatomic,copy) NSString *tempTagStr;//内部使用tag
@property(nonatomic,copy,readonly) NSString *tag;//外部使用 可根据tag判断是否是一个request
@property(nonatomic,assign) NSUInteger identifyTag;//自定义identifyTag


-(Request *)initWithUrl:(NSString *)url requestMethod:(RequestMethod)method params:(NSMutableDictionary *)params delegate:(id)delegate target:(id)target action:(SEL)action showHUDMessage:(NSString *)message successBlock:(RequestSucBlock)successBlock failureBlock:(RequestFailBlock)failureBlock tag:(NSString *)tagStr;

-(Request *)initWithImage:(UIImage *)image url:(NSString *)url params:(NSDictionary *)params fileName:(NSString *)fileName name:(NSString *)name delegate:(id)delegate target:(id)target action:(SEL)action showHUDMessage:(NSString *)message successBlock:(PostImageSucBlock)successBlock failureBlock:(PostImageFailBlock)failureBlock tag:(NSString *)tagStr;
@end
