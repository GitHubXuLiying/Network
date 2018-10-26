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
