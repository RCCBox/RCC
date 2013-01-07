//
//  Created by Roberto Seidenberg
//  All rights reserved
//

// Header
#import "NSMutableArray+RCCTests.h"

// Test class
#import "NSMutableArray+RCC.h"

// Inherited classes
// Categories
#import "NSArray+RCC.h"
// Model
#import "RCCCredential.h"

@interface NSMutableArray_RCCTests()
@property (strong) NSMutableArray *credentials; // Holds RCCCredential objects for testing
@end

@implementation NSMutableArray_RCCTests

// MARK: Setup + Teardown
- (void)setUp {
    [super setUp];
	
	// Setup some credential classes for testing
	self.credentials = [NSMutableArray array];
	[self.credentials addRCCUbiquitousObject: [[RCCCredential alloc] init]];
	[self.credentials addRCCUbiquitousObject: [[RCCCredential alloc] init]];
	[self.credentials addRCCUbiquitousObject: [[RCCCredential alloc] init]];
	[self.credentials addRCCUbiquitousObject: [[RCCCredential alloc] init]];
	
	// Fill credentials with sample data
	for (RCCCredential *credential in self.credentials) {
		NSUInteger index = [self.credentials indexOfObject:credential];
		credential.provider = [NSString stringWithFormat:@"providername%u", index];
		credential.username = [NSString stringWithFormat:@"username%u", index];
		credential.password = [NSString stringWithFormat:@"password%u", index];
	}
}
- (void)tearDown {   
    [super tearDown];
}

// MARK: Test cases
//
// Setters
- (void)testAddRCCUbiquitousObjectsFromArray {
	
	// Get count of RCCCredentials
	NSUInteger count = [self.credentials count];
	
	// Add identical RCCCredential objects to the same array again
	[self.credentials addRCCUbiquitousObjectsFromArray:self.credentials];
	
	// Count must be equal because all objects are unique
	STAssertTrue(([self.credentials count] == count), @"Count of RCCCredentials in array after adding objects with identical uid must equal count of RCCObjects before adding these objects");
	
	// Add a new RCCCredential object
	[self.credentials addRCCUbiquitousObjectsFromArray:[NSArray arrayWithObject:[[RCCCredential alloc] init]]];
	
	// Count must be +1
	STAssertTrue(([self.credentials count] == count+1), @"Count of RCCCredentials in array after adding a new object must equal count+1 of RCCObjects before adding these objects");
	
}
- (void)testaddRCCUbiquitousObject {

	// Get count of RCCCredentials
	NSUInteger count = [self.credentials count];
	
	// Add an identical RCCCredential to the same array again
	[self.credentials addRCCUbiquitousObject:[self.credentials lastObject]];
	
	// Count must be equal because all objects are unique
	STAssertTrue(([self.credentials count] == count), @"Count of RCCCredentials in array after adding objects with identical uid must equal count of RCCObjects before adding these objects");
	
	// Add a new RCCCredential object
	[self.credentials addRCCUbiquitousObjectsFromArray:[NSArray arrayWithObject:[[RCCCredential alloc] init]]];
	
	// Count must be +1
	STAssertTrue(([self.credentials count] == count+1), @"Count of RCCCredentials in array after adding a new object must equal count+1 of RCCObjects before adding these objects");
}
@end
