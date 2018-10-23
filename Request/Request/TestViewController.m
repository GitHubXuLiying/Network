//
//  TestViewController.m
//  Request
//
//  Created by xly on 2018/10/19.
//  Copyright © 2018年 Xly. All rights reserved.
//

#import "TestViewController.h"
#import "JDRequest.h"
#import "LYGroupRequest.h"

@interface TestViewController ()

@property (nonatomic, strong) LYRequest *request;

@end

@implementation TestViewController

- (void)dealloc {
    NSLog(@"xly--%@",@"11111222222333333");
//    [RequestHandle cancelRequest:self.request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];

    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
   JDRequest *request = [JDRequest postRequstWithURL:@"v18" params:@{
@"fun": @{
           @"productList": @{}
       }} successBlock:^(LYRequest *request) {
        NSLog(@"xly--%@",@"suc");
    } failureBlock:^(LYRequest *request) {
        NSLog(@"xly--%@",@"fail");
    }];
    [request resume];
    
//    __weak typeof(self) weakSelf = self;
//    static NSInteger count = 0;
//
//    NSMutableArray *arr = [NSMutableArray array];
//    for (NSInteger i = 0; i < 5; i ++) {
//        LYRequest *request = [LYRequest postRequstWithURL:@"https://www.kuaikuaidai.com/app/index.do" params:nil successBlock:^(LYRequest *request) {
//            NSLog(@"xly--%@",@"suc");
//            NSLog(@"________xly--%ld",i);
//            weakSelf.view.backgroundColor = [UIColor blueColor];
//        } failureBlock:^(LYRequest *request) {
//            NSLog(@"xly--%@",@"fail");
//        }];
//        [arr addObject:request];
//    }
//
//   LYGroupRequest *req = [[LYGroupRequest alloc] initWithRequests:arr completed:^(NSArray *requests) {
//
//    }];
//    [req resume];
//
//
//    if (count >= 6) {
//
//            [self dismissViewControllerAnimated:YES completion:nil];
//
//    }
//    count ++;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
