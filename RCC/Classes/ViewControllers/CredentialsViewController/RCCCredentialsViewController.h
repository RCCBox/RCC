//
//  Created by Roberto Seidenberg
//  All rights reserved
//

// Apple
#import <UIKit/UIKit.h>

// App classes
// Viewcontrollers
#import "RCCCredentialsDetailViewController.h"

@interface RCCCredentialsViewController : UITableViewController
@end

@interface RCCCredentialsViewController(UITableViewDelegate) <UITableViewDataSource, UITableViewDelegate>
@end

@interface RCCCredentialsViewController(RCCCredentialsDetailViewControllerDelegate) <RCCCredentialsDetailViewControllerDelegate>
@end