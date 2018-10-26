//
//  Request.m
//  afnet
//
//  Created by xuliying on 16/2/22.
//  Copyright © 2016年 xly. All rights reserved.
//

#import "LYRequest.h"
#import "AFNetworking.h"
#import "LYRequestHandle.h"
#import "NSString+LYAddtion.h"
#import "LYRequestCacheManager.h"
#import "NSDictionary+LYAddtion.h"

@interface LYRequest()

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, assign) BOOL isUPloadImage;

@end

@implementation LYRequest

- (void)dealloc {
    self.delegate = nil;
    if (self.task && self.isRunning) {
        [self.task cancel];
    }
    NSLog(@"___requestDealloc____");
}

- (instancetype)initWithUrl:(NSString *)url requestMethod:(LYRequestMethod)method params:(NSDictionary *)params delegate:(id)delegate target:(id)target action:(SEL)action successBlock:(LYRequestSucBlock)successBlock failureBlock:(LYRequestFailBlock)failureBlock {
    
    if (self = [super init]) {
        [self initDefaultConfig];
        self.isUPloadImage = NO;
        self.url = url;
        self.requestMethod = method;
        
        self.params = params;
        self.delegate = delegate;
        self.target = target;
        self.action = action;
        self.successBlock = successBlock;
        self.failureBlock = failureBlock;
        self.deallocDelegate = [LYRequestHandle sharedInstance];
    }
    return self;
}

- (void)initDefaultConfig {
    self.manager = [AFHTTPSessionManager manager];
    
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    
    self.timeoutInterval = 60;
    self.manager.requestSerializer.timeoutInterval = self.timeoutInterval;
    self.callBackIfCanceled = YES;
    self.requestType = LYRequestTypeJSON;
    self.callBackIfIsRepeatRequest = YES;
}

- (void)resetDefaultConfig {
    [LYRequestCacheManager sharedInstance];
    self.manager.requestSerializer.timeoutInterval = self.timeoutInterval;
    if (self.requestType == LYRequestTypeJSON) {
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    } else {
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    self.finished = NO;
    if (self.httpHeaders) {
        for (NSString *key in self.httpHeaders.allKeys) {
            [self.manager.requestSerializer setValue:self.httpHeaders[key] forHTTPHeaderField:key];
        }
    }
}

- (id)jsonParseWithData:(id)data {
    self.responseObject = data;
    return data;
}

- (instancetype)initWithImage:(UIImage *)image url:(NSString *)url params:(NSDictionary *)params fileName:(NSString *)fileName name:(NSString *)name delegate:(id)delegate target:(id)target action:(SEL)action successBlock:(LYRequestSucBlock)successBlock failureBlock:(LYRequestFailBlock)failureBlock {
    if (self = [super init]) {
        if (!image) {
            return nil;
        }
        self.isUPloadImage = YES;
        self.url = [self getUrlWithUrl:url];
        self.fileName = fileName;
        self.name = name;
        self.delegate = delegate;
        self.target = target;
        self.action = action;
        self.params = params;
        self.successBlock = successBlock;
        self.failureBlock = failureBlock;
        self.image = image;
    }
    return self;
}



+ (instancetype)requestWithURL:(NSString *)url requestMethod:(LYRequestMethod)method params:(NSDictionary *)params delegate:(id)delegate target:(id)target action:(SEL)action successBlock:(LYRequestSucBlock)successBlock failureBlock:(LYRequestFailBlock)failureBlock {
    
    LYRequest *request = [[self alloc] initWithUrl:url requestMethod:method params:params delegate:delegate target:target action:action successBlock:successBlock failureBlock:failureBlock];
    return request;
}

+ (instancetype)requestWithImage:(UIImage *)image url:(NSString *)url params:(NSDictionary *)params fileName:(NSString *)fileName name:(NSString *)name delegate:(id)delegate target:(id)target action:(SEL)action successBlock:(LYRequestSucBlock)successBlock failureBlock:(LYRequestFailBlock)failureBlock {
    if (!image) {
        return nil;
    }
    LYRequest *request = [[self alloc] initWithImage:image url:url params:params fileName:fileName name:name delegate:delegate target:target action:action successBlock:successBlock failureBlock:failureBlock];
    
    return request;
}

- (void)resume {
    [self resumeWithParams:nil];
}

- (void)resumeWithNewParams:(NSDictionary *)params {
    self.newparams = params;
    [self resumeWithParams:params];
}

- (void)resumeWithParams:(NSDictionary *)paramss {
    
    [self resetDefaultConfig];
    
    NSString *url = self.url;
    if (self.baseURL) {
        url = [self getUrlWithUrl:self.url];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.defaultParams) {
        [params setValuesForKeysWithDictionary:self.defaultParams];
    }
    if (self.params) {
        [params setValuesForKeysWithDictionary:self.params];
    }
    if (paramss) {
        [params setValuesForKeysWithDictionary:self.newparams];
    }
    
    NSLog(@"请求url____%@",url);
    NSLog(@"请求参数____%@",params);
    AFHTTPSessionManager *manager = self.manager;
    if (self.isUPloadImage) { //上传图片
        [self resumeUPLoadImage];
        return;
    }
    if (self.startBlock) {
        self.startBlock(self);
    }
    NSLog(@"________   %@",self.md5Identifier);
    
    if (self.useCache) {
        id responseObject = [[LYRequestCacheManager sharedInstance] cacheRequestWithRequest:self];
        if (responseObject) {
            self.responseObject = responseObject;
            [self parseCacheRequest:self];
        }
    }
    
    LYRequest *re = [[LYRequestHandle sharedInstance] existRequest:self];
    if (re) {
        if (!self.ignoreExistRequest) {
            NSLog(@"已存在相同的网络请求");
            [[LYRequestHandle sharedInstance] addReuest:self];
            self.task = re.task;
            return;
        }
        
        if (!self.callBackIfIsRepeatRequest) {
            return;
        }
    }
    [[LYRequestHandle sharedInstance] addReuest:self];
    NSString *method = @"GET";
    if (self.requestMethod == POST) {
        method = @"POST";
    }
    
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:method URLString:url parameters:params error:nil];
    self.task = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (responseObject) {
            if (self) {
                [self jsonParseWithData:responseObject];
                [self parse];
            }
        } else {
            if (self) {
                self.error = error;
                [self parse];
            }
        }
    }];
    
    
    [self.task resume];
}

- (void)resumeUPLoadImage {
    if (self.startBlock) {
        self.startBlock(self);
    }
    AFHTTPSessionManager *manager = self.manager;
    self.task  =  [manager POST:self.url parameters:self.params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(self.image, 0.4);
        
        NSString *imageFileName = self.fileName;
        if (self.fileName == nil || ![self.fileName isKindOfClass:[NSString class]] || self.fileName.length == 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            imageFileName = [NSString stringWithFormat:@"%@.jpg", str];
        }
        
        [formData appendPartWithFileData:imageData name:self.name fileName:imageFileName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"****____%f",(double)uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
        if (self.uploadImageProgressDelegate && [self.uploadImageProgressDelegate respondsToSelector:@selector(uploadImageProgress:)]) {
            [self.uploadImageProgressDelegate uploadImageProgress:(double)uploadProgress.completedUnitCount/uploadProgress.totalUnitCount];
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self jsonParseWithData:responseObject];
        [self parse];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.error = error;
        [self parse];
    }];
}

- (BOOL)isRunning {
    return self.task && self.task.state == NSURLSessionTaskStateRunning;
}

- (BOOL)isCanceling {
    return self.task && self.task.state == NSURLSessionTaskStateCanceling;
}

- (BOOL)isSuspended {
    return self.task && self.task.state == NSURLSessionTaskStateSuspended;
}

- (BOOL)isCompleted {
    return self.task && self.task.state == NSURLSessionTaskStateCompleted;
}

- (NSString *)getUrlWithUrl:(NSString *)url {
    NSString *urlStr;
    if (([url hasPrefix:@"https://"] || [url hasPrefix:@"http://"])) {
        urlStr = url;
    } else {
        if (self.baseURL && self.baseURL.length){
            urlStr = [NSString stringWithFormat:@"%@%@",self.baseURL,url?:@""];
        }else{
            urlStr = url;
        }
    }
    return urlStr;
}

- (void)parse {
    [[LYRequestHandle sharedInstance].lock lock];
    NSArray *requests = [[LYRequestHandle sharedInstance] requestsWithMD5Identifier:self.md5Identifier].copy;
    
    for (NSInteger index = 0;index < requests.count;index ++) {
        LYRequest *req = requests[index];
        if (req == self || req.task == self.task) {
            if (req != self) {
                req.error = self.error;
                req.responseObject = self.responseObject;
            }
            [self parseRequest:req];
            req.finished = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:KLYRequestDidFinish object:req];
            [[LYRequestHandle sharedInstance] deleteRequest:req];
        }
        
    }
    [[LYRequestHandle sharedInstance].lock unlock];
}


- (void)parseRequest:(LYRequest *)req {
    if (!req) {
        return;
    }
    if (req.error) {
        if (!(req.error.code == NSURLErrorCancelled && self.callBackIfCanceled == NO)) {
            if (req.endBlock) {
                req.endBlock(req);
            }
            
            if (req.failureBlock) {
                req.failureBlock(req);
            }
            
            if (req.delegate && [req.delegate respondsToSelector:@selector(requestdidFailWithError:)]) {
                [req.delegate requestdidFailWithError:req];
            }
            
            if (req.target && [req.target respondsToSelector:req.action]) {
                [req.target performSelector:req.action withObject:req afterDelay:0.0];
            }
        }
    } else {
        if (req.endBlock) {
            req.endBlock(req);
        }
        if (req.successBlock) {
            req.successBlock(req);
        }
        if (req.delegate && [req.delegate respondsToSelector:@selector(requestDidFinishLoading:)]) {
            [req.delegate requestDidFinishLoading:req];
        }
        if (req.target && [req.target respondsToSelector:req.action]) {
            [req.target performSelector:req.action withObject:req afterDelay:0.0];
        }
    }
}

- (void)parseCacheRequest:(LYRequest *)req {
    if (self.successBlock) {
        self.successBlock(req);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestDidFinishLoading:)]) {
        [self.delegate requestDidFinishLoading:req];
    }
    if (self.target && [self.target respondsToSelector:self.action]) {
        [self.target performSelector:self.action withObject:req afterDelay:0.0];
    }
}

- (void)removewRequest:(LYRequest *)request {
    __weak typeof(self)weakSelf = self;
    if ([weakSelf.deallocDelegate respondsToSelector:@selector(requestWillDealloc:)]) {
        [weakSelf.deallocDelegate requestWillDealloc:request];
    }
}



+ (instancetype)getRequstWithURL:(NSString *)url params:(NSDictionary *)params successBlock:(LYRequestSucBlock)successBlock failureBlock:(LYRequestFailBlock)failureBlock {
    LYRequest *request = [self requestWithURL:url requestMethod:GET params:params delegate:nil target:nil action:nil successBlock:successBlock failureBlock:failureBlock];
    
    return request;
}

+ (instancetype)getRequstWithURL:(NSString *)url params:(NSDictionary *)params delegate:(id<LYRequestDelegate>)delegate {
    LYRequest *request = [self requestWithURL:url requestMethod:GET params:params delegate:delegate target:nil action:nil successBlock:nil failureBlock:nil];
    
    return request;
}

+ (instancetype)getRequstWithURL:(NSString *)url params:(NSDictionary *)params target:(id)target action:(SEL)action {
    LYRequest *request = [self requestWithURL:url requestMethod:GET params:params delegate:nil target:target action:action successBlock:nil failureBlock:nil];
    
    return request;
}

+ (instancetype)postRequstWithURL:(NSString *)url params:(NSDictionary *)params successBlock:(LYRequestSucBlock)successBlock failureBlock:(LYRequestFailBlock)failureBlock {
    LYRequest *request = [self requestWithURL:url requestMethod:POST params:params delegate:nil target:nil action:nil successBlock:successBlock failureBlock:failureBlock];
    
    return request;
}

+ (instancetype)postRequstWithURL:(NSString *)url params:(NSDictionary *)params delegate:(id<LYRequestDelegate>)delegate {
    LYRequest *request = [self requestWithURL:url requestMethod:POST params:params delegate:delegate target:nil action:nil successBlock:nil failureBlock:nil];
    
    return request;
}

+ (instancetype)postRequstWithURL:(NSString *)url params:(NSDictionary *)params target:(id)target action:(SEL)action {
    LYRequest *request = [self requestWithURL:url requestMethod:POST params:params delegate:nil target:target action:action successBlock:nil failureBlock:nil];
    
    return request;
}

+ (instancetype)requestWithImage:(UIImage *)image url:(NSString *)url params:(NSDictionary *)params fileName:(NSString *)fileName name:(NSString *)name delegate:(id<LYRequestDelegate>)delegate {
    LYRequest *request = [self requestWithImage:image url:url params:params fileName:fileName name:name delegate:delegate target:nil action:nil successBlock:nil failureBlock:nil];
    
    return request;
}

+ (instancetype)requestWithImage:(UIImage *)image url:(NSString *)url params:params fileName:(NSString *)fileName name:(NSString *)name target:(id)target action:(SEL)action {
    LYRequest *request = [self requestWithImage:image url:url params:params fileName:fileName name:name delegate:nil target:target action:action successBlock:nil failureBlock:nil];
    
    return request;
}

+ (instancetype)requestWithImage:(UIImage *)image url:(NSString *)url params:params fileName:(NSString *)fileName name:(NSString *)name successBlock:(LYRequestSucBlock)successBlock failureBlock:(LYRequestFailBlock)failureBlock {
    LYRequest *request = [self requestWithImage:image url:url params:params fileName:fileName name:name delegate:nil target:nil action:nil successBlock:successBlock failureBlock:failureBlock];
    
    return request;
}

- (NSString *)md5Identifier {
    if (_md5Identifier == nil) {
        NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
        if (self.defaultParams) {
            [params1 setValuesForKeysWithDictionary:self.defaultParams];
        }
        if (self.params) {
            [params1 setValuesForKeysWithDictionary:self.params];
        }
        if (self.newparams) {
            [params1 setValuesForKeysWithDictionary:self.newparams];
        }
        NSDictionary *httpHeaders = self.httpHeaders?:@{};
        
        NSString *md5Identifier = [[NSString stringWithFormat:@"url:%@;params:%@;httpHeaders:%@",self.url,[params1 toString],[httpHeaders toString]] md5String];
        _md5Identifier = md5Identifier;
    }
    return _md5Identifier;
}

@end
