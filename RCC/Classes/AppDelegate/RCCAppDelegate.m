//
//  Created by Roberto Seidenberg
//  All rights reserved
//

// Header
#import "RCCAppDelegate.h"

// Apple
#import <QuartzCore/QuartzCore.h>

@implementation RCCAppDelegate

// MARK: Template methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	// Make window key window
	[self.window makeKeyWindow];
	
	// Application successfully launched
    return YES;
}
@end
