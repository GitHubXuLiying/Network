//
//  RequestManager.h
//  afnet
//
//  Created by xuliying on 16/2/22.
//  Copyright © 2016年 xly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestDefine.h"
#import "RequestDelegate.h"
#import "Request.h"
#import "RequestHandler.h"

@interface RequestManager : NSObject

+(instancetype)sharedInstance;

+ (Request *)getRequstWithURL:(NSString*)url
                  params:(NSMutableDictionary*)paramsDict
            successBlock:(RequestSucBlock)successBlock
            failureBlock:(RequestFailBlock)failureBlock
                 showHUDMessage:(NSString *)message;
+ (Request *)getRequstWithURL:(NSString*)url
                  params:(NSMutableDictionary*)paramsDict
                delegate:(id<RequestDelegate>)delegate
                 showHUDMessage:(NSString *)message;
+ (Request *)getRequstWithURL:(NSString*)url
                  params:(NSMutableDictionary*)paramsDict
                  target:(id)target
                  action:(SEL)action
                 showHUDMessage:(NSString *)message;

/********************************************************************************************************/

+ (Request *)postRequstWithURL:(NSString*)url
                  params:(NSMutableDictionary*)paramsDict
            successBlock:(RequestSucBlock)successBlock
            failureBlock:(RequestFailBlock)failureBlock
                 showHUDMessage:(NSString *)message;
+ (Request *)postRequstWithURL:(NSString*)url
                  params:(NSMutableDictionary*)paramsDict
                delegate:(id<RequestDelegate>)delegate
                 showHUDMessage:(NSString *)message;
+ (Request *)postRequstWithURL:(NSString*)url
                  params:(NSMutableDictionary*)paramsDict
                  target:(id)target
                  action:(SEL)action
                 showHUDMessage:(NSString *)message;

/********************************************************************************************************/
+(Request *)requestWithImage:(UIImage *)image url:(NSString *)url params:(NSDictionary *)params fileName:(NSString *)fileName name:(NSString *)name delegate:(id<RequestDelegate>)delegate showHUDMessage:(NSString *)message;

+(Request *)requestWithImage:(UIImage *)image url:(NSString *)url params:(NSDictionary *)params fileName:(NSString *)fileName name:(NSString *)name target:(id)target action:(SEL)action showHUDMessage:(NSString *)message;

+(Request *)requestWithImage:(UIImage *)image url:(NSString *)url params:(NSDictionary *)params fileName:(NSString *)fileName name:(NSString *)name successBlock:(PostImageSucBlock)successBlock failureBlock:(PostImageFailBlock)failureBlock showHUDMessage:(NSString *)message;
@end
