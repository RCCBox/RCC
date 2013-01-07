//
//  Created by Roberto Seidenberg
//  All rights reserved
//

// Header
#import "RCCCredentialTests.h"

// Test class
#import "RCCCredential.h"

@implementation RCCCredentialTests

// MARK: Init
- (void)testInit {
	
	// Init sample classes
	RCCCredential *credential1 = [[RCCCredential alloc] init];
	RCCCredential *credential2 = [[RCCCredential alloc] init];
	
	// Uid property must not be equal
	STAssertFalse([credential1.uid isEqualToString:credential2.uid], @"Uid property of newly initialized RCCCredential must be unique.");
	
	// Timestamp needs to be > 0
	STAssertTrue((credential1.timestamp > 0), @"Timestamp property of newly initialized RCCCredential must not equal zero.");
	
	// These string properties must be not nil and zero length
	// Provider
	STAssertTrue((credential1.provider != nil), @"Provider property of newly initialized RCCCredential must not be nil.");
	STAssertTrue(([credential1.provider length] == 0), @"Length of provider property of newly initialized RCCCredential must equal zero.");
	// Username
	STAssertTrue((credential1.username  != nil), @"Username property of newly initialized RCCCredential must not be nil.");
	STAssertTrue(([credential1.username length] == 0), @"Length of username property of newly initialized RCCCredential must equal zero.");
	// Password
	STAssertTrue((credential1.password  != nil), @"Password property of newly initialized RCCCredential must not be nil.");
	STAssertTrue(([credential1.password length] == 0), @"Length of password property of newly initialized RCCCredential must equal zero.");
}

// MARK: Setters
- (void)testUpdateTimestamp {
	
	// Init sample classes
	RCCCredential *credential = [[RCCCredential alloc] init];
	
	// Sample timestamp
	NSTimeInterval timestamp1 = credential.timestamp;
	
	// Update timestamp
	[credential updateTimestamp];
	
	// Sample timestamp
	NSTimeInterval timestamp2 = credential.timestamp;
	
	// Timestamps must not be equal
	STAssertTrue((timestamp1 < timestamp2), @"Timestamp after invoking updateTimestamp method must be greater.)");
}

// MARK: Validation
- (void)testUidIsValid {

	// Init sample classes
	RCCCredential *credential = [[RCCCredential alloc] init];

	// Valid uid
	NSError *error = nil;
	BOOL isValid = [credential uidIsValid:&error];
	
	// Should validate
	STAssertTrue(isValid, @"Username property of newly initialized RCCCredential must be valid.");
	STAssertTrue((error == nil), @"Newly initialized RCCCredential must not return validation error.");
}
- (void)testTimestampIsValid {
	
	// Init sample classes
	RCCCredential *credential = [[RCCCredential alloc] init];
	
	// Valid timestamp
	NSError *error = nil;
	BOOL isValid = [credential timestampIsValid:&error];

	// Should validate
	STAssertTrue(isValid, @"Timestamp property of newly initialized RCCCredential must be valid.");
	STAssertTrue((error == nil), @"Newly initialized RCCCredential must not return validation error.");
}
- (void)testUsernameIsValid {

	// Init sample classes
	RCCCredential *credential = [[RCCCredential alloc] init];
	
	// Invalid username
	NSError *error = nil;
	BOOL isValid = [credential usernameIsValid:&error];

	// Validation should fail
	STAssertFalse(isValid, @"Username property of newly initialized RCCCredential must not be valid.");
	STAssertTrue((error != nil), @"Newly initialized RCCCredential must not return validation error for username property.");
	
	// Valid username
	credential.username = @"sampleUsername";
	isValid = [credential usernameIsValid:&error];
	
	// Should validate
	STAssertTrue(isValid, @"Populated username property of RCCCredential must be valid.");
	STAssertTrue((error != nil), @"Newly initialized RCCCredential must not return validation error for username property.");

}
- (void)testProviderIsValid {

	// Init sample classes
	RCCCredential *credential = [[RCCCredential alloc] init];
	
	// Invalid provider
	NSError *error = nil;
	BOOL isValid = [credential providerIsValid:&error];

	// Validation should fail
	STAssertFalse(isValid, @"Provider property of newly initialized RCCCredential must not be valid.");
	STAssertTrue((error != nil), @"Newly initialized RCCCredential must not return validation error for provider property.");
	
	// Valid provider
	credential.provider = @"sampleProvider";
	isValid = [credential providerIsValid:&error];
	
	// Should validate
	STAssertTrue(isValid, @"Populated provider property of RCCCredential must be valid.");
	STAssertTrue((error != nil), @"Newly initialized RCCCredential must not return validation error for provider property.");
}
- (void)testPasswordIsValid {

	// Init sample classes
	RCCCredential *credential = [[RCCCredential alloc] init];
	
	// Invalid password
	NSError *error = nil;
	BOOL isValid = [credential passwordIsValid:&error];

	// Validation should fail
	STAssertFalse(isValid, @"Password property of newly initialized RCCCredential should not be valid.");
	STAssertTrue((error != nil), @"Newly initialized RCCCredential should not return validation error for password property.");

	// Valid password
	credential.password = @"samplePassword";
	isValid = [credential passwordIsValid:&error];
	
	// Should validate
	STAssertTrue(isValid, @"Populated password property of RCCCredential must be valid.");
	STAssertTrue((error != nil), @"Newly initialized RCCCredential must not return validation error for password property.");

}
- (void)testValidationErrors {

	// Init sample classes
	RCCCredential *credential = [[RCCCredential alloc] init];
	
	// Validation should fail
	NSArray *errors = [credential validationErrors];
	STAssertTrue((errors != nil), @"Newly initialized RCCCredential must return validation errors.");
	
	// Populate credential
	credential.provider = @"sampleProvider";
	credential.username = @"sampleUsername";
	credential.password = @"samplePassword";
	
	// Should validate
	errors = [credential validationErrors];
	STAssertTrue((errors == nil), @"Populated RCCCredential must not return validation errors.");
}
@end
