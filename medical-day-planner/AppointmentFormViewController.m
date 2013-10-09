//
//  AppointmentFormViewController.m
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/11/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "AppointmentFormViewController.h"
#import "Patient.h"
#import "PhoneBookContact.h"
#import "SimpleContact.h"

enum {
  PickerViewPhysicianPicker,
  PickerViewCaregiverPicker
} PickerView;

@interface AppointmentFormViewController ()
{
  UITextField *pickerTarget;
  NSSet *caregivers;

  UIPickerView *physicianPicker;
  UIPickerView *caregiverPicker;

  UIToolbar *keyboardToolbar;
  UIToolbar *pickerToolbar;
}
@end

@implementation AppointmentFormViewController

@synthesize patient;
@synthesize appointment;

@synthesize physician;
@synthesize dateTime;
@synthesize caregiver;
@synthesize purpose;
@synthesize results;
@synthesize nextDateTime;

#pragma mark - 
#pragma mark - Target actions

- (IBAction)save:(id)sender
{
  // Make sure an appointment date is given
  if (self.dateTime.text.length == 0) {
    UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Appointment Date Needed" message:@"Please enter the date and time for this appointment." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [error show];
  } else {  
    if (!self.appointment) {
      [self dismissViewControllerAnimated:YES completion:nil];
      [Appointment createAppointmentWithInfo:[self gatheredFormData] forPatient:self.patient inManagedObjectContext:self.managedObjectContext];
    } else {
      [Appointment modifyAppointment:self.appointment withInfo:[self gatheredFormData] inManagedObjectContext:self.managedObjectContext];
      [self.navigationController popViewControllerAnimated:YES];
    }
  }
}

- (IBAction)cancel:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showKeyboardView:(id)sender
{
  [pickerTarget resignFirstResponder];
  pickerTarget.inputView = nil;
  pickerTarget.inputAccessoryView = pickerToolbar;
  [pickerTarget becomeFirstResponder];
} 

- (void)showPickerView:(id)sender
{
  [pickerTarget resignFirstResponder];
  pickerTarget.inputView = (pickerTarget == self.physician) ? physicianPicker : caregiverPicker;
  pickerTarget.inputAccessoryView = keyboardToolbar;
  [pickerTarget becomeFirstResponder];  
}

#pragma mark -
#pragma mark - Date picker handling

- (void)contactPickerValueChanged:(id)sender
{
  
}

- (void)datePickerValueChanged:(id)sender
{
  NSDate *pickerDate = [sender date];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"MM/dd/yy hh:mm a"];  
  pickerTarget.text = [formatter stringFromDate:pickerDate];
}

#pragma mark - 
#pragma mark - Picker view delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  if (pickerView.tag == PickerViewPhysicianPicker) {
    return self.patient.phonebookContacts.count + 1;
  }

  else if (pickerView.tag == PickerViewCaregiverPicker) {
    return caregivers.count + 1;
  }

  return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  id contact;
  NSArray *sortDescriptor = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];

  if (row == 0) {
    return @"";
  }
  
  if (pickerView.tag == PickerViewPhysicianPicker) {
    contact = [[self.patient.phonebookContacts sortedArrayUsingDescriptors:sortDescriptor] objectAtIndex:row - 1];
  }
  
  else if (pickerView.tag == PickerViewCaregiverPicker) {
    contact = [[caregivers sortedArrayUsingDescriptors:sortDescriptor] objectAtIndex:row - 1];
  }
  
  return [contact valueForKey:@"name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
  pickerTarget.text = [self pickerView:pickerView titleForRow:row forComponent:component];
}

#pragma mark - 
#pragma mark - Text field delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
  if (textField.tag == 0 || textField.tag == 1 || textField.tag == 2 || textField.tag == 5) {
    pickerTarget = textField;
  }
 
  // Set the current date for the picker
  if (textField.tag == 1 || textField.tag == 5) {
    if([textField.text length] != 0) {
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateFormat:@"MM/dd/yy hh:mm a"];
      NSDate *dateOfCurrentTextField = [dateFormatter dateFromString:textField.text];
    
      if (dateOfCurrentTextField) {
        [(UIDatePicker *)textField.inputView setDate:dateOfCurrentTextField];
      }
    }
  }

  else if (textField.tag == 0) {
    [physicianPicker selectRow:0 inComponent:0 animated:NO];
  }
  
  else if (textField.tag == 2) {
    [caregiverPicker selectRow:0 inComponent:0 animated:NO];
  }
  
  return YES;
}

#pragma mark -
#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];

  if (!self.appointment) {
    self.title = @"Add Appointment";    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancel;
  } else {
    self.title = @"Edit Appointment";
    [self setFormData:[self.appointment toDictionary]];
  }

  // Filter simple contacts for caregivers
  NSPredicate *caregiversPredicate = [NSPredicate predicateWithFormat:@"type = %@", @"caregiver"];
  caregivers = [self.patient.simpleContacts filteredSetUsingPredicate:caregiversPredicate];

  // For elements that are subclasses of UIScrollView disable
  // scrollToTop so tableView scrolls when tapping status bar
  self.purpose.scrollsToTop = NO;
  self.results.scrollsToTop = NO;

  // Make physician field use a picker by default, with optional keyboard usage with toolbar button
  physicianPicker = [[UIPickerView alloc] init];
  physicianPicker.tag = 0;
  physicianPicker.delegate = self;
  physicianPicker.showsSelectionIndicator = YES;

  caregiverPicker = [[UIPickerView alloc] init];
  caregiverPicker.tag = 1;
  caregiverPicker.delegate = self;
  caregiverPicker.showsSelectionIndicator = YES;
  
  // Add toolbar to the physican and caregiver pickers
  keyboardToolbar = [[UIToolbar alloc] init];
  [keyboardToolbar setBarStyle:UIBarStyleBlackTranslucent];
  [keyboardToolbar sizeToFit];

  pickerToolbar = [[UIToolbar alloc] init];
  [pickerToolbar setBarStyle:UIBarStyleBlackTranslucent];
  [pickerToolbar sizeToFit];

  // Setup toolbars for switching between picker and keyboard
  UIBarButtonItem *flexspace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
  UIBarButtonItem *keyboardButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showKeyboardView:)];
  UIBarButtonItem *pickerButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(showPickerView:)];
  NSArray *keyboardToolbarButtons = [NSArray arrayWithObjects:flexspace, keyboardButton, nil];
  NSArray *pickerToolbarButtons   = [NSArray arrayWithObjects:flexspace, pickerButton, nil];

  [keyboardToolbar setItems:keyboardToolbarButtons];
  [pickerToolbar setItems:pickerToolbarButtons];
  
  // Only give option to switch between picker and keyboard if there are things to pick
  if (self.patient.phonebookContacts.count > 0) {
    self.physician.inputView = physicianPicker;
    [self.physician setInputAccessoryView:keyboardToolbar];
  }

  if (caregivers.count > 0) {
    self.caregiver.inputView = caregiverPicker;
    [self.caregiver setInputAccessoryView:keyboardToolbar];
  }

  // Make the app date and next app date fields use a datetime picker instead of keyboard
  UIDatePicker *datePicker = [[UIDatePicker alloc] init]; 
  datePicker.datePickerMode = UIDatePickerModeDateAndTime;
  [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
  self.dateTime.inputView = datePicker;
  self.nextDateTime.inputView = datePicker;  
}

- (void)viewDidUnload
{
  [self setPurpose:nil];
  [self setPhysician:nil];
  [self setDateTime:nil];
  [self setCaregiver:nil];
  [self setResults:nil];
  [self setNextDateTime:nil];
  [super viewDidUnload];
}

@end
