
//
//  LYRequestDelegate.h
//  afnet
//
//  Created by xuliying on 16/2/22.
//  Copyright © 2016年 xly. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LYRequest;

@protocol LYRequestDelegate <NSObject>

@optional
- (void)requestDidFinishLoading:(LYRequest *)request;

- (void)requestdidFailWithError:(LYRequest*)request;


- (void)postImageSuccess:(LYRequest *)request;
- (void)postImageFail:(LYRequest *)request;

@end

@protocol RequestDeallocDelegate <NSObject>

- (void)requestWillDealloc:(LYRequest*)request;

@end

@protocol UploadImageProgressDelegate <NSObject>

-(void)uploadImageProgress:(double)progress;

@end
