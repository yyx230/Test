//
//  WebShowViewController.m
//  VinTest
//
//  Created by kingpoint on 14-8-15.
//  Copyright (c) 2014年 kingpoint. All rights reserved.
//

#import "WebShowViewController.h"

@interface WebShowViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebShowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"白卡号码详情" ofType:@"html"];
    NSString *mainBundleDirectory=[[NSBundle mainBundle] bundlePath];
    NSString *filePath=[mainBundleDirectory stringByAppendingPathComponent:@"html/index.html"];
    NSLog(@"%@  \n%@", mainBundleDirectory, filePath);
    if (filePath) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
