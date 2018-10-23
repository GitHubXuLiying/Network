//
//  JDRequest.m
//  Request
//
//  Created by xly on 2018/10/23.
//  Copyright © 2018年 Xly. All rights reserved.
//

#import "JDRequest.h"

@implementation JDRequest

- (void)initDefaultConfig {
    [super initDefaultConfig];
    
    self.baseURL = @"https://xwapi.jindanlicai.com/";
    self.defaultParams = @{
                           @"version": @"3",
                           @"statics": @{
                                   @"system_name": @"iOS",
                                   @"sign": @"b7cc301ea157879e9732321467af9ed2",
                                   @"version": @"6.6.0",
                                   @"system_version": @"12.0",
                                   @"channel": @"appstore",
                                   @"push_channelid": @"5701168688462085271",
                                   @"push_server": @"product",
                                   @"idfa": @"3468409A-2EB5-42B2-8BF1-56B6A909FE32",
                                   @"timestamp": @"1540277564",
                                   @"display": @"{375, 667}",
                                   @"os": @"iOS 12.0",
                                   @"jpush_channelid": @"171976fa8aa4069fc9f",
                                   @"salt": @"8VC4z1pETT",
                                   @"device_name": @"iPhone",
                                   @"ua": @"gucci",
                                   @"udid": @"ee70f320f094471da72635f8138bfef0"
                                   }
                           
                           };
    self.requestType = LYRequestTypeJSON;
}

@end
