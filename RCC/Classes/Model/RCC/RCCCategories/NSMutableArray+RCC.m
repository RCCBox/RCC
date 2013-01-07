//
//  Created by Roberto Seidenberg
//  All rights reserved
//

// Header
#import "NSMutableArray+RCC.h"

@implementation NSMutableArray(RCC)

// MARK: Setters
- (void)addRCCUbiquitousObjectsFromArray:(NSArray *)ubiquitousObjects {
	
	// Add objects
	for (id object in ubiquitousObjects) {[self addRCCUbiquitousObject:object];}
}
- (void)addRCCUbiquitousObject:(RCCUbiquitousObject *)ubiquitousObject {
	
	// Do nothing if no object was provided
	if (!ubiquitousObject) return;

	// Object beeing added after evaluation
	RCCUbiquitousObject *ubiquitousObjectToAdd = nil;
		
	// Object does not already exist in store
	NSArray *uidPropertyValidationErrors = [self rccUbiquitousObjectInsertValidationErrors:ubiquitousObject ignoreObject:nil uniqueProperties:[NSArray arrayWithObject:@"uid"]];
	if (!uidPropertyValidationErrors) {
		
		// Object does not conflict with any properties marked as unique
		NSArray *uniquePropertiesValidationErrors = [self rccUbiquitousObjectInsertValidationErrors:ubiquitousObject ignoreObject:nil uniqueProperties:ubiquitousObject.uniquePropertys];
		if (!uniquePropertiesValidationErrors) {
			
			// Add this object
			ubiquitousObjectToAdd = ubiquitousObject;
		}
				
	// Object does exist in store
	} else {
		
		// Object does not conflict with any properties marked as unique
		NSArray *uniquePropertiesValidationErrors = [self rccUbiquitousObjectInsertValidationErrors:ubiquitousObject ignoreObject:ubiquitousObject uniqueProperties:ubiquitousObject.uniquePropertys];
		if (!uniquePropertiesValidationErrors) {
			
			// Keep most recent version
			RCCUbiquitousObject *foundObject = [[[uidPropertyValidationErrors lastObject] userInfo] valueForKey:@"invalidObject"];
			if (ubiquitousObject.timestamp > foundObject.timestamp) {
				ubiquitousObjectToAdd = ubiquitousObject;
				foundObject.needsDeletion = YES;
			} else {
				ubiquitousObjectToAdd = nil;
			}
		}
	}

	if (ubiquitousObjectToAdd) [self addObject:ubiquitousObjectToAdd];

	// Remove objects marked for deletion
	[self removeObjectsInArray:[self rccUbiquitousObjectsMarkedForDeletion]];
}
@end