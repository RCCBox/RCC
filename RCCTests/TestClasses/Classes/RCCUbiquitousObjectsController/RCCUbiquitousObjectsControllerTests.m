//
//  Created by Roberto Seidenberg
//  All rights reserved
//

// Header
#import "RCCUbiquitousObjectsControllerTests.h"

// Categories
#import "NSArray+RCC.h"

// Inherited classes
#import "RCCCredential.h"

// Test class
#import "RCCUbiquitousObjectsController.h"

// MARK: Constants
static NSString* const kTestStoreKey = @"RCCUbiquitousObjectsTestKey";

@interface RCCUbiquitousObjectsControllerTests()
@property (strong) RCCUbiquitousObjectsController *rccCC;
@end

@implementation RCCUbiquitousObjectsControllerTests

// MARK: Setup + Teardown
- (void)setUp {
	[super setUp];
	
	// Init RCCUbiquitousObjectsController
	self.rccCC = [[RCCUbiquitousObjectsController alloc] initWithStoreKey:kTestStoreKey];
}
- (void)tearDown {
	[super tearDown];
}

// MARK: Init
- (void)testInit {
	
	// New instance
	RCCUbiquitousObjectsController *rccCC = [[RCCUbiquitousObjectsController alloc] init];

	// Should not equal zero
	STAssertTrue((rccCC != nil), @"Newly initialized RCCUbiquitousObjectsController must not equal nil.");
}
- (void)testInitWithStoreKey {
	
	// New instance
	RCCUbiquitousObjectsController *rccCC = [[RCCUbiquitousObjectsController alloc] initWithStoreKey:kTestStoreKey];
	
	// Should not equal nil
	STAssertTrue((rccCC != nil), @"Newly initialized RCCUbiquitousObjectsController must not equal nil.");

	// Custom storyKey
	NSString *customStoreKey = [rccCC performSelector:@selector(storeKey)];
	STAssertTrue([kTestStoreKey isEqualToString:customStoreKey], @"Newly initialized RCCUbiquitousObjectsController custom store key must equal key used in init method");
}

// MARK: Validation
- (void)testValidateRCCUbiquitousObjectForInsert {
	
	// Sample credential
	RCCCredential *credential = [[RCCCredential alloc] init];
	
	// Empty credential should validate
	NSArray *validationErrors =[self.rccCC validateRCCUbiquitousObjectForInsert:credential];
	STAssertFalse([validationErrors count], @"Blank RCCCredential must validate in RCCUbiquitousObjectsController.");
}

// MARK: Persisting
- (void)testStoreRCCUbiquitousObject {
	
	// Remove any objects from NSUbiquitousKeyValueStore and NSUserDefaults
	[[NSUbiquitousKeyValueStore defaultStore] removeObjectForKey:kTestStoreKey];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:kTestStoreKey];
	
	// Sample credential
	RCCCredential *credential = [[RCCCredential alloc] init];
	
	// Populate credential
	credential.provider = @"sampleProvider";
	credential.username = @"sampleUsername";
	credential.password = @"samplePassword";

	// Store credential
	[self.rccCC storeRCCUbiquitousObject:credential];
	
	// Get data from NSUbiquitousKeyValueStore
	NSArray *ubiquitousArray = [[[NSUbiquitousKeyValueStore defaultStore] arrayForKey:kTestStoreKey] rccUbiquitousObjectsRepresentations];
	
	// NSUbiquitousKeyValueStore should contain the object
	STAssertTrue(([ubiquitousArray count] == 1), @"NSUbiquitousKeyValueStore must contain just the single saved RCCCredential");
	
	// Object propertys should equal original properties
	RCCCredential *ubiquitousCredential = [ubiquitousArray lastObject];
	STAssertTrue([credential.uid isEqualToString:ubiquitousCredential.uid], @"Resotred RCC credential uid must equal saved credential uid.");
	STAssertTrue(credential.timestamp == ubiquitousCredential.timestamp, @"Resotred RCC credential timestamp must equal saved credential timestamp.");
	STAssertTrue([credential.provider isEqualToString:ubiquitousCredential.provider], @"Resotred RCC credential provider must equal saved credential provider.");
	STAssertTrue([credential.username isEqualToString:ubiquitousCredential.username], @"Resotred RCC credential username must equal saved credential username.");
	STAssertTrue([credential.password isEqualToString:ubiquitousCredential.password], @"Resotred RCC credential password must equal saved credential password.");
	
	// Get data from NSUserDefaults
	NSArray *defaultsArray = [[[NSUserDefaults standardUserDefaults] arrayForKey:kTestStoreKey] rccUbiquitousObjectsRepresentations];
	
	// NSUbiquitousKeyValueStore should contain the object
	STAssertTrue(([defaultsArray count] == 1), @"NSUserDefaults store must contain just the single saved RCCCredential");
	
	// Object propertys should equal original properties
	RCCCredential *defaultsCredential = [ubiquitousArray lastObject];
	STAssertTrue([credential.uid isEqualToString:defaultsCredential.uid], @"Resotred RCC credential uid must equal saved credential uid.");
	STAssertTrue(credential.timestamp == defaultsCredential.timestamp, @"Resotred RCC credential timestamp must equal saved credential timestamp.");
	STAssertTrue([credential.provider isEqualToString:defaultsCredential.provider], @"Resotred RCC credential provider must equal saved credential provider.");
	STAssertTrue([credential.username isEqualToString:defaultsCredential.username], @"Resotred RCC credential username must equal saved credential username.");
	STAssertTrue([credential.password isEqualToString:defaultsCredential.password], @"Resotred RCC credential password must equal saved credential password.");
}
- (void)testStoreRCCUbiquitousObjects {
	
	// Remove any objects from NSUbiquitousKeyValueStore and NSUserDefaults
	[[NSUbiquitousKeyValueStore defaultStore] removeObjectForKey:kTestStoreKey];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:kTestStoreKey];
	
	// Init array with sampel credentials
	NSMutableArray *mutableCredentialsArray = [NSMutableArray array];
	for (int c=0; c < 10; ++c) {
		
		// Init credential
		RCCCredential *credential = [[RCCCredential alloc] init];
		
		// Populate credential
		credential.provider = [NSString stringWithFormat:@"sampleProvider%i", c];
		credential.username = [NSString stringWithFormat:@"sampleUsername%i", c];
		credential.password = [NSString stringWithFormat:@"samplePassword%i", c];
		
		// Add credential to array
		[mutableCredentialsArray addObject:credential];
	}

	// Store credentials
	[self.rccCC storeRCCUbiquitousObjects:mutableCredentialsArray];
	
	// Get data from NSUbiquitousKeyValueStore
	NSArray *ubiquitousArray = [[[NSUbiquitousKeyValueStore defaultStore] arrayForKey:kTestStoreKey] rccUbiquitousObjectsRepresentations];
	
	// NSUbiquitousKeyValueStore should contain the objects
	STAssertTrue(([ubiquitousArray count] == 10), @"NSUbiquitousKeyValueStore must contain all saved RCCCredential objects");
	
	// Object propertys should equal original properties
	for (int c=0; c < 10; ++c) {
		RCCCredential *credential           = [mutableCredentialsArray objectAtIndex:c];
		RCCCredential *ubiquitousCredential = [ubiquitousArray objectAtIndex:c];
		STAssertTrue([credential.uid isEqualToString:ubiquitousCredential.uid], @"Resotred RCC credential uid must equal saved credential uid.");
		STAssertTrue(credential.timestamp == ubiquitousCredential.timestamp, @"Resotred RCC credential timestamp must equal saved credential timestamp.");
		STAssertTrue([credential.provider isEqualToString:ubiquitousCredential.provider], @"Resotred RCC credential provider must equal saved credential provider.");
		STAssertTrue([credential.username isEqualToString:ubiquitousCredential.username], @"Resotred RCC credential username must equal saved credential username.");
		STAssertTrue([credential.password isEqualToString:ubiquitousCredential.password], @"Resotred RCC credential password must equal saved credential password.");
	}	
	
	// Get data from NSUserDefaults
	NSArray *defaultsArray = [[[NSUserDefaults standardUserDefaults] arrayForKey:kTestStoreKey] rccUbiquitousObjectsRepresentations];
	
	// NSUbiquitousKeyValueStore should contain the objects
	STAssertTrue(([defaultsArray count] == 10), @"NSUserDefaults store must contain all saved RCCCredential objects");
	
	// Object propertys should equal original properties
	for (int c=0; c < 10; ++c) {
		RCCCredential *credential           = [mutableCredentialsArray objectAtIndex:c];
		RCCCredential *ubiquitousCredential = [defaultsArray objectAtIndex:c];
		STAssertTrue([credential.uid isEqualToString:ubiquitousCredential.uid], @"Resotred RCC credential uid must equal saved credential uid.");
		STAssertTrue(credential.timestamp == ubiquitousCredential.timestamp, @"Resotred RCC credential timestamp must equal saved credential timestamp.");
		STAssertTrue([credential.provider isEqualToString:ubiquitousCredential.provider], @"Resotred RCC credential provider must equal saved credential provider.");
		STAssertTrue([credential.username isEqualToString:ubiquitousCredential.username], @"Resotred RCC credential username must equal saved credential username.");
		STAssertTrue([credential.password isEqualToString:ubiquitousCredential.password], @"Resotred RCC credential password must equal saved credential password.");
	}
}

// MARK: Deletion
- (void)testRemoveRCCUbiquitousObject {
	
	// Save credential to store
	[self testStoreRCCUbiquitousObjects];

	// Remove credentials from store
	for (RCCCredential *credential in self.rccCC.ubiquitousObjects) {[self.rccCC removeRCCUbiquitousObject:credential];}
	
	// Get data from NSUbiquitousKeyValueStore
	NSArray *ubiquitousArray = [[[NSUbiquitousKeyValueStore defaultStore] arrayForKey:kTestStoreKey] rccUbiquitousObjectsRepresentations];
	
	// NSUbiquitousKeyValueStore must not contain any objects
	STAssertTrue(([ubiquitousArray count] == 0), @"NSUbiquitousKeyValueStore must not contain any objects");
	
	// Get data from NSUserDefaults
	NSArray *defaultsArray = [[[NSUserDefaults standardUserDefaults] arrayForKey:kTestStoreKey] rccUbiquitousObjectsRepresentations];
	
	// NSUbiquitousKeyValueStore must not contain any objects
	STAssertTrue(([defaultsArray count] == 0), @"NSUserDefaults store must not contain any objects");
}
@end