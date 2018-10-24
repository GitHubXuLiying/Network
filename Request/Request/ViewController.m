//
//  ViewController.m
//  Request
//
//  Created by xly on 2018/10/18.
//  Copyright © 2018年 Xly. All rights reserved.
//

#import "ViewController.h"
#import "JDRequest.h"
#import "LYGroupRequest.h"
#import "NSDictionary+LYAddtion.h"

@interface ViewController ()

@property (nonatomic, strong) JDRequest *request;
@property (nonatomic, strong) LYGroupRequest *groupRequest;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  

    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)request:(id)sender {
//    if (_request == nil) {
//        _request = [JDRequest postRequstWithURL:@"meituApi" params:@{@"page" : @"1"} successBlock:^(LYRequest *request) {
//            NSLog(@"xly--%@",request.responseObject);
//            NSLog(@"xly--%@",@"1111111222222");
//        } failureBlock:^(LYRequest *request) {
//            NSLog(@"xly--%@",request.error);
//        }];
//    }
//    for (int i =0 ; i < 5; i ++) {
//        [_request resume];
//    }
    
    LYRequest *request  = [JDRequest postRequstWithURL:@"meituApi" params:@{@"page" : @"1"} successBlock:^(LYRequest *request) {
        NSLog(@"xly--%@",request.responseObject);
        NSLog(@"xly--%@",@"1111111222222");
    } failureBlock:^(LYRequest *request) {
        NSLog(@"xly--%@",request.error);
    }];
    request.cache = YES;
    request.useCache = YES;
    request.httpHeaders = @{@"a":@"test"};
    
    LYRequest *request1  = [JDRequest postRequstWithURL:@"meituApi" params:@{@"page" : @"1"} successBlock:^(LYRequest *request) {
        NSLog(@"xly--%@",request.responseObject);
        NSLog(@"xly--%@",@"1111111222222");
    } failureBlock:^(LYRequest *request) {
        NSLog(@"xly--%@",request.error);
    }];
    request1.ignoreExistRequest = YES;
    
    LYRequest *request2  = [JDRequest postRequstWithURL:@"meituApi" params:@{@"page" : @"1"} successBlock:^(LYRequest *request) {
        NSLog(@"xly--%@",request.responseObject);
        NSLog(@"xly--%@",@"1111111222222");
    } failureBlock:^(LYRequest *request) {
        NSLog(@"xly--%@",request.error);
    }];
//    request2.ignoreExistRequest = YES;

    [request resume];
//    [request1 resume];
//    [request2 resume];
}

- (IBAction)groupRequest:(id)sender {
    if (_groupRequest == nil) {
        NSMutableArray *requests = [NSMutableArray array];
        [requests addObject:[JDRequest postRequstWithURL:@"satinApi" params:@{@"type" : @"1",@"page" : @"1"} successBlock:^(LYRequest *request) {
            NSLog(@"xly--%@",request.responseObject);
        } failureBlock:^(LYRequest *request) {
            NSLog(@"xly--%@",request.error);
        }]];
        [requests addObject:[JDRequest postRequstWithURL:@"journalismApi" params:nil successBlock:^(LYRequest *request) {
            NSLog(@"xly--%@",request.responseObject);
        } failureBlock:^(LYRequest *request) {
            NSLog(@"xly--%@",request.error);
        }]];//id=27610708&page=1
        [requests addObject:[JDRequest postRequstWithURL:@"satinCommentApi" params:@{@"id" : @"27610708",@"page" : @"1"} successBlock:^(LYRequest *request) {
            NSLog(@"xly--%@",request.responseObject);
        } failureBlock:^(LYRequest *request) {
            NSLog(@"xly--%@",request.error);
        }]];
        [requests addObject:[JDRequest postRequstWithURL:@"satinCommentApi" params:@{@"id" : @"27610708",@"page" : @"1"} successBlock:^(LYRequest *request) {
            NSLog(@"xly--%@",request.responseObject);
        } failureBlock:^(LYRequest *request) {
            NSLog(@"xly--%@",request.error);
        }]];
        _groupRequest = [[LYGroupRequest alloc] initWithRequests:requests completed:^(NSArray *requests) {
            NSLog(@"xly--%@",@"全部请求完成回调");
        }];
    }
    [_groupRequest resume];
}



@end
