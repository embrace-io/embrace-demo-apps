//
//  EMBCustomFlow.h
//  Embrace
//
//  Created by Juan Pablo Crespi on 09/03/2018.
//  Copyright © 2018 embrace.io. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Base class for creating custom domain-specific flows that are essentially convenience wrappers around existing SDK
 functionality.
 */

@interface EMBCustomFlow : NSObject

+ (instancetype _Nonnull)flow;

/**
 Starts a custom moment.
 
 @param momentName The name of the moment.
 @param allowScreenshot If true, a screenshot will be taken if the moment exceeds the late threshold. If this
                        value is false, a screenshot will be not be taken regardless of the moment duration.
 @param properties A map of Strings to Objects that represent additional properties to associate with the moment.
                   This value is optional. A maximum of 10 properties may be set.
 
 @return A moment identifier that uniquely identifies the newly started moment instance.
 */
- (NSString * _Nullable)momentStartWithName:(NSString * _Nonnull)momentName allowScreenshot:(BOOL)allowScreenshot properties:(NSDictionary * _Nullable)properties;

/**
 Completes all started instances of the specified custom moment.

 Note that only moment instances managed by this Flow object will be completed. In other words, if another Flow
 instance starts a moment with the same name, completing the moment on this instance will not affect it.

 @param momentName The name of the moment.

 @return True if the operation was successful; false otherwise.
 */
- (BOOL)momentCompleteWithName:(NSString * _Nonnull)momentName;

/**
 Completes all started instances of the specified custom moment.

 Note that only moment instances managed by this Flow object will be completed. In other words, if another Flow
 instance starts a moment with the same name, completing the moment on this instance will not affect it.

 @param momentName The name of the moment.
 @param properties A map of Strings to Objects that represent additional properties to associate with the moment.
                   This value is optional. A maximum of 10 properties may be set.

 @return True if the operation was successful; false otherwise.
 */
- (BOOL)momentCompleteWithName:(NSString * _Nonnull)momentName properties:(NSDictionary * _Nullable)properties;

/**
 Completes a started instance of the custom moment specified by the moment identifier.

 Note that only moment instances managed by this Flow object will be completed. In other words, if another Flow
 instance starts a moment with the same name, completing the moment on this instance will not affect it.

 @param momentName The name of the moment.
 @param momentId The optional moment identifier returned by the `momentStart` method. This moment identifier must be
                 an identifier produced by this particular Flow instance that has not already been completed or
                 failed. This value can also be null, in which case all instances of the given moment name
                 registered with this Flow instance will be completed.

 @return True if the operation was successful; false otherwise.
 */
- (BOOL)momentCompleteWithName:(NSString * _Nonnull)momentName momentId:(NSString * _Nullable)momentId;

/**
 Completes a started instance of the custom moment specified by the moment identifier.

 Note that only moment instances managed by this Flow object will be completed. In other words, if another Flow
 instance starts a moment with the same name, completing the moment on this instance will not affect it.

 @param momentName The name of the moment.
 @param momentId The optional moment identifier returned by the `momentStart` method. This moment identifier must be
 an identifier produced by this particular Flow instance that has not already been completed or
 failed. This value can also be null, in which case all instances of the given moment name
 registered with this Flow instance will be completed.
 @param properties A map of Strings to Objects that represent additional properties to associate with the moment.
                   This value is optional. A maximum of 10 properties may be set.

 @return True if the operation was successful; false otherwise.
 */
- (BOOL)momentCompleteWithName:(NSString * _Nonnull)momentName momentId:(NSString * _Nullable)momentId properties:(NSDictionary * _Nullable)properties;

/**
 Fails all started instances of the specified custom moment and generates an error log message for each failed
 moment instance.
 
 Note that only moment instances managed by this Flow object will be failed. In other words, if another Flow
 instance fails a moment with the same name, failing the moment on this instance will not affect it.
 
 @param momentName The name of the moment.
 @param message A message that explains the reason for why this operation failed. This value is optional and, if
                provided, will associate the value as a property of the error log message.
 
 @return True if the operation was successful; false otherwise.
 */
- (BOOL)momentFailWithName:(NSString * _Nonnull)momentName message:(NSString * _Nullable)message;

/**
 Fails all started instances of the specified custom moment and generates an error log message for each failed
 moment instance.

 Note that only moment instances managed by this Flow object will be failed. In other words, if another Flow
 instance fails a moment with the same name, failing the moment on this instance will not affect it.

 @param momentName The name of the moment.
 @param message A message that explains the reason for why this operation failed. This value is optional and, if
 provided, will associate the value as a property of the error log message.
 @param properties A map of Strings to Objects that represent additional properties to associate with the moment.
                   This value is optional. A maximum of 10 properties may be set.

 @return True if the operation was successful; false otherwise.
 */
- (BOOL)momentFailWithName:(NSString * _Nonnull)momentName message:(NSString * _Nullable)message properties:(NSDictionary * _Nullable)properties;

/**
 Fails a started instance of the custom moment specified by the moment identifier and sends an error log message for
 the failed moment instance.
 
 Note that only moment instances managed by this Flow object will be failed. In other words, if another Flow
 instance fails a moment with the same name, failing the moment on this instance will not affect it.
 
 @param momentName The name of the moment.
 @param momentId The optional moment identifier returned by the `momentStart` method. This moment identifier must be
                 an identifier produced by this particular Flow instance that has not already been completed or
                 failed. This value can also be null, in which case all instances of the given moment name
                 registered with this Flow instance will be completed.
 @param message A message that explains the reason for why this operation failed. This value is optional and, if
                provided, will associate the value as a property of the error log message.
 
 @return True if the operation was successful; false otherwise.
 */
- (BOOL)momentFailWithName:(NSString * _Nonnull)momentName momentId:(NSString * _Nullable)momentId message:(NSString * _Nullable)message;

/**
 Fails a started instance of the custom moment specified by the moment identifier and sends an error log message for
 the failed moment instance.

 Note that only moment instances managed by this Flow object will be failed. In other words, if another Flow
 instance fails a moment with the same name, failing the moment on this instance will not affect it.

 @param momentName The name of the moment.
 @param momentId The optional moment identifier returned by the `momentStart` method. This moment identifier must be
 an identifier produced by this particular Flow instance that has not already been completed or
 failed. This value can also be null, in which case all instances of the given moment name
 registered with this Flow instance will be completed.
 @param message A message that explains the reason for why this operation failed. This value is optional and, if
 provided, will associate the value as a property of the error log message.
 @param properties A map of Strings to Objects that represent additional properties to associate with the moment.
                   This value is optional. A maximum of 10 properties may be set.

 @return True if the operation was successful; false otherwise.
 */
- (BOOL)momentFailWithName:(NSString * _Nonnull)momentName momentId:(NSString * _Nullable)momentId message:(NSString * _Nullable)message properties:(NSDictionary * _Nullable)properties;

@end
