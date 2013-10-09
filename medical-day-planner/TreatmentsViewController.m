//
//  TreatmentsViewController.m
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/12/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "TreatmentsViewController.h"
#import "TreatmentFormViewController.h"
#import "Treatment+Methods.h"

@interface TreatmentsViewController ()

@end

@implementation TreatmentsViewController

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:YES];
  [self setEditSegue:@"editTreatment"];
  
  // Core data setup
  // self.debug = YES;
  
  // Load up all treatments for the table
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Treatment"];
  request.predicate = [NSPredicate predicateWithFormat:@"patient = %@", self.patient];
  request.sortDescriptors = [NSArray arrayWithObjects:
                             [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:NO],
                             [NSSortDescriptor sortDescriptorWithKey:@"endDate" ascending:NO],
                             [NSSortDescriptor sortDescriptorWithKey:@"treatmentText" ascending:YES], nil];
  
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
  Treatment *treatment = [self.fetchedResultsController objectAtIndexPath:indexPath];
  
  // Set treatment name  
  cell.textLabel.text = treatment.treatmentText;
  
  // Set treatment detail text
  cell.detailTextLabel.text = treatment.detailText;  
  
  return cell;
}

#pragma mark -
#pragma mark - Segue preparations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  [super prepareForSegue:segue sender:sender];
  
  if ([[segue identifier] isEqualToString:@"editTreatment"])
  {
    TreatmentFormViewController *vc = [segue destinationViewController];
    Treatment *treatment = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
    [vc setTreatment:treatment];
  }
}

@end
