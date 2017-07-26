
//
//  RequestDelegate.h
//  afnet
//
//  Created by xuliying on 16/2/22.
//  Copyright © 2016年 xly. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Request;
@protocol RequestDelegate <NSObject>
@optional
- (void)requestDidFinishLoading:(Request *)request;

- (void)requestdidFailWithError:(Request*)request;


- (void)postImageSuccess:(Request *)request;
- (void)postImageFail:(Request *)request;
@end

@protocol RequestDeallocDelegate <NSObject>

- (void)requestWillDealloc:(Request*)request;

@end

@protocol UploadImageProgressDelegate <NSObject>

-(void)uploadImageProgress:(double)progress;

@end