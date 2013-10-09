//
//  MedicationsViewController.m
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/1/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "MedicationsViewController.h"
#import "MedicationFormViewController.h"
#import "Medication+Methods.h"

extern NSString *notificationID;

@interface MedicationsViewController ()

@end

@implementation MedicationsViewController

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:YES];
  [self setEditSegue:@"editMedication"];

  // Core data setup
  // self.debug = YES;
  
  // Load up all medications for the table
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Medication"];
  request.predicate = [NSPredicate predicateWithFormat:@"patient = %@", self.patient];
  request.sortDescriptors = [NSArray arrayWithObjects:
                             [NSSortDescriptor sortDescriptorWithKey:@"dc" ascending:YES],
                              [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:NO],
                             [NSSortDescriptor sortDescriptorWithKey:@"endDate" ascending:NO],
                              [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil];

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
  Medication *medication = [self.fetchedResultsController objectAtIndexPath:indexPath];
  // Set medication name
  cell.textLabel.text = medication.name;

  // Set medication detail text
  cell.detailTextLabel.text = medication.detailText;  

  return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
      Medication *medication = [self.fetchedResultsController objectAtIndexPath:indexPath];
      NSManagedObjectID *managedObjectID=medication.objectID;
      NSURL *objURL = [managedObjectID URIRepresentation];
      NSString *notificationIDVal=[objURL absoluteString];
     // NSLog(@"count before=== %d",[[UIApplication sharedApplication] scheduledLocalNotifications].count);
      if([[UIApplication sharedApplication] scheduledLocalNotifications].count>0){
          for (UILocalNotification *someNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
              if([[someNotification.userInfo objectForKey:notificationID] isEqualToString:notificationIDVal]) {
                  [[UIApplication sharedApplication] cancelLocalNotification:someNotification];
                  break;
              }
          }
      }
      
          //  NSLog(@"count after=== %d",[[UIApplication sharedApplication] scheduledLocalNotifications].count);
    [medication deletePhotoFiles];
    [super tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
  }
}

#pragma mark -
#pragma mark - Segue preparations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  [super prepareForSegue:segue sender:sender];
  
  if ([[segue identifier] isEqualToString:@"editMedication"])
  {
    MedicationFormViewController *vc = [segue destinationViewController];
    Medication *medication = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
    [vc setMedication:medication];
  }
}

@end
