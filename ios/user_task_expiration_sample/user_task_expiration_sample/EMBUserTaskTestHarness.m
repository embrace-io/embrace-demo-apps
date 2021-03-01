//
//  EMBUserTaskTestHarness.m
//  user_task_expiration_sample
//
//  Created by Eric Lanz on 2/26/21.
//

#import "EMBUserTaskTestHarness.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

IMP originalSelector_beginWithoutName;
IMP originalSelector_beginWithName;
IMP originalSelector_endTask;
dispatch_queue_t _logging_queue;

@implementation EMBUserTaskTestHarness

+ (void)load {
    _logging_queue = dispatch_queue_create("embrace.usertask.logging_queue", DISPATCH_QUEUE_SERIAL);;
    originalSelector_beginWithoutName = class_getMethodImplementation([UIApplication class], @selector(beginBackgroundTaskWithExpirationHandler:));
    method_exchangeImplementations(
                                   class_getInstanceMethod([UIApplication class], @selector(beginBackgroundTaskWithExpirationHandler:)),
                                   class_getInstanceMethod(self, @selector(beginBackgroundTaskWithExpirationHandler:))
                                   );
    originalSelector_beginWithName = class_getMethodImplementation([UIApplication class], @selector(beginBackgroundTaskWithName:expirationHandler:));
    method_exchangeImplementations(
                                   class_getInstanceMethod([UIApplication class], @selector(beginBackgroundTaskWithName:expirationHandler:)),
                                   class_getInstanceMethod(self, @selector(beginBackgroundTaskWithName:expirationHandler:))
                                   );
    originalSelector_endTask = class_getMethodImplementation([UIApplication class], @selector(endBackgroundTask:));
    method_exchangeImplementations(class_getInstanceMethod([UIApplication class], @selector(endBackgroundTask:)),
                                   class_getInstanceMethod(self, @selector(endBackgroundTask:)));
}
- (UIBackgroundTaskIdentifier)beginBackgroundTaskWithExpirationHandler:(void(^ __nullable)(void))handler {
    UIBackgroundTaskIdentifier identifier = ((UIBackgroundTaskIdentifier (*)(id, SEL, void (^ __nullable)(void)))originalSelector_beginWithoutName)(self, _cmd, handler);
    __block NSArray<NSString *> *threads = [NSThread callStackSymbols];
    dispatch_async(_logging_queue, ^{
        NSLog(@"[EMB] beginBackgroundTaskWithExpirationHandler called from %@", threads);
        NSLog(@"[EMB] handler is null? %d", (handler == nil));
        NSLog(@"[EMB] assigned identifier: %tu", identifier);
    });
    return identifier;
}
- (UIBackgroundTaskIdentifier)beginBackgroundTaskWithName:(nullable NSString *)taskName expirationHandler:(void(^ __nullable)(void))handler {
    UIBackgroundTaskIdentifier identifier = ((UIBackgroundTaskIdentifier (*)(id, SEL, NSString*, void (^ __nullable)(void)))originalSelector_beginWithName)(self, _cmd, taskName, handler);
    __block NSArray<NSString *> *threads = [NSThread callStackSymbols];
    dispatch_async(_logging_queue, ^{
        NSLog(@"[EMB] beginBackgroundTaskWithName %@: called from %@", taskName, threads);
        NSLog(@"[EMB] handler is null? %d", (handler == nil));
        NSLog(@"[EMB] assigned identifier: %tu", identifier);
    });
    return identifier;
}
- (void)endBackgroundTask:(UIBackgroundTaskIdentifier)identifier {
    __block NSArray<NSString *> *threads = [NSThread callStackSymbols];
    dispatch_async(_logging_queue, ^{
        NSLog(@"[EMB] endBackgroundTask identifier: %tu, called from: %@", identifier, threads);
    });
    ((void (*)(id, SEL, UIBackgroundTaskIdentifier))originalSelector_endTask)(self, _cmd, identifier);
}


@end
