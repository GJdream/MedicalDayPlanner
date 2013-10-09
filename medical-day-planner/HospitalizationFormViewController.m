//
//  HospitalizationFormViewController.m
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/12/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "HospitalizationFormViewController.h"
#import "Patient.h"
#import "PhoneBookContact.h"

enum {
  PickerViewPhysicianPicker
} PickerView;

@interface HospitalizationFormViewController ()
{
  UITextField *pickerTarget;
  UIPickerView *physicianPicker;
  UIToolbar *keyboardToolbar;
  UIToolbar *pickerToolbar;
}
@end

@implementation HospitalizationFormViewController

@synthesize patient;
@synthesize hospitalization;

@synthesize admitDate;
@synthesize dischargeDate;
@synthesize admitPhysician;
@synthesize facility;
@synthesize symptoms;
@synthesize outcome;

#pragma mark - 
#pragma mark - Target actions 

- (IBAction)save:(id)sender
{
  // Make sure an admit date is given
  if (self.admitDate.text.length == 0) {
    UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Admit Date Needed" message:@"Please enter the date the patient was admitted." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [error show];
  } else {
    if (!self.hospitalization) {
      [self dismissViewControllerAnimated:YES completion:nil];
      [Hospitalization createHospitalizationWithInfo:[self gatheredFormData] forPatient:self.patient inManagedObjectContext:self.managedObjectContext];
    } else {
      [Hospitalization modifyHospitalization:self.hospitalization withInfo:[self gatheredFormData] inManagedObjectContext:self.managedObjectContext];
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
  pickerTarget.inputView = physicianPicker;
  pickerTarget.inputAccessoryView = keyboardToolbar;
  [pickerTarget becomeFirstResponder];  
}

#pragma mark -
#pragma mark - Date picker handling

- (void)datePickerValueChanged:(id)sender
{
  NSDate *pickerDate = [sender date];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"MM/dd/yyyy"];  
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
  // Set the current date for the picker
  if (textField.tag == 0 || textField.tag == 1 || textField.tag == 2 || textField.tag == 3) {
    pickerTarget = textField;
  }
  
  if (textField.tag == 0 || textField.tag == 1) {
    if([textField.text length] != 0) {
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateFormat:@"MM/dd/yyyy"];
      NSDate *dateOfCurrentTextField = [dateFormatter dateFromString:textField.text];
      [(UIDatePicker *)textField.inputView setDate:dateOfCurrentTextField];
    }
  }
  
  else if (textField.tag == 2) {
    [physicianPicker selectRow:0 inComponent:0 animated:NO];
  }
  
  return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{  
  return [super textFieldShouldReturn:textField];
}

#pragma mark - 
#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // For elements that are subclasses of UIScrollView disable
  // scrollToTop so tableView scrolls when tapping status bar
  self.symptoms.scrollsToTop = NO;
  self.outcome.scrollsToTop = NO;

  if (!self.hospitalization) {
    self.title = @"Add Hospitalization";    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancel;
  } else {
    self.title = @"Edit Hospitalization";
    [self setFormData:[self.hospitalization toDictionary]];
  }

  // Make physician field use a picker by default, with optional keyboard usage with toolbar button
  physicianPicker = [[UIPickerView alloc] init];
  physicianPicker.tag = 0;
  physicianPicker.delegate = self;
  physicianPicker.showsSelectionIndicator = YES;

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
    self.admitPhysician.inputView = physicianPicker;
      self.facility.inputView=physicianPicker;
    [self.admitPhysician setInputAccessoryView:keyboardToolbar];
       [self.facility setInputAccessoryView:keyboardToolbar];
  }
  
  // Make the start and end date fields use a date picker instead of keyboard
  UIDatePicker *datePicker = [[UIDatePicker alloc] init]; 
  datePicker.datePickerMode = UIDatePickerModeDate;
  [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
  self.admitDate.inputView = datePicker;
  self.dischargeDate.inputView = datePicker;
}

- (void)viewDidUnload
{
  [self setPatient:nil];
  [self setHospitalization:nil];
  [self setAdmitDate:nil];
  [self setDischargeDate:nil];
  [self setAdmitPhysician:nil];
  [self setFacility:nil];
  [self setSymptoms:nil];
  [self setOutcome:nil];
  [super viewDidUnload];
}

@end
