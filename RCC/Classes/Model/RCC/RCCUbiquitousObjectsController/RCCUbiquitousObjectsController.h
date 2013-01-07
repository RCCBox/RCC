//
//  Created by Roberto Seidenberg
//  All rights reserved
//

// Apple
#import <Foundation/Foundation.h>

// Inherited classes
#import "NSArray+RCC.h"
#import "NSMutableArray+RCC.h"
#import "RCCUbiquitousObject.h"

/**
 The RCCUbiquitousObjectsController acts as the only interface to the NSUbiquitousKeyValueStore and NSUserDefaults store.
 Dealing with any other class apart from RCCUbiquitousObject or its subclasses and RCCUbiquitousObjectsController for accessing the store is obsolete.
 All data is beeing stored in the RCCUbiquitousObject class and the beeing manipulated using RCCUbiquitousObjectsController methods.
 RCCUbiquitousObjectsController handles subscriptions to the UINotificationCentre automatically.
 An ubiquitousObjects property is beeing exposed which can be observed in order to react on changes of the data store.
*/

@interface RCCUbiquitousObjectsController : NSObject
@property (strong) NSArray *ubiquitousObjects;
@property (nonatomic, copy) NSComparator sortComparator;

// MARK: Init
//
/**
 Initialises an RCCUbiquitousObjectsController object.
 
 @return Newly initialized RCCUbiquitousObjectsController object.
*/
- (id)init;
/**
 Initialises an RCCUbiquitousObjectsController object with an NSComparator block objects for sorting the ubiquitousObjects array property.
 
 @param NSComparator block. This value must not be nil.
 @return Newly initialized RCCUbiquitousObjectsController object.
*/
- (id)initWithSortComparator:(NSComparator)comparator;
/**
 Initialises an RCCUbiquitousObjectsController object with a custom key for the stored data.
 When initialized with -(id)init the data is beeing stored as an array with the default key name.
 By using this method NSUbiquitousKeyValueStore as well as NSUserDefaults use the custom provided key.
 This is useful for unit testing the class.
 
 @param NSString store key. This value must not be nil.
 @return Newly initialized RCCUbiquitousObjectsController object.
 */
- (id)initWithStoreKey:(NSString *)key;
/**
 Initialises an RCCUbiquitousObjectsController object with a custom key for the stored data and an NSComparator block objects for sorting the ubiquitousObjects array property.

 @param NSString store key. This value must not be nil.
 @param NSComparator block. This value must not be nil.
 @return Newly initialized RCCUbiquitousObjectsController object.
 */
- (id)initWithStoreKey:(NSString *)key andSortComparator:(NSComparator)comparator;

// MARK: Utility (public)
// Validation
//
/**
 Determines whether the receiver can be inserted in a local or synced store in its current state.
 
 @return NSArray of NSError objects containing a localized error description and a pointer to the invalid object (key: "invalidObject") in the userInfo dictionary.
 */
- (NSArray *)validateRCCUbiquitousObjectForInsert:(RCCUbiquitousObject *)ubiquitousObject;
//
// Persisting
//
/**
 Adds the provided RCCUbiquitousObject subclass to the available persistant store (NSUbiquitousKeyValueStore or NSUserDefaults).
 
 When adding a RCCUbiquitousObject object that do not own a unique uid the most recent objects are beeing kept.

 Use this method to make sure the object to be inserted is valid.
	- (NSArray *)validateRCCUbiquitousObjectForInsert:(RCCUbiquitousObject *)ubiquitousObject
 
 @param RCCUbiquitousObject object. This argument must not be nil.
 @return YES if the in-memory and on-disk keys and values were synchronized, or NO if an error occurred. For example, this method returns NO if an app was not built with the proper entitlement requests.
*/
- (BOOL)storeRCCUbiquitousObject:(RCCUbiquitousObject *)ubiquitousObject;
/**
 Adds the provided RCCUbiquitousObject to the available persistant store (NSUbiquitousKeyValueStore or NSUserDefaults).
 
 When adding RCCUbiquitousObject objects that do not own a unique uid the most recent objects are beeing kept.

 Use this method to make sure the object to be inserted is valid.
	- (NSArray *)validateRCCUbiquitousObjectForInsert:(RCCUbiquitousObject *)ubiquitousObject
 
 @param Array of RCCUbiquitousObject objects. This argument must not be nil.
 @return YES if the in-memory and on-disk keys and values were synchronized, or NO if an error occurred. For example, this method returns NO if an app was not built with the proper entitlement requests.
 */

- (BOOL)storeRCCUbiquitousObjects:(NSArray *)objects;
//
// Deletion
//
/**
 Removes the reciver from the persistent store.
 @param RCCUbiquitousObject object. This value must not be nil.
 */
-(void)removeRCCUbiquitousObject:(RCCUbiquitousObject *)ubiquitousObject;
@end