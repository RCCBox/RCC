//
//  Created by Roberto Seidenberg
//  All rights reserved
//

// Apple
#import "RCCUbiquitousObject.h"

// Third party
// Categories
#import "NSString+UUID.h"

// Inherited classes
#import "NSArray+RCC.h"
#import "NSMutableArray+RCC.h"

@implementation RCCUbiquitousObject(AutoMagicCodingTemplateMethods)

// Enable automatic encoding using NSObject+AutoMagicCoding.h
+ (BOOL)AMCEnabled {
	return YES;
}
@end

@interface RCCUbiquitousObject()
@property (readwrite) NSString       *uid;
@property (readwrite) NSTimeInterval  timestamp;
@end

@implementation RCCUbiquitousObject(RCCUbiquitousObjectTemplateMethods)
- (NSArray *)uniquePropertys {
	return nil;
}
@end

@implementation RCCUbiquitousObject

// MARK: Init
- (id)init {
	
	self = [super init];
	if (self) {
		// Set base value
		// Nil values are not allowed because objects are beeing passed back in case of validation errors
		self.uid      = [NSString stringWithNewUUID];
		[self updateTimestamp];
	}
	return self;
}

// MARK: Template methods
- (NSString *)description {
	return [[self dictionaryRepresentation] description];
}

// MARK: Utility
- (void)updateTimestamp {
	self.timestamp = [[NSDate date] timeIntervalSince1970];
}
@end