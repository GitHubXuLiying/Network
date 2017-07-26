//
//  RequestManager.m
//  afnet
//
//  Created by xuliying on 16/2/22.
//  Copyright © 2016年 xly. All rights reserved.
//

#import "RequestManager.h"
@implementation RequestManager
+(instancetype)sharedInstance{
    static RequestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RequestManager alloc] init];
    });
    return manager;
}
+(Request *)getRequstWithURL:(NSString *)url params:(NSMutableDictionary *)paramsDict successBlock:(RequestSucBlock)successBlock failureBlock:(RequestFailBlock)failureBlock showHUDMessage:(NSString *)message{
   return  [[RequestHandler sharedInstance] requestWithURL:url requestMethod:Get params:[NSMutableDictionary dictionaryWithDictionary:paramsDict] delegate:nil showHUDMessage:message target:nil action:nil successBlock:successBlock failureBlock:failureBlock];
    
}
+(Request *)getRequstWithURL:(NSString *)url params:(NSMutableDictionary *)paramsDict delegate:(id<RequestDelegate>)delegate showHUDMessage:(NSString *)message{
  return   [[RequestHandler sharedInstance] requestWithURL:url requestMethod:Get params:[NSMutableDictionary dictionaryWithDictionary:paramsDict] delegate:delegate showHUDMessage:message target:nil action:nil successBlock:nil failureBlock:nil];
}
+(Request *)getRequstWithURL:(NSString *)url params:(NSMutableDictionary *)paramsDict target:(id)target action:(SEL)action showHUDMessage:(NSString *)message{
   return  [[RequestHandler sharedInstance] requestWithURL:url requestMethod:Get params:[NSMutableDictionary dictionaryWithDictionary:paramsDict] delegate:nil showHUDMessage:message target:target action:action successBlock:nil failureBlock:nil];
}


+(Request *)postRequstWithURL:(NSString *)url params:(NSMutableDictionary *)paramsDict successBlock:(RequestSucBlock)successBlock failureBlock:(RequestFailBlock)failureBlock showHUDMessage:(NSString *)message{
    return [[RequestHandler sharedInstance] requestWithURL:url requestMethod:Post params:[NSMutableDictionary dictionaryWithDictionary:paramsDict] delegate:nil showHUDMessage:message target:nil action:nil successBlock:successBlock failureBlock:failureBlock];
}
+(Request *)postRequstWithURL:(NSString *)url params:(NSMutableDictionary *)paramsDict delegate:(id<RequestDelegate>)delegate showHUDMessage:(NSString *)message{
   return  [[RequestHandler sharedInstance] requestWithURL:url requestMethod:Post params:[NSMutableDictionary dictionaryWithDictionary:paramsDict] delegate:delegate showHUDMessage:message target:nil action:nil successBlock:nil failureBlock:nil];
}
+(Request *)postRequstWithURL:(NSString *)url params:(NSMutableDictionary *)paramsDict target:(id)target action:(SEL)action showHUDMessage:(NSString *)message{
   return  [[RequestHandler sharedInstance] requestWithURL:url requestMethod:Post params:[NSMutableDictionary dictionaryWithDictionary:paramsDict] delegate:nil showHUDMessage:message target:target action:action successBlock:nil failureBlock:nil];
}



+(Request *)requestWithImage:(UIImage *)image url:(NSString *)url params:(NSDictionary *)params fileName:(NSString *)fileName name:(NSString *)name delegate:(id<RequestDelegate>)delegate showHUDMessage:(NSString *)message{
    return [[RequestHandler sharedInstance] requestWithImage:image url:url params:params fileName:fileName name:name delegate:delegate target:nil action:nil showHUDMessage:message successBlock:nil failureBlock:nil];
}

+(Request *)requestWithImage:(UIImage *)image url:(NSString *)url params:params fileName:(NSString *)fileName name:(NSString *)name target:(id)target action:(SEL)action showHUDMessage:(NSString *)message{
    return [[RequestHandler sharedInstance] requestWithImage:image url:url params:params fileName:fileName name:name delegate:nil target:target action:action showHUDMessage:message successBlock:nil failureBlock:nil];
}
+(Request *)requestWithImage:(UIImage *)image url:(NSString *)url params:params fileName:(NSString *)fileName name:(NSString *)name successBlock:(PostImageSucBlock)successBlock failureBlock:(PostImageFailBlock)failureBlock showHUDMessage:(NSString *)message{
    return [[RequestHandler sharedInstance] requestWithImage:image url:url params:params fileName:fileName name:name delegate:nil target:nil action:nil showHUDMessage:message successBlock:successBlock failureBlock:failureBlock];
}
@end
