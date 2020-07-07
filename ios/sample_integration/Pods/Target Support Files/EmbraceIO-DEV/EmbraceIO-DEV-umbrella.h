#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "ActivityStreamAPI.h"
#import "CrashRecording.h"
#import "EMBActivity.h"
#import "EMBAPIConstants.h"
#import "EMBAppDelegate.h"
#import "EMBAppStateManager.h"
#import "EMBBinaryImageManager.h"
#import "EMBBreadcrumb.h"
#import "EMBBreadcrumbCommon.h"
#import "EMBBreadcrumbManager.h"
#import "EMBConfigManager.h"
#import "EMBConstants.h"
#import "EMBCrashlyticsWrapper.h"
#import "EMBCrashManager.h"
#import "EMBCustomFlow+Protected.h"
#import "EMBCustomFlow.h"
#import "EMBDebugConstants.h"
#import "EMBDevice.h"
#import "EMBDeviceCommon.h"
#import "EMBEvent.h"
#import "EMBFile.h"
#import "EMBFileAppender.h"
#import "EMBFileContainer.h"
#import "EMBFileManager.h"
#import "EMBFileOverwriter.h"
#import "EMBFileRingBuffer.h"
#import "EMBFileStreaming+Private.h"
#import "EMBFileStreaming.h"
#import "EMBInterval.h"
#import "EMBJsException.h"
#import "EMBLaunchOptions.h"
#import "EMBLogger.h"
#import "EMBManager.h"
#import "EMBMemoryCommon.h"
#import "EMBMemoryManager.h"
#import "EMBMemorySample.h"
#import "EMBNetworkBodyRule.h"
#import "EMBNetworkCommon.h"
#import "EMBNetworkDomain.h"
#import "EMBNetworkManager.h"
#import "EMBNetworkMetrics.h"
#import "EMBNetworkPerformance.h"
#import "EMBNetworkRequest+Protected.h"
#import "EMBNetworkRequest.h"
#import "EMBNetworkUtils.h"
#import "EMBOSLogManager.h"
#import "EMBPersistentList.h"
#import "EMBPersistentMap.h"
#import "EMBPowerCommon.h"
#import "EMBPowerManager.h"
#import "EMBPrivateConstants.h"
#import "EMBProcessCommon.h"
#import "EMBProcessManager.h"
#import "EMBPropertyUtils.h"
#import "EMBProxy.h"
#import "EMBPurchaseFlow.h"
#import "Embrace+Protected.h"
#import "Embrace.h"
#import "EmbraceConfig.h"
#import "EMBReachability.h"
#import "EMBRegistrationFlow.h"
#import "EMBRepresentable.h"
#import "EMBScreenshotManager.h"
#import "EMBSDKConfig.h"
#import "EMBSerializable.h"
#import "EMBSerializableObject.h"
#import "EMBSerializedGroup.h"
#import "EMBServer.h"
#import "EMBSession.h"
#import "EMBSessionCommon.h"
#import "EMBSessionInfo.h"
#import "EMBSessionManager.h"
#import "EMBSessionProperties.h"
#import "EMBShortSession.h"
#import "EMBStackTraceUtils.h"
#import "EMBStateCommon.h"
#import "EMBStreamable.h"
#import "EMBStreamingBreadcrumbManager.h"
#import "EMBStreamingDeviceManager.h"
#import "EMBStreamingFileManager.h"
#import "EMBStreamingMemoryManager.h"
#import "EMBStreamingNetworkManager.h"
#import "EMBStreamingObject.h"
#import "EMBStreamingPowerManager.h"
#import "EMBStreamingProcessManager.h"
#import "EMBStreamingSessionContainer.h"
#import "EMBStreamingSessionManager.h"
#import "EMBStreamingStateManager.h"
#import "EMBStreamingUserManager.h"
#import "EMBSubscriptionPurchaseFlow.h"
#import "EMBSystemEvent.h"
#import "EMBSystemUtils.h"
#import "EMBThreadSafeDictionary.h"
#import "EMBURLConnectionProxy.h"
#import "EMBURLSessionProxy.h"
#import "EMBUser.h"
#import "EMBUserCommon.h"
#import "EMBUserManager.h"
#import "EMBV3MigrationManager.h"
#import "EMBViewStack.h"
#import "EMBWebView.h"
#import "EMBWKNavigationProxy.h"
#import "NSData+Embrace.h"
#import "NSDate+Embrace.h"
#import "NSError+Embrace.h"
#import "NSHTTPURLResponse+Embrace.h"
#import "NSObject+Embrace.h"
#import "NSString+Embrace.h"
#import "NSURLConnection+Embrace.h"
#import "NSURLRequest+Embrace.h"
#import "NSURLSession+Embrace.h"
#import "NSUUID+Embrace.h"
#import "RNEmbrace.h"
#import "UIViewController+Embrace.h"
#import "UIWindow+Embrace.h"
#import "KSCrash.h"
#import "KSCrashC.h"
#import "KSCrashReportWriter.h"
#import "KSCrashReportFields.h"
#import "KSCrashMonitorType.h"
#import "KSCrashReportFilter.h"

FOUNDATION_EXPORT double EmbraceVersionNumber;
FOUNDATION_EXPORT const unsigned char EmbraceVersionString[];
