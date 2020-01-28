//
//  EMBProxy.m
//  Embrace
//
//  Copyright © 2019 embrace.io. All rights reserved.
//

#import "EMBProxy.h"
#import <objc/runtime.h>
#import <WebKit/WebKit.h>

@interface EMBProxy()

@property (nonatomic, strong) NSString *targetClassName;

@end

@implementation EMBProxy

# pragma mark - Public methods

- (instancetype)initWithDelegate:(id)delegate associatedObject:(id)object
{
    if (delegate) {
        _target = delegate;
        _targetClassName = NSStringFromClass([delegate class]);
        // We need to keep this proxy object around for the lifetime of the associated object.
        // To do this we associate the proxy with the object using the address of the created proxy
        // object as the unique key here. When object goes away so will the forwarder.
        objc_setAssociatedObject(object, (__bridge const void *)(self), self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return self;
}

# pragma mark - NSProxy override methods

static NSMutableArray *webviewMemoryLeaker;

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        webviewMemoryLeaker = [NSMutableArray array];
    });
    NSLog(@"decision handler called");
    [webviewMemoryLeaker addObject:webView];
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL selector = [invocation selector];
    NSLog(@"[%@] %@: Selector: %@",
                _targetClassName,
                NSStringFromSelector(_cmd),
                NSStringFromSelector(selector));
    if (self.target) {
        if ([self.target respondsToSelector:selector] == false) {
            NSLog(@"%@ does not implement selector: %@",
                        _targetClassName,
                        NSStringFromSelector(selector));
        }
        // If we still have the target around then forward it on, otherwise drop it.
        [invocation invokeWithTarget:self.target];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSLog(@"[%@] %@: Selector: %@",
                _targetClassName,
                NSStringFromSelector(_cmd),
                NSStringFromSelector(selector));
    if (self.target) {
        if ([self.target respondsToSelector:selector] == false) {
            NSLog(@"%@ does not implement selector: %@",
                        _targetClassName,
                        NSStringFromSelector(selector));
        }
        // We still have the target so have it return the selector signature
        NSMethodSignature *sig = [self.target methodSignatureForSelector:selector];
        // Some frameworks use quasi-proxy objects to intercept delegate calls.  In those cases the proxy
        // may not return a valid method signature even though the proxied object does respond to the selector.
        // In that case we can attempt to call through to our target's forwarding target and see if it
        // can return a signature instead.  
        if (sig == nil && [self.target respondsToSelector:@selector(forwardingTargetForSelector:)]) {
            id forwardingTarget = [self.target forwardingTargetForSelector:selector];
            if (forwardingTarget) {
                sig = [forwardingTarget methodSignatureForSelector:selector];
            }
        }
        return sig;
    }
    Class targetClass = NSClassFromString(_targetClassName);
    if (targetClass) {
        // Target has been dealloc'ed. Return the signature using the class so we don't throw an exception
        return [targetClass instanceMethodSignatureForSelector:selector];
    }
    return nil;
}

# pragma mark - NSObject protocol methods

- (NSUInteger)hash
{
    NSUInteger result = self.target ? [self.target hash] : 0;
    NSLog(@"[%@] Method: %@ Result: %zd",
                _targetClassName,
                NSStringFromSelector(_cmd),
                result);
    return result;
}

- (Class)class
{
    Class result = self.target ? [self.target class] : nil;
    NSLog(@"[%@] Method: %@ Result: %@",
                _targetClassName,
                NSStringFromSelector(_cmd),
                NSStringFromClass(result));
    return result;
}

- (Class)superclass
{
    Class result = self.target ? [self.target superclass] : nil;
    NSLog(@"[%@] Method: %@ Result: %@",
                _targetClassName,
                NSStringFromSelector(_cmd),
                NSStringFromClass(result));
    return result;
}

- (NSString *)description
{
    NSString *result = self.target ? [self.target description] : nil;
    NSLog(@"[%@] Method: %@ Result: %@",
                _targetClassName,
                NSStringFromSelector(_cmd),
                result);
    return result;
}

- (NSString *)debugDescription
{
    NSString *result = self.target ? [self.target debugDescription] : nil;
    NSLog(@"[%@] Method: %@ Result: %@",
                _targetClassName,
                NSStringFromSelector(_cmd),
                result);
    return result;
}

- (BOOL)isEqual:(id)object
{
    BOOL result = self.target ? [self.target isEqual:object] : false;
    NSLog(@"[%@] %@: %@ Result: %i",
                _targetClassName,
                NSStringFromSelector(_cmd),
                NSStringFromClass([object class]),
                result);
    return result;
}

- (BOOL)isProxy
{
    BOOL result = true;
    NSLog(@"[%@] Method: %@ Result: %@",
                _targetClassName,
                NSStringFromSelector(_cmd),
                @(result));
    return result;
}

- (BOOL)isKindOfClass:(Class)aClass
{
    BOOL result = self.target ? [self.target isKindOfClass:aClass] : false;
    NSLog(@"[%@] %@: %@ Result: %i",
                _targetClassName,
                NSStringFromSelector(_cmd),
                NSStringFromClass(aClass),
                result);
    return result;
}

- (BOOL)isMemberOfClass:(Class)aClass
{
    BOOL result = self.target ? [self.target isMemberOfClass:aClass] : false;
    NSLog(@"[%@] %@: %@ Result: %i",
                _targetClassName,
                NSStringFromSelector(_cmd),
                NSStringFromClass(aClass),
                result);
    return result;
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
    BOOL result = self.target ? [self.target conformsToProtocol:aProtocol] : false;
    NSLog(@"[%@] %@: %@ Result: %i",
                _targetClassName,
                NSStringFromSelector(_cmd),
                NSStringFromProtocol(aProtocol),
                result);
    return result;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    BOOL result = self.target ? [self.target respondsToSelector:aSelector] : false;
    NSLog(@"[%@] %@: %@ Result: %i",
                _targetClassName,
                NSStringFromSelector(_cmd),
                NSStringFromSelector(aSelector),
                result);
    return result;
}

- (void)dealloc
{
    NSLog(@"[%@] Method: %@",
                _targetClassName,
                NSStringFromSelector(_cmd));
}

@end

@implementation EMBDummyDelegate

+ (instancetype)delegate
{
    return [[self alloc] init];
}

@end
