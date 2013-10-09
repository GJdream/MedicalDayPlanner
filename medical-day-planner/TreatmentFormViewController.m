//
//  TreatmentFormViewController.m
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/12/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "TreatmentFormViewController.h"
#import "Patient.h"
#import "PhoneBookContact.h"

enum {
  PickerViewPhysicianPicker
} PickerView;

@interface TreatmentFormViewController ()
{
  UITextField *pickerTarget;
  UIPickerView *physicianPicker;
  UIToolbar *keyboardToolbar;
  UIToolbar *pickerToolbar;
}
@end

@implementation TreatmentFormViewController

@synthesize patient;
@synthesize treatment;

@synthesize treatmentText;
@synthesize startDate;
@synthesize endDate;
@synthesize physician;
@synthesize facility;
@synthesize sideEffects;

#pragma mark - 
#pragma mark - Target actions 

- (IBAction)save:(id)sender
{  
  if (!self.treatment) {
    [self dismissViewControllerAnimated:YES completion:nil];
    [Treatment createTreatmentWithInfo:[self gatheredFormData] forPatient:self.patient inManagedObjectContext:self.managedObjectContext];
  } else {
    [Treatment modifyTreatment:self.treatment withInfo:[self gatheredFormData] inManagedObjectContext:self.managedObjectContext];
    [self.navigationController popViewControllerAnimated:YES];
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
  if (textField.tag == 1 || textField.tag == 2 || textField.tag == 3 || textField.tag == 4) {
    pickerTarget = textField;
  }

  if (textField.tag == 1 || textField.tag == 2) {
    if([textField.text length] != 0) {
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateFormat:@"MM/dd/yyyy"];
      NSDate *dateOfCurrentTextField = [dateFormatter dateFromString:textField.text];
      [(UIDatePicker *)textField.inputView setDate:dateOfCurrentTextField];
    }
  }
  
  else if (textField.tag == 3) {
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
  self.sideEffects.scrollsToTop = NO;
  
  if (!self.treatment) {
    self.title = @"Add Treatment";    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancel;
  } else {
    self.title = @"Edit Treatment";
    [self setFormData:[self.treatment toDictionary]];
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
    self.physician.inputView = physicianPicker;
      self.facility.inputView=physicianPicker;
    [self.physician setInputAccessoryView:keyboardToolbar];
       [self.facility setInputAccessoryView:keyboardToolbar];
  }
  
  // Make the start and end date fields use a date picker instead of keyboard
  UIDatePicker *datePicker = [[UIDatePicker alloc] init]; 
  datePicker.datePickerMode = UIDatePickerModeDate;
  [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
  self.startDate.inputView = datePicker;
  self.endDate.inputView = datePicker;
}

- (void)viewDidUnload
{
  [self setPatient:nil];
  [self setTreatment:nil];
  [self setTreatmentText:nil];
  [self setStartDate:nil];
  [self setEndDate:nil];
  [self setPhysician:nil];
  [self setFacility:nil];
  [self setSideEffects:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

@end
