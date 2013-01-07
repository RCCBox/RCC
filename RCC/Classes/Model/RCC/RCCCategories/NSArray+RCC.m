//
//  Created by Roberto Seidenberg
//  All rights reserved
//

// Header
#import "NSArray+RCC.h"

// Inherited classes
#import "NSMutableArray+RCC.h"

@implementation NSArray(RCC)

// MARK: Utility (public)
//
// Fetching
- (NSArray *)rccUbiquitousObjectsMatchingUID:(NSString *)uid {
	
	// Find object with identical provider name
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@", uid];
	NSArray *filteredArray = [self filteredArrayUsingPredicate:predicate];
	
	// Returns object or nil
	if ([filteredArray count]) {return filteredArray;} else {return nil;}
}
- (NSArray *)rccUbiquitousObjectsMatchingKey:(NSString *)key forValue:(id)value {
	
	// Find object with identical provider name
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", key, value];
	NSArray *filteredArray = [self filteredArrayUsingPredicate:predicate];
	
	// Returns object or nil
	if ([filteredArray count]) {return filteredArray;} else {return nil;}
}
- (NSArray *)rccUbiquitousObjectsMarkedForDeletion {

	// Find object marked for deletion
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"needsDeletion == YES"];
	NSArray *filteredArray = [self filteredArrayUsingPredicate:predicate];
	
	// Returns object or nil
	if ([filteredArray count]) {return filteredArray;} else {return nil;}
}
//
// Tagging
//
- (void)markRCCUbiquitousObjectForDeletion:(RCCUbiquitousObject *)ubiquitousObject {
	
	// Find objects matching uid
	NSArray *objectsToRemove = [self rccUbiquitousObjectsMatchingUID:ubiquitousObject.uid];
	
	// Mark for deletion
	for (RCCUbiquitousObject *ubiquitousObject in objectsToRemove) {
		ubiquitousObject.needsDeletion = YES;
		[ubiquitousObject updateTimestamp];
	}
}
//
// Validation
//
- (NSArray *)rccUbiquitousObjectInsertValidationErrors:(RCCUbiquitousObject *)ubiquitousObject ignoreObject:(RCCUbiquitousObject *)ignoredObject uniqueProperties:(NSArray *)uniqueProperties {
	
	// Init errors array
	NSMutableArray *mErrors = [NSMutableArray array];
	
	// Iterate over unique propery names
	for (NSString *key in uniqueProperties) {
		
		// Search objects that match the new objects value for the property
		NSArray *filteredArray = [self rccUbiquitousObjectsMatchingKey:key forValue:[ubiquitousObject valueForKey:key]];
		
		// Propertys with same value found
		if (filteredArray) {
			
			// Iterate over objects
			for (RCCUbiquitousObject *object in filteredArray) {
				
				if (![ignoredObject.uid isEqualToString:object.uid]) {
					
					// Setup error dictionary
					NSMutableDictionary *errorDict = [NSMutableDictionary dictionary];
					[errorDict setObject:object forKey:@"invalidObject"];
					[errorDict setObject:[NSString stringWithFormat:@"%@ with value \"%@\" already exisiting!", [key capitalizedString], [object valueForKey:key]] forKey:NSLocalizedDescriptionKey];
					
					// Setup error with dictionary
					[mErrors addObject:[NSError errorWithDomain:kRCCPersistentObjectErrorDomain code:100 userInfo:errorDict]];
				}
			}
		}
	}
	
	// Return errors or nil
	if ([mErrors count]) {return [mErrors copy];} else {return nil;}
}
//
// Storage preparation
//
- (void)updateRCCUbiquitousObjectsTimestamps {
	for (RCCUbiquitousObject *object in self) {[object updateTimestamp];}
}
//
// Type conversion
//
// NSDictionary -> RCCUbiquitousObject
- (NSArray *)rccUbiquitousObjectsRepresentations {
	
	// Make sure that the array contains only NSDictionarys
	for (id obj in self) if (![obj isKindOfClass:[NSDictionary class]]) return nil;
	
	// Convert dictionarys to RCC objects
	NSMutableArray *mArray = [NSMutableArray array];
	for (NSDictionary *dict in self) {
		id obj = [NSObject objectWithDictionaryRepresentation:dict];
		[mArray addObject:obj];
	}
	
	// Return immutable copy
	return [mArray copy];
}
//
// RCCUbiquitousObject -> NSDictionary
- (NSArray *)dictionaryRepresentations {
	
	// Convert RCC objects to dictionarys
	NSMutableArray *mArray = [NSMutableArray array];
	for (RCCUbiquitousObject *object in self) {[mArray addObject:[object dictionaryRepresentation]];}
	
	// Return immutable copy
	return [mArray copy];
}
@end