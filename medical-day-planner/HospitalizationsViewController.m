//
//  HospitalizationsViewController.m
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/12/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "HospitalizationsViewController.h"
#import "HospitalizationFormViewController.h"
#import "Hospitalization+Methods.h"

@interface HospitalizationsViewController ()

@end

@implementation HospitalizationsViewController

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:YES];
  [self setEditSegue:@"editHospitalization"];
  
  // Core data setup
  // self.debug = YES;
  
  // Load up all hospitalizations for the table
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hospitalization"];
  request.predicate = [NSPredicate predicateWithFormat:@"patient = %@", self.patient];
  request.sortDescriptors = [NSArray arrayWithObjects:
                             [NSSortDescriptor sortDescriptorWithKey:@"admitDate" ascending:NO],
                             [NSSortDescriptor sortDescriptorWithKey:@"dischargeDate" ascending:NO],
                             [NSSortDescriptor sortDescriptorWithKey:@"symptoms" ascending:YES], nil];
  
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
  Hospitalization *hospitalization = [self.fetchedResultsController objectAtIndexPath:indexPath];
  
  // Set hospitalization name  
  cell.textLabel.text = hospitalization.detailText;
  
  // Set hospitalization detail text
  cell.detailTextLabel.text = hospitalization.symptoms;  
  
  return cell;
}

#pragma mark -
#pragma mark - Segue preparations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  [super prepareForSegue:segue sender:sender];
  
  if ([[segue identifier] isEqualToString:@"editHospitalization"])
  {
    HospitalizationFormViewController *vc = [segue destinationViewController];
    Hospitalization *hospitalization = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
    [vc setHospitalization:hospitalization];
  }
}

@end
