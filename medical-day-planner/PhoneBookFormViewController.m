//
//  PhoneBookFromViewController.m
//  medical-day-planner
//
//  Created by Ronnie Miller on 6/25/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "PhoneBookFormViewController.h"
#import "PhoneBookContact+Methods.h"

@interface PhoneBookFormViewController ()

@end

@implementation PhoneBookFormViewController

@synthesize patient;
@synthesize phonebookContact;

@synthesize name;
@synthesize specialty;
@synthesize phone;
@synthesize fax;
@synthesize email;
@synthesize address;
@synthesize contactName;
@synthesize contactPhone;
@synthesize quickContact;

#pragma mark - 
#pragma mark - Target actions

- (IBAction)save:(id)sender
{
  if (!self.phonebookContact) {
    [self dismissViewControllerAnimated:YES completion:nil];
    [PhoneBookContact createPhoneBookContactWithInfo:[self gatheredFormData] forPatient:self.patient inManagedObjectContext:self.managedObjectContext];
  } else {
    [PhoneBookContact modifyPhoneBookContact:self.phonebookContact withInfo:[self gatheredFormData] inManagedObjectContext:self.managedObjectContext];
    [self.navigationController popViewControllerAnimated:YES];
  }
}

- (IBAction)cancel:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 
#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 0 && indexPath.row == 0) {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showContactPicker];
  }
  
  else {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
  }
}

#pragma mark -
#pragma mark - Address book handling 

- (void)showContactPicker
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.navigationBar.tintColor = [UIColor colorWithRed:0.00f green:0.44f blue:0.52f alpha:1.00f];
    picker.peoplePickerDelegate = self;

    [self presentViewController:picker animated:YES completion:nil];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    [self loadFormWithPerson:person];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

- (void)loadFormWithPerson:(ABRecordRef)person
{
  // load name
  NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
  NSString *lastName  = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
  if (firstName == NULL) firstName = @"";
  if (lastName == NULL)  lastName = @"";

  NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
  self.name.text = [fullName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  
  // load phone number
  NSString *phoneNumber = nil;
  ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
  if (ABMultiValueGetCount(phoneNumbers) > 0) {
    phoneNumber = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
  }

  if (phone) {
    self.phone.text = phoneNumber;
  }

  // load email
  NSString *emailAddress = nil;
  ABMultiValueRef emailAddresses = ABRecordCopyValue(person, kABPersonEmailProperty);
  if (ABMultiValueGetCount(emailAddresses) > 0) {
    emailAddress = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(emailAddresses, 0);
  }

  if (emailAddress) {
    self.email.text = emailAddress;
  }

  // load the address
  NSString *fullAddress = nil;

  ABMultiValueRef addresses = ABRecordCopyValue(person, kABPersonAddressProperty);
  if (ABMultiValueGetCount(addresses) > 0) {
    NSDictionary *mainAddress = (__bridge_transfer NSDictionary*)ABMultiValueCopyValueAtIndex(addresses, 0);

    NSMutableArray *addressFields = [NSMutableArray arrayWithObjects:
                                        [mainAddress objectForKey:(NSString *)kABPersonAddressStreetKey],
                                        [mainAddress objectForKey:(NSString *)kABPersonAddressCityKey],
                                        [mainAddress objectForKey:(NSString *)kABPersonAddressStateKey],
                                        [mainAddress objectForKey:(NSString *)kABPersonAddressZIPKey], nil];

    fullAddress = [addressFields componentsJoinedByString:@"\n"];
  }
  
  if (fullAddress) {
    self.address.text = fullAddress;
  }
}

#pragma mark -
#pragma mark - Extra Textfield delegates

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  // Only do formatting for the phone number fields
  NSArray *phoneFields = [NSArray arrayWithObjects: [NSNumber numberWithInt:2], [NSNumber numberWithInt:3], [NSNumber numberWithInt:7], nil];  
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

- (void)viewDidLoad
{
  [super viewDidLoad];

  if (!self.phonebookContact) {
    self.title = @"Add Contact";    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancel;
  } else {
    self.title = @"Edit Contact";
    [self setFormData:[self.phonebookContact toDictionary]];
  }

  // For elements that are subclasses of UIScrollView disable
  // scrollToTop so tableView scrolls when tapping status bar
  self.address.scrollsToTop = NO;
}

- (void)viewDidUnload
{
  [self setName:nil];
  [self setSpecialty:nil];
  [self setPhone:nil];
  [self setFax:nil];
  [self setEmail:nil];
  [self setAddress:nil];
  [self setContactName:nil];
  [self setContactPhone:nil];
  [self setQuickContact:nil];
  [super viewDidUnload];
}

@end
