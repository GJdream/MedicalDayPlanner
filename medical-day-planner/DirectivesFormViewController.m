//
//  DirectivesFormViewController.m
//  The Medical Day Planner
//
//  Created by Ronnie Miller on 6/14/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "DirectivesFormViewController.h"
#import "Directive.h"

@interface DirectivesFormViewController ()
- (NSArray *)directiveFields;
- (void)setDirectiveFieldValues;
@end

@implementation DirectivesFormViewController

@synthesize patient;
@synthesize attorney;
@synthesize attorneyPhone;
@synthesize dpoaName;
@synthesize dpoaPhoneHome;
@synthesize dpoaPhoneWork;
@synthesize dpoaPhoneCell;
@synthesize dpoaRelationship;
@synthesize livingWill;
@synthesize dnr;
@synthesize dni;
@synthesize dpoa;
@synthesize trust;
#pragma mark - 
#pragma mark - Table view delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

  // Third section is all the checkboxes
  if (indexPath.section == 2) {
    BOOL checked = (cell.accessoryType == UITableViewCellAccessoryCheckmark);
    cell.accessoryType = (checked) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;    
    [self.patient.directive setValue:[NSNumber numberWithBool:!checked] forKey:[[[self directiveFields] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];

    NSError *error;
    [self.managedObjectContext save:&error];
  }

  else {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
  }
}

- (NSArray *)directiveFields
{
  return [NSArray arrayWithObjects:
            [NSArray arrayWithObjects: @"attorney", @"attorney_phone", nil],
            [NSArray arrayWithObjects: @"dpoaName", @"dpoaPhoneHome", @"dpoaPhoneWork", @"dpoaPhoneCell", @"dpoaRelationship", nil],
            [NSArray arrayWithObjects: @"livingWill", @"dnr", @"dni", @"dpoa",@"trust", nil], nil];
}

#pragma mark -
#pragma mark - Extra Textfield delegates

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  // Only do formatting for the phone number fields
  NSArray *phoneFields = [NSArray arrayWithObjects: [NSNumber numberWithInt:1], [NSNumber numberWithInt:3], [NSNumber numberWithInt:4], [NSNumber numberWithInt:5], nil];  
  if (![phoneFields containsObject:[NSNumber numberWithInt:textField.tag]]) return YES;
  
  int length = [self getLength:textField.text];
  
  if(length == 10)
  {
    if(range.length == 0)
      return NO;
  }
  
  if(length == 3)
  {
    NSString *num = [self formatNumber:textField.text];
    textField.text = [NSString stringWithFormat:@"(%@) ",num];
    if(range.length > 0)
      textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
  }
  else if(length == 6)
  {
    NSString *num = [self formatNumber:textField.text];
    textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
    if(range.length > 0)
      textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
  }
  
  return YES;
}

-(NSString*)formatNumber:(NSString*)mobileNumber
{
  
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
  
  int length = [mobileNumber length];
  if(length > 10)
  {
    mobileNumber = [mobileNumber substringFromIndex: length-10];
    
  }
  
  return mobileNumber;
}

-(int)getLength:(NSString*)mobileNumber
{
  
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
  
  int length = [mobileNumber length];
  
  return length;
}

#pragma mark - 
#pragma mark - View lifecycle

- (NSArray *)textFieldsForKeyboardControls
{
  return [NSArray arrayWithObjects:
                      self.attorney, self.attorneyPhone,
                      self.dpoaName, self.dpoaPhoneHome, self.dpoaPhoneWork, self.dpoaPhoneCell, self.dpoaRelationship, nil];
}

- (void)setDirectiveFieldValues
{
  NSDictionary *formData = [self gatheredFormData];
  
  NSArray *keys = [formData allKeys];
  for (NSString *key in keys) {
    if ([patient.directive respondsToSelector:NSSelectorFromString([NSString stringWithFormat:@"%@", key])]) {
      [patient.directive setValue:[formData objectForKey:key] forKey:key];
    }
  }
}

- (void)viewWillDisappear:(BOOL)animated
{
  // Set values for directive fields
  [self setDirectiveFieldValues];

  // Save the directive
  NSError *error;
  [self.managedObjectContext save:&error];
  
  [super viewWillDisappear:YES];
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  // Create the directive object if the user doesn't have one yet
  if (!self.patient.directive) {
    NSError *error;
    Directive *directive = [NSEntityDescription insertNewObjectForEntityForName:@"Directive" inManagedObjectContext:self.managedObjectContext];
    directive.patient = self.patient;
    [self.managedObjectContext save:&error];  
  }

  // Populate form fields with existing data
  [self setFormData:[self.patient.directive toDictionary]];
}

- (void)viewDidUnload
{
  [self setAttorney:nil];
  [self setAttorneyPhone:nil];

  [self setDpoaName:nil];
  [self setDpoaPhoneHome:nil];
  [self setDpoaPhoneWork:nil];
  [self setDpoaPhoneCell:nil];
  [self setDpoaRelationship:nil];

  [self setLivingWill:nil];
  [self setDnr:nil];
  [self setDni:nil];
  [self setDpoa:nil];
    [self setTrust:nil];
  [super viewDidUnload];
}

@end
