//
//  Request.m
//  afnet
//
//  Created by xuliying on 16/2/22.
//  Copyright © 2016年 xly. All rights reserved.
//

#import "Request.h"
#import "AFNetworking.h"
#import "NSDictionary+Addtion.h"
#import "RequestHandler.h"
#import "NSObject+Addition.h"
@implementation Request
-(void)dealloc{
    self.delegate = nil;
    if (self.task && self.isRunning) {
        [self.task cancel];
    }
    NSLog(@"___requestDealloc____");
}
-(Request *)initWithUrl:(NSString *)url requestMethod:(RequestMethod)method params:(NSMutableDictionary *)params delegate:(id)delegate target:(id)target action:(SEL)action showHUDMessage:(NSString *)message successBlock:(RequestSucBlock)successBlock failureBlock:(RequestFailBlock)failureBlock tag:(NSString *)tagStr{
    if (self = [super init]) {
        if (!url.isNoEmpty) {
            return nil;
        }
        self.requestMethod = method;
        self.params = params;
        self.delegate = delegate;
        self.target = target;
        self.action = action;
        
    
        if (params && [params isKindOfClass:[NSDictionary class]]) {
            self.url = [NSString stringWithFormat:@"%@%@",url,[params keyValueString]];
        }else{
            self.url = url;
        }
        NSLog(@"请求url____%@",self.url);
        self.tempTagStr = tagStr;
        
        if (message && message.length) {
            self.hudMessage = message;
            dispatch_async(dispatch_get_main_queue(), ^{
            });
        }
        __weak typeof(self)weakSelf = self;
        
   
        AFHTTPSessionManager *manager = [RequestHandler sharedInstance].manager;
    
        if (method == Get) {
         self.task = [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

             [weakSelf jsonParseWithData:responseObject];
                if (successBlock) {
                    successBlock(weakSelf);
                }
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestDidFinishLoading:)]) {
                    [weakSelf.delegate requestDidFinishLoading:weakSelf];
                }
             if (weakSelf.target && [weakSelf.target respondsToSelector:weakSelf.action]) {
                 [weakSelf.target performSelector:weakSelf.action withObject:weakSelf afterDelay:0.0];
             }
             [weakSelf removewItem];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failureBlock) {
                    failureBlock(weakSelf);
                }
                weakSelf.error = error;
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestdidFailWithError:)]) {
                    [weakSelf.delegate requestdidFailWithError:weakSelf];
                }
                if (weakSelf.target && [weakSelf.target respondsToSelector:weakSelf.action]) {
                    [weakSelf.target performSelector:weakSelf.action withObject:weakSelf afterDelay:0.0];
                }
                [weakSelf removewItem];
            }];
        }else{
          self.task =  [manager POST:url parameters:params constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [weakSelf jsonParseWithData:responseObject];
                if (successBlock) {
                    successBlock(weakSelf);
                }
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestDidFinishLoading:)]) {
                    [weakSelf.delegate requestDidFinishLoading:weakSelf];
                }
              if (weakSelf.target && [weakSelf.target respondsToSelector:weakSelf.action]) {
                  [weakSelf.target performSelector:weakSelf.action withObject:weakSelf afterDelay:0.0];
              }

                [weakSelf removewItem];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                weakSelf.error = error;
                if (failureBlock) {
                    failureBlock(weakSelf);
                }
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestdidFailWithError:)]) {
                    [weakSelf.delegate requestdidFailWithError:weakSelf];
                }
                if (weakSelf.target && [weakSelf.target respondsToSelector:weakSelf.action]) {
                    [weakSelf.target performSelector:weakSelf.action withObject:weakSelf afterDelay:0.0];
                }
                [weakSelf removewItem];
            }];
            
        }
    }
    return self;
}
-(id)jsonParseWithData:(NSData *)data{
    id result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    self.responseData = result;
    if ([result isKindOfClass:[NSDictionary class]]) {
        self.dataDict=result;
    }else{
        if ([result isKindOfClass:[NSArray class]]) {
            self.dataArray=result;
        }else{
            self.dataImage=[UIImage imageWithData:data];
        }
    }
    return  result;
}
- (void)removewItem
{
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([weakSelf.deallocDelegate respondsToSelector:@selector(requestWillDealloc:)]) {
            [weakSelf.deallocDelegate requestWillDealloc:weakSelf];
        }
    });
}
//- (void)finishedRequest:(id)data didFaild:(NSError*)error
//{
//    if ([self.target respondsToSelector:self.action]) {
//        [self.target performSelector:@selector(finishedRequest:didFaild:) withObject:data withObject:error];
//    }
//}
-(BOOL)isRunning{
    return self.task.state == NSURLSessionTaskStateRunning;
}
-(BOOL)isCanceling{
    return self.task.state == NSURLSessionTaskStateCanceling;
}
-(BOOL)isSuspended{
    return self.task.state == NSURLSessionTaskStateSuspended;
}
-(BOOL)isCompleted{
    return self.task.state == NSURLSessionTaskStateCompleted;
}

-(Request *)initWithImage:(UIImage *)image url:(NSString *)url params:(NSDictionary *)params fileName:(NSString *)fileName name:(NSString *)name delegate:(id)delegate target:(id)target action:(SEL)action showHUDMessage:(NSString *)message successBlock:(PostImageSucBlock)successBlock failureBlock:(PostImageFailBlock)failureBlock tag:(NSString *)tagStr{
    if (self = [super init]) {
        if (!image.isValid || !url.isValid) {
            return nil;
        }
        self.delegate = delegate;
        self.target = target;
        self.action = action;
        self.params = params;

        NSString *parmasStr;
        if (params && [params isKindOfClass:[NSDictionary class]]  && params.allKeys.count) {
            parmasStr = [params keyValueString];
        }
        self.url = [NSString stringWithFormat:@"%@%@",url,parmasStr];
        
        self.tempTagStr = tagStr;
        NSLog(@"url____%@",self.url);
        if (message && message.length) {
            self.hudMessage = message;
            dispatch_async(dispatch_get_main_queue(), ^{
            });
        }
        __weak typeof(self)weakSelf = self;
        
        
    AFHTTPSessionManager *manager = [RequestHandler sharedInstance].manager;
    manager.requestSerializer.timeoutInterval = 5 * 60;
    self.task  =  [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.4);
        
            NSLog(@"____%ld",imageData.length);//481300\349595
            NSString *imageFileName = fileName;
            if (fileName == nil || ![fileName isKindOfClass:[NSString class]] || fileName.length == 0) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                imageFileName = [NSString stringWithFormat:@"%@.jpg", str];
            }
        
        NSLog(@"%@ %@",name,fileName);
            [formData appendPartWithFileData:imageData name:name fileName:imageFileName mimeType:@"image/jpeg"];
//        UIImage *imag = [UIImage imageNamed:@"limite"];
//        NSData *da = UIImageJPEGRepresentation(imag, 0.8);
//         [formData appendPartWithFileData:da name:name fileName:@"1" mimeType:@"image/jpeg"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"****____%f",(double)uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
            if (self.uploadImageProgressDelegate && [self.uploadImageProgressDelegate respondsToSelector:@selector(uploadImageProgress:)]) {
                [self.uploadImageProgressDelegate uploadImageProgress:(double)uploadProgress.completedUnitCount/uploadProgress.totalUnitCount];
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf jsonParseWithData:responseObject];
            if (successBlock) {
                successBlock(weakSelf);
            }
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(postImageSuccess:)]) {
                [weakSelf.delegate postImageSuccess:weakSelf];
            }
            if (weakSelf.target && [weakSelf.target respondsToSelector:weakSelf.action]) {
                [weakSelf.target performSelector:weakSelf.action withObject:weakSelf afterDelay:0.0];
            }
            [weakSelf removewItem];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
            weakSelf.error = error;
            
            if (failureBlock) {
                failureBlock(weakSelf);
            }
//            if (error.code != -999) {
                if ([weakSelf.delegate respondsToSelector:@selector(postImageFail:)]) {
                    [weakSelf.delegate postImageFail:weakSelf];
                }
                if (weakSelf.target && [weakSelf.target respondsToSelector:weakSelf.action]) {
                    [weakSelf.target performSelector:weakSelf.action withObject:weakSelf afterDelay:0.0];
                }
//            }
      
            [weakSelf removewItem];

        }];
    }
    return self;
}


-(NSString *)tag{
    return self.tempTagStr;
}

/*
-(void)requestImages:(NSArray *)images url:(NSString *)url params:(NSDictionary *)params fileName:(NSString *)fileName name:(NSString *)name{
    
    
    NSMutableArray* result = [NSMutableArray array];
    for (NSString *img in images) {
        [result addObject:[NSNull null]];
        
    }
    
    // 准备保存结果的数组，元素个数与上传的图片个数相同，先用 NSNull 占位
    
    dispatch_group_t group = dispatch_group_create();
    
    for (NSInteger i = 0; i < images.count; i++) {
        
        dispatch_group_enter(group);
        
        [self uploadTaskWithImage:images[i]  success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"第 %d 张图片上传成功: %@", (int)i + 1, @"");
            @synchronized (result) { // NSMutableArray 是线程不安全的，所以加个同步锁
                result[i] = responseObject;
            }
            dispatch_group_leave(group);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"第 %d 张图片上传失败: %@", (int)i + 1, error);
            dispatch_group_leave(group);
        }];
        
        [self initWithImage:images[i] url:url params:params fileName:fileName name:name delegate:nil target:nil action:nil showHUDMessage:nil successBlock:^(Request *request) {
            
        } failureBlock:^(Request *request) {
            
        } tag:nil];
        
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"上传完成!");
        for (id response in result) {
            NSLog(@"%@", response);
        }
    });

}
*/
@end
