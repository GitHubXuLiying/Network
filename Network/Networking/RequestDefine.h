//
//  RequestDefine.h
//  afnet
//
//  Created by xuliying on 16/2/22.
//  Copyright © 2016年 xly. All rights reserved.
//

#ifndef RequestDefine_h
#define RequestDefine_h
@class Request;
typedef enum {
    Get = 1,
    Post
} RequestMethod;

typedef void (^RequestSucBlock)(Request *request);
typedef void (^RequestFailBlock)(Request *request);

typedef void (^PostImageSucBlock)(Request *request);
typedef void (^PostImageFailBlock)(Request *request);

#endif /* RequestDefine_h */
