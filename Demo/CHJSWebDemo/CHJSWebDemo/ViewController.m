//
//  ViewController.m
//  CHJSWebDemo
//
//  Created by Jiao Liu on 4/27/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "ViewController.h"
#import <CHJSWebViewLib/CHJSWebView.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CHJSWebView *webView = [[CHJSWebView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 20)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"html"];
    [webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initFileURLWithPath:path]]];
    [webView addBlockPrefix:@"http://com.changhong.native.async/"];
//    [webView setNetworkCallbackBlock:^(NSURLResponse *response, NSData *data, NSError *connectionError, NSDictionary *otherInfo) {
//        
//    }];
//    [webView setActionSheetCallbackBlock:^(id action) {
//        NSLog(@"%@",action);
//    }];
//    [webView setAlertviewCallbackBlock:^(id action) {
//        NSLog(@"%@",action);
//    }];
    [self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
