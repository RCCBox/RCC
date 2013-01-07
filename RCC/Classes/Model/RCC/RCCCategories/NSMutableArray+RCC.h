//
//  Created by Roberto Seidenberg
//  All rights reserved
//

// Apple
#import <Foundation/Foundation.h>

// Inherited classes
#import "NSArray+RCC.h"
#import "RCCUbiquitousObject.h"

/**
 NSMutableArray category providing convenience methods for dealing with RCCUbiquitousObject objects.
 */

@interface NSMutableArray(RCC)

// MARK: Setters
/**
 This method must not be called directly but is beeing used by the RCCUbiquitousObjectsController class instead.
 
 Adds the objects contained in another given array to the end of the receiving array’s content.
 The source array must only contain objects of RCCUbiquitousObject class or subclass.
 
 When adding RCCUbiquitousObject objects that do not own a unique uid the most recent objects are beeing kept.
*/
- (void)addRCCUbiquitousObjectsFromArray:(NSArray *)ubiquitousObjects;
/**
 This method must not be called directly but is beeing used by the RCCUbiquitousObjectsController class instead.
 
 Adds a given RCCUbiquitousObject object to the receiver
 
 When adding a RCCUbiquitousObject object that does not own a unique uid the most recent object is beeing kept.
*/
- (void)addRCCUbiquitousObject:(RCCUbiquitousObject *)ubiquitousObject;
@end