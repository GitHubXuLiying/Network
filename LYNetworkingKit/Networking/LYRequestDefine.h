//
//  LYRequestDefine.h
//  afnet
//
//  Created by xuliying on 16/2/22.
//  Copyright © 2016年 xly. All rights reserved.
//


#import "AFNetworking.h"

@class LYRequest;

typedef NS_ENUM(NSInteger,LYRequestMethod) {
    GET = 1,
    POST
};

typedef NS_ENUM(NSInteger,LYRequestType) {
    LYRequestTypeJSON = 1,//默认
    LYRequestTypePlainText
};

typedef void (^LYRequestSucBlock)(LYRequest *request);
typedef void (^LYRequestFailBlock)(LYRequest *request);

typedef void (^LYGroupRequestCompletedBlock)(NSArray *requests);

typedef void (^LYRequestStartBlock)(LYRequest *request);
typedef void (^LYRequestEndBlock)(LYRequest *request);

typedef void (^AFNetworkReachabilityBlock)(AFNetworkReachabilityStatus status);

#define KLYRequestDidFinish      @"KRequestDidFinish"

#ifdef DEBUG

#define LYLog( s, ... )\
if ([LYRequestHandle sharedInstance].debugLogEnabled) {\
NSLog(@"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__]);\
} else {}

#else

#define LYLog(...)

#endif
