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
