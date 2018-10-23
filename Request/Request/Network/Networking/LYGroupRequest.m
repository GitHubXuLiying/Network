//
//  LYGroupRequestManager.m
//  Request
//
//  Created by xly on 2018/10/22.
//  Copyright © 2018年 Xly. All rights reserved.
//

#import "LYGroupRequest.h"

@interface LYGroupRequest ()

@property (nonatomic, strong) NSArray *requests;
@property (nonatomic, copy) LYGroupRequestCompletedBlock completedBlock;
@property (nonatomic, strong) id obv;
@property (nonatomic, assign) BOOL first;

@end


@implementation LYGroupRequest

- (void)dealloc {
    NSLog(@"*****************************xly--%@",@"dealloc");
}

- (void)lyRequestDidFinish:(NSNotification *)notification {
    if ([self allCompleted]) {
        if (self.completedBlock) {
            self.completedBlock(self.requests);
        }
        [[NSNotificationCenter defaultCenter] removeObserver:self.obv];
        self.obv = nil;
    }
}

- (BOOL)allCompleted {
    for (LYRequest *req in self.requests) {
        if (req.finished == NO) {
            return NO;
        }
    }
    return YES;
}

- (instancetype)initWithRequests:(NSArray *)requests completed:(nonnull LYGroupRequestCompletedBlock)block {
    if (self = [super init]) {
        self.requests = requests;
        self.completedBlock = block;
        _first = YES;
    }
    return self;
}

- (void)resume {
    if (self.requests && self.requests.count && ([self allCompleted] || _first)) {
        _first = NO;
        self.obv =  [[NSNotificationCenter defaultCenter] addObserverForName:KLYRequestDidFinish object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            [self lyRequestDidFinish:note];
        }];
        for (LYRequest *request in self.requests) {
            [request resume];
        }
    } else {
        NSLog(@"xly--%@",@"正在请求");
    }
}

@end
