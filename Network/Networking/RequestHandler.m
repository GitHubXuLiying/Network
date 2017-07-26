//
//  RequestHandler.m
//  afnet
//
//  Created by xuliying on 16/2/22.
//  Copyright © 2016年 xly. All rights reserved.
//

#import "RequestHandler.h"
#import "AFNetworking.h"
#import "NSDictionary+Addtion.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation RequestHandler
+(RequestHandler *)sharedInstance{
    static RequestHandler *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[RequestHandler alloc] init];
    });
    return handler;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.networkError = NO;
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        self.manager = [AFHTTPSessionManager manager];
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        self.baseUrl = R_BASE_URL;
    }
    return self;
}

-(void)setTimeoutInterval:(NSTimeInterval)timeoutInterval{
    _timeoutInterval = timeoutInterval;
    self.manager.requestSerializer.timeoutInterval = timeoutInterval;

}
-(NSMutableDictionary *)exceptionUrlDict{
    if (_exceptionUrlDict == nil) {
        self.exceptionUrlDict = [[NSMutableDictionary alloc] init];
    }
    return _exceptionUrlDict;
}
-(Request *)requestWithURL:(NSString *)url requestMethod:(RequestMethod)method params:(NSMutableDictionary *)params delegate:(id)delegate showHUDMessage:(NSString *)message target:(id)target action:(SEL)action successBlock:(RequestSucBlock)successBlock failureBlock:(RequestFailBlock)failureBlock{
    if (!url.isNoEmpty) {
        return nil;
    }
    NSString * tagStr;
    if (method == Get) {
        tagStr = url;
    }else{
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",url,[params keyValueString]];
        tagStr = urlStr;
    }
    
    if (self.requestItems[tagStr] && [self.requestItems[tagStr] isRunning]) {
        NSLog(@"该请求已存在");
        return self.requestItems[tagStr];
    }
    
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    if (params) {
        [paramsDict setValuesForKeysWithDictionary:params];
    }
//    if (GlobalData.loginInfo.loginState) {
//        self.defaultParams = @{@"token":GlobalData.loginInfo.token,@"intermediaryId":GlobalData.loginInfo.intermediaryId};
//    }else{
//        self.defaultParams = nil;
//    }
    if (self.defaultParams) {
        [paramsDict setValuesForKeysWithDictionary:self.defaultParams];
    }
    

    [paramsDict setObject:@"iOS" forKey:@"channel"];
    NSString *urlStr;
    
    if (method == Post && ([url hasPrefix:@"https://"] || [url hasPrefix:@"http://"])) {
        urlStr = url;
    }else{
        if (self.baseUrl.isNoEmpty){
            if (_exceptionUrlDict && _exceptionUrlDict.allKeys.count && [_exceptionUrlDict[url] isNoEmpty]) {
                urlStr = [NSString stringWithFormat:@"%@%@",_exceptionUrlDict[url],url];
            }else{
                urlStr = [NSString stringWithFormat:@"%@%@",self.baseUrl,url];
            }
        }else{
            urlStr = url;
        }
    }
    

    
    self.request = [[Request alloc] initWithUrl:urlStr requestMethod:method params:paramsDict delegate:delegate target:target action:action showHUDMessage:message successBlock:successBlock failureBlock:failureBlock tag:tagStr];
    self.request.deallocDelegate = self;
    [self.requestItems setObject:self.request forKey:tagStr];
    
    NSLog(@"%@",self.requestItems);
    return self.request;
}
-(Request *)requestWithImage:(UIImage *)image url:(NSString *)url params:(NSDictionary *)params fileName:(NSString *)fileName name:(NSString *)name delegate:(id)delegate target:(id)target action:(SEL)action showHUDMessage:(NSString *)message successBlock:(PostImageSucBlock)successBlock failureBlock:(PostImageFailBlock)failureBlock{
    if (!image.isValid || !url.isValid) {
        return nil;
    }

    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    NSString *imageMD5;
    if (imageData.isValid) {
        imageMD5 = [NSString stringWithFormat:@"%lu",(unsigned long)[imageData hash]];
    }
    NSString *parmasStr;
    if (params && [params isKindOfClass:[NSDictionary class]]  && params.allKeys.count) {
        parmasStr = [params keyValueString];
    }
    NSString *identif = [NSString stringWithFormat:@"%@%@%@",url,parmasStr,imageMD5];
    NSString *tagStr = identif;
//    NSLog(@"***** %@___%ld",identif,tag);
    Request *req = self.requestItems[tagStr];
    if (req && req.isRunning) {
        return self.requestItems[tagStr];
    }
  
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    if (params) {
        [paramsDict setValuesForKeysWithDictionary:params];
    }
//    if (GlobalData.loginInfo.loginState) {
//        self.defaultParams = @{@"token":GlobalData.loginInfo.token,@"intermediaryId":GlobalData.loginInfo.intermediaryId};
//    }else{
//        self.defaultParams = nil;
//    }

    if (self.defaultParams) {
        [paramsDict setValuesForKeysWithDictionary:self.defaultParams];
    }

    [paramsDict setObject:@"iOS" forKey:@"channel"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",self.baseUrl,url];
    
    self.request = [[Request alloc] initWithImage:image url:urlStr params:paramsDict fileName:fileName name:name delegate:delegate target:target action:action showHUDMessage:message successBlock:successBlock failureBlock:failureBlock tag:tagStr];
    self.request.deallocDelegate = self;
    [self.requestItems setObject:self.request forKey:tagStr];
    return self.request;
}
-(NSMutableDictionary *)requestItems
{
    if (!_requestItems) {
        _requestItems = [NSMutableDictionary dictionary];
    }
    return _requestItems;
}
+ (void)cancelAllRequest
{
    RequestHandler *handler = [RequestHandler sharedInstance];
    for (Request *req in handler.requestItems.allValues) {
        [req.task cancel];
        req.delegate = nil;
    }
    [handler.requestItems removeAllObjects];
    handler.request.delegate = nil;
    handler.request = nil;
}
+(void)cancelRequestWithDelegate:(id)delegate{
    if (delegate) {
        RequestHandler *handler = [RequestHandler sharedInstance];
        
        
        for (Request *req in handler.requestItems.allValues) {
            NSLog(@"%@__%@",NSStringFromClass([delegate class]),NSStringFromClass([req.delegate class]));
            
            if (req.delegate == delegate) {
                [RequestHandler cancelRequest:req];
            }
        }
    }
}
+(void)cancelRequestWithUrl:(NSString *)url{
    if (url && url.length) {
        RequestHandler *handler = [RequestHandler sharedInstance];
        for (Request *req in handler.requestItems.allValues) {
            if ([req.task.currentRequest.URL.absoluteString rangeOfString:url].length) {
                [RequestHandler cancelRequest:req];
            }
        }
    }
}
+(void)cancelRequest:(Request *)request{
    if (request) {
        [[request task] cancel];
        RequestHandler *handler = [RequestHandler sharedInstance];
        [handler.requestItems removeObjectForKey:request.tag];
        request.delegate = nil;
        if (request == handler.request) {
            handler.request.delegate = nil;
            handler.request = nil;
        }
    }
}
- (void)requestWillDealloc:(Request *)request
{
    if (request) {
        [self.requestItems removeObjectForKey:request.tag];
        if (self.request == request) {
            self.request.delegate = nil;
            self.request = nil;
        }
    }
}
+(void)startMonitoring{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        BOOL ret = [AFNetworkReachabilityManager sharedManager].isReachable;

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
