//
//  Created by Roberto Seidenberg
//  All rights reserved
//

// Header
#import "RCCCredential.h"

@implementation RCCCredential

// MARK: Init
- (id)init {
	
	self = [super init];
	if (self) {
		// Set base value
		// Nil values are not allowed because objects are beeing passed back in case of validation errors
		self.provider = [[NSString alloc] init];
		self.username = [[NSString alloc] init];
		self.password = [[NSString alloc] init];
	}
	return self;
}

// MARK: Template methods
// Uniqueing
- (NSArray *)uniquePropertys {
	return @[@"provider"];
}
// Description
- (NSString *)description {
	return [[self dictionaryRepresentation] description];
}

// MARK: Validation
- (BOOL)uidIsValid:(NSError **)error {

	BOOL isValid = ([self.uid length] > 0);
	if (!isValid && error) {
		
		// Setup error dictionary
		NSMutableDictionary *errorDict = [NSMutableDictionary dictionary];
		[errorDict setObject:self.uid forKey:@"invalidObject"];
		[errorDict setObject:@"Invalid uid!" forKey:NSLocalizedDescriptionKey];
		
		// Setup errot with dictionary
		*error = [NSError errorWithDomain:kRCCPersistentObjectErrorDomain code:100 userInfo:errorDict];
	}
	
	return isValid;
}
- (BOOL)timestampIsValid:(NSError **)error {
	
	BOOL isValid = (self.timestamp > 0);
	if (!isValid && error) {
		
		// Setup error dictionary
		NSMutableDictionary *errorDict = [NSMutableDictionary dictionary];
		[errorDict setObject:[NSNumber numberWithDouble:self.timestamp] forKey:@"invalidObject"];
		[errorDict setObject:@"Invalid timestamp!" forKey:NSLocalizedDescriptionKey];
		
		// Setup errot with dictionary
		*error = [NSError errorWithDomain:kRCCPersistentObjectErrorDomain code:100 userInfo:errorDict];
	}
	
	return isValid;
}
- (BOOL)usernameIsValid:(NSError **)error {
	
	BOOL isValid = ([self.username length] > 0);
	if (!isValid && error) {
		
		// Setup error dictionary
		NSMutableDictionary *errorDict = [NSMutableDictionary dictionary];
		[errorDict setObject:self.username forKey:@"invalidObject"];
		[errorDict setObject:@"Username missing!" forKey:NSLocalizedDescriptionKey];
		
		// Setup errot with dictionary
		*error = [NSError errorWithDomain:kRCCPersistentObjectErrorDomain code:100 userInfo:errorDict];
	}

	return isValid;
}
- (BOOL)providerIsValid:(NSError **)error {
	
	BOOL isValid = ([self.provider length] > 0);
	if (!isValid && error) {
		
		// Setup error dictionary
		NSMutableDictionary *errorDict = [NSMutableDictionary dictionary];
		[errorDict setObject:self.provider forKey:@"invalidObject"];
		[errorDict setObject:@"Provider missing!" forKey:NSLocalizedDescriptionKey];
		
		// Setup errot with dictionary
		*error = [NSError errorWithDomain:kRCCPersistentObjectErrorDomain code:100 userInfo:errorDict];
	}
	
	return isValid;
}
- (BOOL)passwordIsValid:(NSError **)error {

	BOOL isValid = ([self.password length] >= 8);
	if (!isValid && error) {
		
		// Setup error dictionary
		NSMutableDictionary *errorDict = [NSMutableDictionary dictionary];
		[errorDict setObject:self.password forKey:@"invalidObject"];
		[errorDict setObject:@"Password must be minimum 8 characters!" forKey:NSLocalizedDescriptionKey];
		
		// Setup errot with dictionary
		*error = [NSError errorWithDomain:kRCCPersistentObjectErrorDomain code:100 userInfo:errorDict];
	}
	
	return isValid;
}
- (NSArray *)validationErrors {

	// Find errors
	NSMutableArray *errorsArray = [NSMutableArray array];
	NSError *uidError       = nil; if (![self uidIsValid:&uidError])             [errorsArray addObject:uidError];
	NSError *timestampError = nil; if (![self timestampIsValid:&timestampError]) [errorsArray addObject:timestampError];
	NSError *providerError  = nil; if (![self providerIsValid:&providerError])   [errorsArray addObject:providerError];
	NSError *usernameError  = nil; if (![self usernameIsValid:&usernameError])   [errorsArray addObject:usernameError];
	NSError *passwordError  = nil; if (![self passwordIsValid:&passwordError])   [errorsArray addObject:passwordError];
	
	// Return result
	if ([errorsArray count]) {return [errorsArray copy];} else {return nil;}
}
@end