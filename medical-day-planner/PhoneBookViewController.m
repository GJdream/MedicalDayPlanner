//
//  PhoneBookViewController.m
//  medical-day-planner
//
//  Created by Ronnie Miller on 6/25/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "PhoneBookViewController.h"
#import "PhoneBookFormViewController.h"
#import "PhoneBookContact+Methods.h"

@interface PhoneBookViewController ()

@end

@implementation PhoneBookViewController

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:YES];
  [self setEditSegue:@"editPhoneBook"];

  // Core data setup
  // self.debug = YES;
  
  // Load up all patients for the table
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PhoneBookContact"];
  request.predicate = [NSPredicate predicateWithFormat:@"patient = %@", self.patient];
  request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
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
  PhoneBookContact *phonebookContact = [self.fetchedResultsController objectAtIndexPath:indexPath];
  
  // Set phonebook name  
  cell.textLabel.text = phonebookContact.name;
  cell.detailTextLabel.text = phonebookContact.availablePhone;  
  
  return cell;
}

#pragma mark -
#pragma mark - Segue preparations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  [super prepareForSegue:segue sender:sender];

  if ([[segue identifier] isEqualToString:@"editPhoneBook"])
  {
    PhoneBookFormViewController *vc = [segue destinationViewController];
    PhoneBookContact *phonebookContact = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
    [vc setPhonebookContact:phonebookContact];
  }
}

@end
