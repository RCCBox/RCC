//
//  Created by Roberto Seidenberg
//  All rights reserved
//

// Apple
#import <UIKit/UIKit.h>

// App classes
// Model
#import "RCCCredential.h"
#import "RCCUbiquitousObjectsController.h"

@interface RCCCredentialsDetailViewController : UITableViewController
// MARK: Properties (public)
@property (weak)   id             delegate;
@property (strong) RCCCredential *credential;
@property (strong) RCCUbiquitousObjectsController *ubiquitousObjectsController;
// IBOutlets
// Labels
@property (strong) IBOutlet UILabel *providerLabel;
@property (strong) IBOutlet UILabel *userNameLabel;
@property (strong) IBOutlet UILabel *passwordLabel;
@property (strong) IBOutlet UILabel *tableFooter;
// Textfields
@property (strong) IBOutlet UITextField *providerTextField;
@property (strong) IBOutlet UITextField *userNameTextField;
@property (strong) IBOutlet UITextField *passwordTextField;
@end

@interface RCCCredentialsDetailViewController(UITextFieldDelegate) <UITextFieldDelegate>
@end

@protocol RCCCredentialsDetailViewControllerDelegate
- (void)rccCredentialsDetailViewController:(RCCCredentialsDetailViewController *)vc shouldSaveCredential:(RCCCredential *)credential;
@end