//
//  GeneralListViewController.m
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/1/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "GeneralListViewController.h"

@interface GeneralListViewController ()

@end

@implementation GeneralListViewController

@synthesize managedObjectContext;
@synthesize patient;
@synthesize editSegue;

#pragma mark - 
#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
  return 80;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {  
    [self.tableView beginUpdates]; // Avoid NSInternalInconsistencyException
    
    // Delete the contact object that was swiped
    NSManagedObject *cellObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.managedObjectContext deleteObject:cellObject];
    [self performFetch];
    
    // Delete the row on the table
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    // Save the context
    [self.managedObjectContext save:nil];
    [self.tableView endUpdates];
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([[self editSegue] length] != 0) {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:self.editSegue sender:cell];
  }
}

#pragma mark -
#pragma mark - Segue preparations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  // Get reference to the destination view controller
  id vc = [segue destinationViewController];
  if ([vc isKindOfClass:[UINavigationController class]]) {
    vc = [[vc childViewControllers] lastObject];
  }
  
  // Setup the MOC
  if ([vc respondsToSelector:@selector(setManagedObjectContext:)]) {
    [vc setManagedObjectContext:self.managedObjectContext];
  }
  
  // Setup the patient
  if ([vc respondsToSelector:@selector(setPatient:)]) {
    [vc setPatient:self.patient];
  }
  
  // Make the back button text small
  UIBarButtonItem *newBarButtonItem = [[UIBarButtonItem alloc] init];
	newBarButtonItem.title = @"Back";
  self.navigationItem.backBarButtonItem = newBarButtonItem;
}

#pragma mark -
#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
}

@end
