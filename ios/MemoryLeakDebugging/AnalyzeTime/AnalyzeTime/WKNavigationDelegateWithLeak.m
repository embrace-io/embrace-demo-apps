//
//  WKNavigationDelegateWithLeak.m
//  AnalyzeTime
//
//  Copyright © 2020 embrace. All rights reserved.
//

#import "WKNavigationDelegateWithLeak.h"
#import <WebKit/WebKit.h>
#import <objc/runtime.h>
#import "EMBProxy.h"

@implementation WKNavigationDelegateWithLeak

IMP originalSetDelegate;
EMBProxy *proxy;

void embSwizzledWKSetNavigationDelegate(id self, SEL _cmd, id<WKNavigationDelegate> delegate)
{
    NSLog(@"swizzled set delegate");
    proxy = [[EMBProxy alloc] initWithDelegate:delegate associatedObject:self];
    ((void (*)(id, SEL, id<WKNavigationDelegate>))originalSetDelegate)(self, _cmd, (id<WKNavigationDelegate>)proxy);
}

+ (void)load {
    SEL originalSelector = @selector(setNavigationDelegate:);
    Method originalMethod = class_getInstanceMethod([WKWebView class], originalSelector);
    originalSetDelegate = method_setImplementation(originalMethod, (IMP)embSwizzledWKSetNavigationDelegate);
}

@end
