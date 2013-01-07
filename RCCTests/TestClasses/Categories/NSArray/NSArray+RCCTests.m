//
//  Created by Roberto Seidenberg
//  All rights reserved
//

// Header
#import "NSArray+RCCTests.h"

// Test class
#import "NSArray+RCC.h"

// Inherited classes
// Categories
#import "NSMutableArray+RCC.h"
// Model
#import "RCCCredential.h"

@interface NSArray_RCCTests()
@property (strong) NSArray *credentials;           // Holds RCCCredential objects for testing
@property (strong) NSArray *credentialDictionarys; // Holds NSdictionary representations of RCCCredential objects for testing
@end

@implementation NSArray_RCCTests

// MARK: Setup + Teardown
- (void)setUp {
    [super setUp];
	
	// Setup some credential classes for testing
	NSMutableArray *mCredentialsArray = [NSMutableArray array];
	[mCredentialsArray addRCCUbiquitousObject: [[RCCCredential alloc] init]];
	[mCredentialsArray addRCCUbiquitousObject: [[RCCCredential alloc] init]];
	[mCredentialsArray addRCCUbiquitousObject: [[RCCCredential alloc] init]];
	[mCredentialsArray addRCCUbiquitousObject: [[RCCCredential alloc] init]];
	
	// Fill credentials with sample data
	for (RCCCredential *credential in mCredentialsArray) {
		NSUInteger index = [mCredentialsArray indexOfObject:credential];
		credential.provider = [NSString stringWithFormat:@"providername%u", index];
		credential.username = [NSString stringWithFormat:@"username%u", index];
		credential.password = [NSString stringWithFormat:@"password%u", index];
	}
	
	// Save immutable copy
	self.credentials = [mCredentialsArray copy];
	
	// Convert all RCCCredential objects to NSDictionary objects
	NSMutableArray *mCredentialDictsArray = [NSMutableArray array];
	for (RCCCredential *credential in mCredentialsArray) {
		[mCredentialDictsArray addObject:[credential dictionaryRepresentation]];
	}
	
	// Save immutable copy
	self.credentialDictionarys = [mCredentialDictsArray copy];
}
- (void)tearDown {   
    [super tearDown];
}

// MARK: Test cases
// Fetching
- (void)testRCCUbiquitousObjectsMatchingUID {
	
	// Get first credential
	RCCCredential *credential = [self.credentials objectAtIndex:0];
	
	// Get credentials uid
	NSString *uid = credential.uid;
	
	// Find credentials by uid
	NSArray *foundCredentials = [self.credentials rccUbiquitousObjectsMatchingUID:uid];
	
	STAssertTrue(([foundCredentials count] == 1), @"Number of found  elements with unique uid found in array of RCCCredentials does not equal 1.");
}
- (void)testRCCUbiquitousObjectsMatchingKey {
	
	// Get first credential
	RCCCredential *credential = [self.credentials objectAtIndex:0];
	
	// Get credentials uid
	NSString *provider = credential.provider;
	
	// Find credentials by uid
	NSArray *foundCredentials = [self.credentials rccUbiquitousObjectsMatchingKey:@"provider" forValue:provider];
	
	STAssertTrue(([foundCredentials count] == 1), @"Number of found  elements with unique uid found in array of RCCCredentials does not equal 1.");
}
- (void)testRCCUbiquitousObjectsMarkedForDeletion {
	
	// Get first credential
	RCCCredential *credential = [self.credentials objectAtIndex:0];
	
	// Mark for deletion
	[self.credentials markRCCUbiquitousObjectForDeletion:credential];
	
	// Find credentials marked for deletion
	NSArray *foundCredentials = [self.credentials rccUbiquitousObjectsMarkedForDeletion];
	
	// Should find one credential
	STAssertTrue(([foundCredentials count] == 1), @"Number of found objects marked for deletion must equal 1.");
}

// Tagging
- (void)testMarkRCCUbiquitousObjectForDeletion {
	// This test is covered by -(void)testCredentialsMarkedForDeletion
}

// Storage preparation
- (void)testupdateRCCUbiquitousObjectsTimestamps {
	
	// Collect existing timestamps
	NSMutableArray *mutableTimestamps = [NSMutableArray array];
	for (RCCCredential *credential in self.credentials) [mutableTimestamps addObject:[NSNumber numberWithDouble:credential.timestamp]];
	
	// Update timestamps
	[self.credentials updateRCCUbiquitousObjectsTimestamps];
	
	// Check updated timestamps
	NSUInteger c = 0;
	for (RCCCredential *credential in self.credentials) {
		NSTimeInterval savedTimestamp = [[mutableTimestamps objectAtIndex:c] doubleValue];
		STAssertTrue((savedTimestamp < credential.timestamp), @"Timestamp after update must not ne smaller then before.");
		++c;
	}
}

// RCCCredential type conversion
// NSDictionary -> RCCCredential
- (void)testRCCUbiquitousObjectsRepresentations {
	
	// Generate RCCCredential representations from an array of NSDictionarys
	NSArray *credentials = [self.credentialDictionarys rccUbiquitousObjectsRepresentations];
	
	// Array must contain objects
	STAssertTrue([credentials count], @"Array must contain objects.");
	
	// Iterate over generated objects
	NSUInteger index = 0;
	for (RCCCredential *credential in credentials) {
		
		// Find matching RCCCredential object
		RCCCredential *referenceCredential = [self.credentials objectAtIndex:index];
		
		// Make sure object is kind of class RCCCredential
		STAssertTrue([NSStringFromClass([credential class]) isEqualToString:NSStringFromClass([RCCCredential class])], @"Object must not be of any other class then RCCCredential.");
		
		// Object must equal reference RCCCredential
		STAssertTrue([credential.uid isEqualToString:referenceCredential.uid], @"Uid of RCCCredential representation does not match value from originating NSDictionary.");
		STAssertTrue((credential.timestamp == referenceCredential.timestamp), @"Timestamp of RCCCredential representation does not match value from originating NSDictionary.");
		STAssertTrue([credential.provider isEqualToString:referenceCredential.provider], @"Provider of RCCCredential representation does not match value from originating NSDictionary.");
		STAssertTrue([credential.username isEqualToString:credential.username], @"Username of RCCCredential representation does not match value from originating NSDictionary.");
		STAssertTrue([credential.password isEqualToString:credential.password], @"Password of RCCCredential representation does not match value from originating NSDictionary.");
		
		++index;
	}
}
//
// RCCCredential -> NSDictionary
- (void)testDictionaryRepresentations {

	// Generate NSDictionary representations from an array of RCCCredentials
	NSArray *dictionarys = [self.credentials dictionaryRepresentations];
	
	// Array must contain objects
	STAssertTrue([dictionarys count], @"Array does not contain objects.");
	
	// Iterate over generated objects
	NSUInteger index = 0;
	for (NSDictionary *dict in dictionarys) {
		
		// Find matching NSDictionary object
		NSDictionary *credentialDict = [self.credentialDictionarys objectAtIndex:index];
		
		// Object must be of class NSDictionary
		STAssertTrue([dict isKindOfClass:[NSDictionary class]], @"Object of different class than NSDictionary found.");
		
		// Object must equal reference dictionary
		STAssertTrue([credentialDict isEqualToDictionary:dict], @"Generated NSDictionary is not equal reference dictionary.");
				
		++index;
	}
}
@end
