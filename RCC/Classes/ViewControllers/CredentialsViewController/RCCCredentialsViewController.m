//
//  Created by Roberto Seidenberg
//  All rights reserved
//

// Header
#import "RCCCredentialsViewController.h"

// Third party
// Categories
#import "NSObject+KVOBlockBinding.h"

// App classes
// Model
#import "RCCUbiquitousObjectsController.h"

@interface RCCCredentialsViewController()
@property (strong) RCCUbiquitousObjectsController *ubiquitousObjectsController;
@end

@implementation RCCCredentialsViewController

// MARK: Template methods
- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Init RCCUbiquitousObject controller
	self.ubiquitousObjectsController = [[RCCUbiquitousObjectsController alloc] initWithSortComparator:^NSComparisonResult(RCCCredential *item1, RCCCredential *item2) {return [item1.provider localizedCompare: item2.provider];}];
	
	// UI update block
	__block __weak id blockself = self;
	void (^updateUI)(id observed, NSDictionary *change) = ^(id observed, NSDictionary *change){
		
		// Reload tableview
		[[blockself tableView] reloadData];
		
		// Only enable "edit" button if credentials are available
		[[[blockself navigationItem] rightBarButtonItem] setEnabled: ([self.ubiquitousObjectsController.ubiquitousObjects count] > 0)];
	};
	
	// Update UI on object changes
	[self.ubiquitousObjectsController addObserverForKeyPath:@"ubiquitousObjects" owner:self block:updateUI];
	
	// Update UI
	updateUI(nil, nil);
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	// Set detail viewcontroller delegate
	// Necesarry for saving changs on dismissal
	[segue.destinationViewController setDelegate:self];
	
	if ([segue.identifier isEqualToString:@"Select"]) {
		
		// Get selected index path
		NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
		
		// Row is selected
		if (indexPath) {
			
			// Find correpsonding credential object and store it in destination viewcontroller
			RCCCredential *credential = [self.ubiquitousObjectsController.ubiquitousObjects objectAtIndex:indexPath.row];
			[segue.destinationViewController setCredential:credential];
		}
	}
	
	// Store credentials controller in detail view controller
	[segue.destinationViewController setUbiquitousObjectsController:self.ubiquitousObjectsController];
}

// MARK: IBActions
- (IBAction)edit:(id)sender {
	[self setEditing:!self.editing animated:YES];
}
@end

@implementation RCCCredentialsViewController(RCCCredentialsDetailViewControllerDelegate)
- (void)rccCredentialsDetailViewController:(RCCCredentialsDetailViewController *)vc shouldSaveCredential:(RCCCredential *)credential {

	// Store credential
	[self.ubiquitousObjectsController storeRCCUbiquitousObject:credential];
	
	// Pop back to this viewcontroller
	[self.navigationController popToViewController:self animated:YES];
}
@end

@implementation RCCCredentialsViewController(UITableViewDelegate)

// MARK: UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.ubiquitousObjectsController.ubiquitousObjects count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// Init cell
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CredentialsCell" forIndexPath:indexPath];
	
	// Find credential
	RCCCredential *credential = [self.ubiquitousObjectsController.ubiquitousObjects objectAtIndex:indexPath.row];
	
	// Setup cell
	cell.textLabel.text = credential.provider;
	cell.detailTextLabel.text = credential.username;
	
	return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// Find and remove object
	RCCCredential *credential = [self.ubiquitousObjectsController.ubiquitousObjects objectAtIndex:indexPath.row];
	[self.ubiquitousObjectsController removeRCCUbiquitousObject:credential];
}

// MARK: UITableViewDelegate
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}
@end