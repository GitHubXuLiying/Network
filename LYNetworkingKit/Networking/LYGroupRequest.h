//
//  LYGroupRequestManager.h
//  Request
//
//  Created by xly on 2018/10/22.
//  Copyright © 2018年 Xly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYRequest.h"
#import "LYRequestDefine.h"

NS_ASSUME_NONNULL_BEGIN


@interface LYGroupRequest : NSObject

- (instancetype)initWithRequests:(NSArray *)requests completed:(nonnull LYGroupRequestCompletedBlock)block;

- (void)resume;
- (void)cancel;

- (NSArray *)groupRequests;

@end

NS_ASSUME_NONNULL_END
