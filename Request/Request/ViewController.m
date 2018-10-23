//
//  ViewController.m
//  Request
//
//  Created by xly on 2018/10/18.
//  Copyright © 2018年 Xly. All rights reserved.
//

#import "ViewController.h"
#import "LYRequest.h"
#import "TestViewController.h"


@interface ViewController ()

@property (nonatomic, strong) LYRequest *request;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   

    // Do any additional setup after loading the view, typically from a nib.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self presentViewController:[TestViewController new] animated:YES completion:nil];

}


@end
