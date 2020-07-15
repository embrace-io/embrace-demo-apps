//
//  EMBConstants.h
//  Embrace
//
//  Created by Brian Wagner on 9/13/16.
//  Copyright © 2016 embrace.io. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef DEBUG
#define EMBLogDefaultLevel EMBLogLevelInfo
#else
#define EMBLogDefaultLevel EMBLogLevelDebug
#endif

typedef NS_ENUM(NSInteger, EMBLogLevel) {
    EMBLogLevelNone = 0,
    EMBLogLevelTrace,
    EMBLogLevelDebug,
    EMBLogLevelInfo,
    EMBLogLevelWarning,
    EMBLogLevelError
};

typedef NS_ENUM(NSInteger, EMBSeverity) {
    EMBSeverityError = 0,
    EMBSeverityWarning,
    EMBSeverityInfo
};

typedef NS_ENUM(NSInteger, EMBAppFramework) {
    EMBAppFrameworkNative = 1,
    EMBAppFrameworkReactNative,
};

typedef NSDictionary<NSString *, NSString *> EMBProperties;

extern NSString *const EMBBundleIdentifier;
