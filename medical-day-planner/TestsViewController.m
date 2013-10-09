//
//  TestsViewController.m
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/1/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "TestsViewController.h"
#import "TestFormViewController.h"
#import "Test+Methods.h"

@interface TestsViewController ()

@end

@implementation TestsViewController

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:YES];
  [self setEditSegue:@"editTest"];
  
  // Core data setup
  // self.debug = YES;
  
  // Load up all tests for the table
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Test"];
  request.predicate = [NSPredicate predicateWithFormat:@"patient = %@", self.patient];
  request.sortDescriptors = [NSArray arrayWithObjects:
                             [NSSortDescriptor sortDescriptorWithKey:@"performedDate" ascending:NO],
                             [NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES], nil];
  
  self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                      managedObjectContext:self.managedObjectContext
                                                                        sectionNameKeyPath:nil
                                                                                 cacheName:nil];
}

#pragma mark - 
#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{ 
  static NSString *CellIdentifier = @"PlainCustomCell";
  static NSString *CellNib = @"PlainCustomCellView";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
    cell = [nib objectAtIndex:0];
  }
  
  // Get phone book object for cell
  Test *test = [self.fetchedResultsController objectAtIndexPath:indexPath];
  
  // Set test name  
  cell.textLabel.text = test.type;
  
  // Set test detail text
  cell.detailTextLabel.text = test.detailText;  
  
  return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    Test *test = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [test deletePhotoFiles];
    [super tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
  }
}

#pragma mark -
#pragma mark - Segue preparations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  [super prepareForSegue:segue sender:sender];
  
  if ([[segue identifier] isEqualToString:@"editTest"])
  {
    TestFormViewController *vc = [segue destinationViewController];
    Test *test = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
    [vc setTest:test];
  }
}

@end
