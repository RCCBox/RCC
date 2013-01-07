//
//  Created by Roberto Seidenberg
//  All rights reserved
//

// Header
#import "RCCCredentialsDetailViewController.h"

@implementation RCCCredentialsDetailViewController(Private)
- (void)validateCredential:(RCCCredential *)credential {

	// Set colors for correct/incorrect entries
	UIColor *acceptColor = [UIColor colorWithRed:82.0f/255.0f green:102.0f/255.0f blue:145.0f/255.0f alpha:1.0f];
	UIColor *rejectColor = [UIColor redColor];
	
	// Fetch validation errors
	NSMutableArray *validationErrors = [NSMutableArray array];
	[validationErrors addObjectsFromArray:[credential validationErrors]];
	[validationErrors addObjectsFromArray:[self.ubiquitousObjectsController validateRCCUbiquitousObjectForInsert:credential]];
	
	// Find all invalid objects
	NSMutableArray *mInvalidObjects = [NSMutableArray array];
	for (NSError *error in validationErrors) {[mInvalidObjects addObject:[[error userInfo] objectForKey:@"invalidObject"]];}
	
	// Update UI
	if ([mInvalidObjects indexOfObject:credential.provider] != NSNotFound) {self.providerLabel.textColor = rejectColor;} else {self.providerLabel.textColor = acceptColor;}
	if ([mInvalidObjects indexOfObject:credential.username] != NSNotFound) {self.userNameLabel.textColor = rejectColor;} else {self.userNameLabel.textColor = acceptColor;}
	if ([mInvalidObjects indexOfObject:credential.password] != NSNotFound) {self.passwordLabel.textColor = rejectColor;} else {self.passwordLabel.textColor = acceptColor;}

	// Update table footer note
	NSMutableString *errorString = [NSMutableString string];
	for (NSError *error in validationErrors) {[errorString appendFormat:@"%@\n", [error localizedDescription]];}
	self.tableFooter.text = errorString;
	
	// Update save bar button
	self.navigationItem.rightBarButtonItem.enabled = ([validationErrors count] == 0);
}
@end

@implementation RCCCredentialsDetailViewController

// MARK: Template methods
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// Setup credential
	if (!self.credential) self.credential = [RCCCredential new];
	
	// Update UI
	self.providerTextField.text = self.credential.provider;
	self.userNameTextField.text = self.credential.username;
	self.passwordTextField.text = self.credential.password;
	
	// Validate
	[self validateCredential:self.credential];
}
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	// Show keyboard
	[self.providerTextField becomeFirstResponder];
}

// MARK: IBActions
- (IBAction)save:(id)sender {

	// Call delegate
	if ([self.delegate respondsToSelector:@selector(rccCredentialsDetailViewController:shouldSaveCredential:)]) [self.delegate rccCredentialsDetailViewController:self shouldSaveCredential:self.credential];
}
- (IBAction)textEditingChanged:(id)sender {

	// Update credential
	if (sender == self.providerTextField) self.credential.provider = self.providerTextField.text;
	if (sender == self.userNameTextField) self.credential.username = self.userNameTextField.text;
	if (sender == self.passwordTextField) self.credential.password = self.passwordTextField.text;
	
	// Validate
	[self validateCredential:self.credential];
}
@end

@implementation RCCCredentialsDetailViewController(UITextFieldDelegate)
@end