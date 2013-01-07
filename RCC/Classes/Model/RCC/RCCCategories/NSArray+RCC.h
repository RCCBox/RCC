//
//  Created by Roberto Seidenberg
//  All rights reserved
//

// Apple
#import <Foundation/Foundation.h>

// Inherited classes
#import "RCCUbiquitousObject.h"

/**
 NSArray category providing convenience methods for dealing with RCCUbiquitousObjects.
*/

@interface NSArray(RCC)

// MARK: Utility (public)
//
// Fetching
/**
 This method must not be called directly but is beeing used by the RCCUbiquitousObjectsController class instead.
 
 @return Returns a new array containing RCCUbiquitousObject objects whose uid propertys are matching the provided string. Typically the count of this arrays equals 1. Returns nil, if no RCCUbiquitousObject was found.
 */
- (NSArray *)rccUbiquitousObjectsMatchingUID:(NSString *)uid;
/**
 This method must not be called directly but is beeing used by the RCCUbiquitousObjectsController class instead.

 @return Returns a new array containing RCCUbiquitousObject objects with a property value matching the provided value. Typically the count of this arrays equals 1. Returns nil, if no RCCUbiquitousObject was beeing found.
*/
- (NSArray *)rccUbiquitousObjectsMatchingKey:(NSString *)key forValue:(id)value;
/**
 This method must not be called directly but is beeing used by the RCCUbiquitousObjectsController class instead.
 
 @return Returns a new array containing RCCUbiquitousObject objects which are marked for deletion. Returns nil, if no RCCUbiquitousObject was beeing found.
*/
- (NSArray *)rccUbiquitousObjectsMarkedForDeletion;
//
// Tagging
//
/**
 This method must not be called directly but is beeing used by the RCCUbiquitousObjectsController class instead.
 
 Marks an object for deleletion. Objects are not removed from the store immediately but in the process of syncing.
*/
- (void)markRCCUbiquitousObjectForDeletion:(RCCUbiquitousObject *)ubiquitousObject;
//
// Validation
//
- (NSArray *)rccUbiquitousObjectInsertValidationErrors:(RCCUbiquitousObject *)ubiquitousObject ignoreObject:(RCCUbiquitousObject *)ignoredObject uniqueProperties:(NSArray *)uniqueProperties;
//
// Storage preparation
//
/**
 This method must not be called directly but is beeing used by the RCCUbiquitousObjectsController class instead.
 */
- (void)updateRCCUbiquitousObjectsTimestamps;
//
// Type conversion
//
// NSDictionary -> RCCUbiquitousObject
/**
 This method must not be called directly but is beeing used by the RCCUbiquitousObjectsController class instead.
 
 Takes an array of NSDictionary objects and initializes RCCUbiquitousObject objects with the data found in these dictionarys.
 Typically this method is beeing used to quickly transform NSDicitonary objects obtained from a key value store into type save RCCUbiquitousObject objects.
 
 @return Array of readily initialized and populated RCCUbiquitousObject objects. Nil, if an error occured.
*/
- (NSArray *)rccUbiquitousObjectsRepresentations;
/**
 This method must not be called directly but is beeing used by the RCCUbiquitousObjectsController class instead.
 
 Takes an array of RCCUbiquitousObject objects and converts their propertys to key value pairs which are beeing stored in a NSDictionary.
 Typically this method is beeing used to quickly transform RCCUbiquitousObject objects to their NSDictionary represantations in order to store them in a key value store.
 
 @return Array of NSDictioanary objects. Nil, if an error occured.
 */

//
// RCCUbiquitousObject -> NSDictionary
- (NSArray *)dictionaryRepresentations;
@end