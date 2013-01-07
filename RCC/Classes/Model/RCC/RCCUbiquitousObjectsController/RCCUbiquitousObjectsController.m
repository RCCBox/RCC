//
//  Created by Roberto Seidenberg
//  All rights reserved
//

// Header
#import "RCCUbiquitousObjectsController.h"

// MARK: Constants
static NSString* const kRCCUbiquitousObjectsKey                    = @"RCCUbiquitousObjects";
static NSString* const kRCCUbiquitousObjectsControllerErrorDomain = @"com.elisabit.RCC.RCCUbiquitousObjectsController";

@interface RCCUbiquitousObjectsController()
@property (strong) NSString *storeKey;
@end

@implementation RCCUbiquitousObjectsController(Private)

// Sorting
- (void)updateUbiquitousObjectsProperty:(NSArray *)objects {
	
	// Sort block available
	if (self.sortComparator) {
		
		// Sort objects
		NSMutableArray *mutableObjects = [NSMutableArray arrayWithArray:objects];
		[mutableObjects sortUsingComparator:self.sortComparator];
		self.ubiquitousObjects = [mutableObjects copy];
		
	// No sort block availalbe
	} else {
		
		// Just assign
		self.ubiquitousObjects = objects;
	}
}

// Restoring
- (NSArray *)storedRCCUbiquitousObjects {
	
	// Load RCCUbiquitousObject dictionarys from cloud server
	NSArray *ubiquitosObjects = [[NSUbiquitousKeyValueStore defaultStore] arrayForKey:self.storeKey];

	// Dictionary successfully loaded
	if (ubiquitosObjects) {
		
		// Convert to appropriate class and return
		return [ubiquitosObjects rccUbiquitousObjectsRepresentations];

	// Error loading dictionary
	} else {
		
		// Try loading from defaults
		NSArray *localPersistentObjects = [[NSUserDefaults standardUserDefaults] arrayForKey:self.storeKey];
		
		// Dictionary successfully loaded from defaults
		if (localPersistentObjects) {
			
			// Convert to appropriate class and return
			return [localPersistentObjects rccUbiquitousObjectsRepresentations];
		}
	}
	
	// Return nil on error
	return nil;
}
@end

@implementation RCCUbiquitousObjectsController

// MARK: Init
- (id)init {
	return [self initWithStoreKey:kRCCUbiquitousObjectsKey];
}
- (id)initWithSortComparator:(NSComparator)comparator {
	
	// It's not allowed to call this method with a nil argument
	ZAssert(comparator, @"VIOLATION: Method argument (NSComparator)comparator: %@", comparator);
	
	return [self initWithStoreKey:kRCCUbiquitousObjectsKey andSortComparator:comparator];
}
- (id)initWithStoreKey:(NSString *)key {

	// It's not allowed to call this method with a nil argument
	ZAssert(key, @"VIOLATION: Method argument (NSString *)key: %@", key);
	
	return [self initWithStoreKey:key andSortComparator:nil];
}
- (id)initWithStoreKey:(NSString *)key andSortComparator:(NSComparator)comparator {
	
	// It's not allowed to call this method with a nil argument
	ZAssert(key, @"VIOLATION: Method argument (NSString *)key: %@", key);
	
	self =[super init];
	if (self) {
		
		// Save comparator
		self.sortComparator = comparator;
		
		// Save store key
		if (key) {self.storeKey = key;} else {self.storeKey = kRCCUbiquitousObjectsKey;}

		// iCloud sync block
		id blockself = self;
		void (^syncICloud)(NSNotification *notification) = ^(NSNotification *notification){[[NSUbiquitousKeyValueStore defaultStore] synchronize];};
		
		// Array update block
		void (^updateUbiquitousObjectsObjectsArray)(NSNotification *notification) = ^(NSNotification *notification){[blockself updateUbiquitousObjectsProperty:[blockself storedRCCUbiquitousObjects]];};
		
		// Subscribe to iCloud key value store notifications and update objects array on changes
		[[NSNotificationCenter defaultCenter] addObserverForName:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:updateUbiquitousObjectsObjectsArray];

		// Update model when application becomes active
		[[NSNotificationCenter defaultCenter] addObserverForName:@"UIApplicationDidBecomeActiveNotification" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {

			// Synchronize local store with iCloud key value store
			syncICloud(nil);
			
			// Update object array
			updateUbiquitousObjectsObjectsArray(nil);
		}];
		
		// Synchronize local store with iCloud key value store
		syncICloud(nil);
		
		// Update objects array
		updateUbiquitousObjectsObjectsArray(nil);
	}
	
	return self;
}

// MARK: Utility (public)
// Validation
- (NSArray *)validateRCCUbiquitousObjectForInsert:(RCCUbiquitousObject *)ubiquitousObject {
	return [self.ubiquitousObjects rccUbiquitousObjectInsertValidationErrors:ubiquitousObject ignoreObject:ubiquitousObject uniqueProperties:ubiquitousObject.uniquePropertys];
}

// Persisting
- (BOOL)storeRCCUbiquitousObject:(RCCUbiquitousObject *)ubiquitousObject {
	
	// It's not allowed to call this method with a nil argument
	ZAssert(ubiquitousObject, @"VIOLATION: Method argument (RCCUbiquitousObject *)ubiquitousObject: %@", ubiquitousObject);
	
	// Store objects wih default key
	return [self storeRCCUbiquitousObjects:[NSArray arrayWithObject:ubiquitousObject]];
}
- (BOOL)storeRCCUbiquitousObjects:(NSArray *)objects {

	// It's not allowed to call this method with a nil argument
	ZAssert(objects, @"VIOLATION: Method argument (NSArray *)objects: %@", objects);

	// Update objects timestamps
	// Necessary for conflict resolution
	[objects updateRCCUbiquitousObjectsTimestamps];
	
	// Load cloud objects
	NSArray *cloudObjects = [self storedRCCUbiquitousObjects];
	
	// Load objects dictionarys locally from device and convert to RCCPersistentObject objects
	NSArray *localObjects = [[[NSUserDefaults standardUserDefaults] arrayForKey:self.storeKey] rccUbiquitousObjectsRepresentations];
	
	// Update objects if necessary
	NSMutableArray *updatedObjects = [NSMutableArray array];
	[updatedObjects addRCCUbiquitousObjectsFromArray:cloudObjects];
	[updatedObjects addRCCUbiquitousObjectsFromArray:localObjects];
	[updatedObjects addRCCUbiquitousObjectsFromArray:objects];

	// Generate NSDictionary representation
	NSArray *objectsDictionarys = [updatedObjects dictionaryRepresentations];
	
	// Persist new objects array as NSDictionary representation
	[[NSUbiquitousKeyValueStore defaultStore] setArray:objectsDictionarys forKey:self.storeKey];
	
	// Sanity save
	// This is not really necessary since the data is beeing saved and synchronized automatically
	// The sync might happen faster when the changes are beeing pushed immediately
	BOOL ubiquitousStoreDidSync = [[NSUbiquitousKeyValueStore defaultStore] synchronize];
	
	// Persist new objects locally on device
	// This is necessary for deduplication when restoring data
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:objectsDictionarys forKey:self.storeKey];
	BOOL userDefaultsDidSync = [defaults synchronize];
	
	// Update objects array
	[self updateUbiquitousObjectsProperty:[self storedRCCUbiquitousObjects]];
	
	return (ubiquitousStoreDidSync && userDefaultsDidSync);
}

// Editing
-(void)removeRCCUbiquitousObject:(RCCUbiquitousObject *)ubiquitousObject {

	// It's not allowed to call this method with a nil argument
	ZAssert(ubiquitousObject, @"VIOLATION: Method argument (RCCUbiquitousObject *)ubiquitousObject: %@", ubiquitousObject);
	
	// Mark objects for deletion
	NSMutableArray *storedObjects = [NSMutableArray arrayWithArray:[self storedRCCUbiquitousObjects]];
	[storedObjects markRCCUbiquitousObjectForDeletion:ubiquitousObject];
	
	// Persist updated objects
	[self storeRCCUbiquitousObjects:[storedObjects copy]];
	
	// Update objects array
	[self updateUbiquitousObjectsProperty:[self storedRCCUbiquitousObjects]];
}

// MARK: Cleanup
- (void)dealloc {

	// Unsubscribe to all notifications
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end