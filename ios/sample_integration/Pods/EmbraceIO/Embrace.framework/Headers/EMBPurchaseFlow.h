//
//  EMBPurchaseFlow.h
//  Embrace
//
//  Created by Juan Pablo Crespi on 12/03/2018.
//  Copyright © 2018 embrace.io. All rights reserved.
//

#import "EMBCustomFlow.h"

/**
 This class is responsible for tracking app performance during purchase flows.
 
 This class is thread-safe.
 */
@interface EMBPurchaseFlow : EMBCustomFlow

/**
 Starts an add-to-cart app moment.

 This method should be called as soon as the user indicates an intent to add an item to their cart.

 @param itemId The ID that represents the item being added to the cart. This value is optional and, if present, will
               associate the value as a property of the moment.
 @param quantity The number of items being added to the cart. This value is optional and, if present, will associate
                 the value as a property of the moment.
 @param price The unit price of the item being added to the cart. This value is optional and, if present, will
              associate the value as a property of the moment.
 @param properties A map of Strings to Objects that represent additional properties to associate with the moment.
                   This value is optional. A maximum of 10 properties (not including the ones set via arguments to
                   this method) may be set.

 @return A moment identifier that can be used to close the add-to-cart moment. If an error was encountered, this
         method returns null.
 */
- (NSString * _Nonnull)addToCartStartWithItemId:(NSString * _Nullable)itemId quantity:(NSNumber * _Nullable)quantity price:(NSNumber * _Nullable)price properties:(NSDictionary * _Nullable)properties;

/**
 Ends a particular add-to-cart moment instance and generates an info log message that indicates that adding to the
 cart completed.

 This method should be called once the item is verified to be in the user's cart.

 @param momentId The moment identifier returned by the `PurchaseFlow.addToCartStart` method. This moment identifier
                 must be an identifier produced by this particular PurchaseFlow instance and must not have already
                 been marked as completed or failed.

 @return True if the operation was successful; false otherwise.
 */
- (BOOL)addToCartCompleteWithMomentId:(NSString * _Nonnull)momentId;

/**
 Ends a particular add-to-cart moment instance and generates an info log message that indicates that adding to the
 cart completed.

 This method should be called once the item is verified to be in the user's cart.

 @param momentId The moment identifier returned by the `PurchaseFlow.addToCartStart` method. This moment identifier
 must be an identifier produced by this particular PurchaseFlow instance and must not have already
 been marked as completed or failed.
 @param properties A map of Strings to Objects that represent additional properties to associate with the moment.
                   This value is optional. A maximum of 10 properties (not including the ones set via arguments to
                   this method) may be set.

 @return True if the operation was successful; false otherwise.
 */
- (BOOL)addToCartCompleteWithMomentId:(NSString * _Nonnull)momentId properties:(NSDictionary * _Nullable)properties;

/**
 Ends a particular add-to-cart moment instance and generates an error log message that indicates that adding to the
 cart failed.

 This method should be called when it has been determined that the item could not be added to the cart.

 @param momentId The moment identifier returned by the `PurchaseFlow.addToCartStart` method. This moment identifier
                 must be an identifier produced by this particular PurchaseFlow instance and must not have already
                 been marked as completed or failed.
 @param message A message that explains the reason for why this operation failed. This value is optional and, if
                provided, will associate the value as a property of the error log message.

 @return True if the operation was successful; false otherwise.
 */
- (BOOL)addToCartFailWithMomentId:(NSString * _Nonnull)momentId message:(NSString * _Nullable)message;

/**
 Ends a particular add-to-cart moment instance and generates an error log message that indicates that adding to the
 cart failed.

 This method should be called when it has been determined that the item could not be added to the cart.

 @param momentId The moment identifier returned by the `PurchaseFlow.addToCartStart` method. This moment identifier
 must be an identifier produced by this particular PurchaseFlow instance and must not have already
 been marked as completed or failed.
 @param message A message that explains the reason for why this operation failed. This value is optional and, if
 provided, will associate the value as a property of the error log message.
 @param properties A map of Strings to Objects that represent additional properties to associate with the moment.
                   This value is optional. A maximum of 10 properties (not including the ones set via arguments to
                   this method) may be set.

 @return True if the operation was successful; false otherwise.
 */
- (BOOL)addToCartFailWithMomentId:(NSString * _Nonnull)momentId message:(NSString * _Nullable)message properties:(NSDictionary * _Nullable)properties;

/**
 Starts a purchase moment.
 
 This method should be called as soon as the user indicates an intent to purchase the items in their cart. This
 means that all information pertaining to the order (e.g. billing, payment, shipping) should already be known prior
 to invoking this method.

 @param orderId The ID that represents the purchase order. This value is optional and, if present, will associate
                the value as a property of the moment.
 @param numItems The number of items in the purchase order. This value is optional and, if present, will associate
                 the value as a property of the moment.
 @param amount The total amount of the purchase order. This value is optional and, if present, will associate the
               value as a property of the moment.
 @param paymentType The payment system that will be fulfilling the purchase order (e.g. Google IAB, PayPal,
                    BrainTree). This value is optional and, if present, will associate the value as a property of
                    the moment.
 @param properties A map of Strings to Objects that represent additional properties to associate with the moment.
                   This value is optional. A maximum of 10 properties (not including the ones set via arguments to
                   this method) may be set.

 @return True if the operation was successful; false otherwise.
 */
- (BOOL)purchaseStartWithOrderId:(NSString * _Nullable)orderId numItems:(NSNumber * _Nullable)numItems amount:(NSNumber * _Nullable)amount paymentType:(NSString * _Nullable)paymentType properties:(NSDictionary * _Nullable)properties;

/**
 Ends the purchase moment and generates an info log message that indicates that the purchase completed.

 This method should be called once the purchase order has been confirmed.

 @return True if the operation was successful; false otherwise.
 */
- (BOOL)purchaseComplete;

/**
 Ends the purchase moment and generates an info log message that indicates that the purchase completed.

 This method should be called once the purchase order has been confirmed.

 @param properties A map of Strings to Objects that represent additional properties to associate with the moment.
                   This value is optional. A maximum of 10 properties (not including the ones set via arguments to
                   this method) may be set.

 @return True if the operation was successful; false otherwise.
 */
- (BOOL)purchaseCompleteWithProperties:(NSDictionary * _Nullable)properties;

/**
 Ends the purchase moment and generates an error log message that indicates that the purchase failed.
 
 This method should be called once the purchase order has been confirmed.
 
 @param message A message that explains the reason for why this operation failed. This value is optional and, if
                provided, will associate the value as a property of the error log message.
 
 @return True if the operation was successful; false otherwise.
 */
- (BOOL)purchaseFailWithMessage:(NSString * _Nullable)message;

/**
 Ends the purchase moment and generates an error log message that indicates that the purchase failed.

 This method should be called once the purchase order has been confirmed.

 @param message A message that explains the reason for why this operation failed. This value is optional and, if
 provided, will associate the value as a property of the error log message.
 @param properties A map of Strings to Objects that represent additional properties to associate with the moment.
                   This value is optional. A maximum of 10 properties (not including the ones set via arguments to
                   this method) may be set.

 @return True if the operation was successful; false otherwise.
 */
- (BOOL)purchaseFailWithMessage:(NSString * _Nullable)message properties:(NSDictionary * _Nullable)properties;

@end
