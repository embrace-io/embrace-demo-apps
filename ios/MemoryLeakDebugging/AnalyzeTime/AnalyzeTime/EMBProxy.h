//
//  EMBProxy.h
//  Embrace
//
//  Created by Juan Pablo on 21/01/2019.
//  Copyright © 2019 embrace.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMBProxy: NSProxy

@property (nonatomic, strong, readonly) id target;

- (instancetype)initWithDelegate:(id)delegate associatedObject:(id)object;

@end

@interface EMBDummyDelegate : NSObject

+ (instancetype)delegate;

@end
