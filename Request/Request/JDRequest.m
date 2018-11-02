//
//  JDRequest.m
//  Request
//
//  Created by xly on 2018/10/23.
//  Copyright © 2018年 Xly. All rights reserved.
//

#import "JDRequest.h"

@implementation JDRequest

- (void)initConfig {
    [super initConfig];
    
    self.baseURL = @"https://www.apiopen.top/";
    self.defaultParams = @{
                        
                           };
    self.requestType = LYRequestTypeJSON;
}

@end
