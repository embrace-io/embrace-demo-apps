//
//  ViewController.m
//  RecipeTime
//
//  Copyright © 2020 embrace. All rights reserved.
//

#import "ViewController.h"

@interface MyNavigationDelegate : NSObject <WKNavigationDelegate>

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;

@end

@implementation MyNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSLog(@"decision handler called");
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end

@interface ViewController ()

@property (nonatomic, strong) MyNavigationDelegate *navDelegate;
@property (nonatomic, strong) WKWebView *webview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _navDelegate = [MyNavigationDelegate new];
    
    NSString *urlAsString = @"https://www.allrecipes.com/recipe/25969/blueberry-pound-cake";
    NSURL *urlA = [NSURL URLWithString:urlAsString];
    urlAsString = @"https://www.allrecipes.com/recipe/72747/blueberry-lemon-pound-cake/";
    NSURL *urlB = [NSURL URLWithString:urlAsString];
    __block bool useA = true;
    
    [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSURLRequest *request;
        if (useA) {
             request = [NSURLRequest requestWithURL:urlA];
            useA = false;
        } else {
            request = [NSURLRequest requestWithURL:urlB];
            useA = true;
        }
        [self.webview removeFromSuperview];
        self.webview = nil;
        
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        self.webview = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
        [self.view addSubview:self.webview];
        [self.webview setNavigationDelegate:self.navDelegate];
        
        [self.webview loadRequest:request];
    }];
}

@end
