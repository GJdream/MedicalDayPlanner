//
//  ProceduresViewController.m
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/12/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "ProceduresViewController.h"
#import "ProcedureFormViewController.h"
#import "Procedure+Methods.h"

@interface ProceduresViewController ()

@end

@implementation ProceduresViewController

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:YES];
  [self setEditSegue:@"editProcedure"];
  
  // Core data setup
  // self.debug = YES;
  
  // Load up all procedures for the table
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Procedure"];
  request.predicate = [NSPredicate predicateWithFormat:@"patient = %@", self.patient];
  request.sortDescriptors = [NSArray arrayWithObjects:
                             [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO],
                             [NSSortDescriptor sortDescriptorWithKey:@"procedureText" ascending:YES], nil];
  
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
  Procedure *procedure = [self.fetchedResultsController objectAtIndexPath:indexPath];
  
  // Set procedure name  
  cell.textLabel.text = procedure.procedureText;
  
  // Set procedure detail text
  cell.detailTextLabel.text = procedure.detailText;  
  
  return cell;
}

#pragma mark -
#pragma mark - Segue preparations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  [super prepareForSegue:segue sender:sender];
  
  if ([[segue identifier] isEqualToString:@"editProcedure"])
  {
    ProcedureFormViewController *vc = [segue destinationViewController];
    Procedure *procedure = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
    [vc setProcedure:procedure];
  }
}

@end
