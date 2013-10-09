//
//  AppointmentsViewController.m
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/11/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "AppointmentsViewController.h"
#import "AppointmentFormViewController.h"
#import "Appointment+Methods.h"

@interface AppointmentsViewController ()

@end

@implementation AppointmentsViewController

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:YES];
  [self setEditSegue:@"editAppointment"];
  
  // Core data setup
  // self.debug = YES;
  
  // Load up all patients for the table
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Appointment"];
  request.predicate = [NSPredicate predicateWithFormat:@"patient = %@", self.patient];
  request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"dateTime" ascending:YES]];
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
  
  // Get appointment object for cell
  Appointment *appointment = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
  cell.textLabel.text = appointment.formattedDateTime;
  cell.detailTextLabel.text = appointment.physician;
  
  return cell;
}

#pragma mark -
#pragma mark - Segue preparations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  [super prepareForSegue:segue sender:sender];
  
  if ([[segue identifier] isEqualToString:@"editAppointment"])
  {
    AppointmentFormViewController *vc = [segue destinationViewController];
    Appointment *appointment = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
    [vc setAppointment:appointment];
  }
}

@end
