//
//  ProcedureFormViewController.m
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/12/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "ProcedureFormViewController.h"
#import "Patient.h"
#import "PhoneBookContact.h"

enum {
  PickerViewPhysicianPicker
} PickerView;

@interface ProcedureFormViewController ()
{
  UITextField *pickerTarget;
  UIPickerView *physicianPicker;
  UIToolbar *keyboardToolbar;
  UIToolbar *pickerToolbar;
}
@end

@implementation ProcedureFormViewController

@synthesize patient;
@synthesize procedure;

@synthesize procedureText;
@synthesize date;
@synthesize physician;
@synthesize facility;
@synthesize results;
@synthesize complications;
@synthesize suggestions;

#pragma mark - 
#pragma mark - Target actions 

- (IBAction)save:(id)sender
{  
  if (!self.procedure) {
    [self dismissViewControllerAnimated:YES completion:nil];
    [Procedure createProcedureWithInfo:[self gatheredFormData] forPatient:self.patient inManagedObjectContext:self.managedObjectContext];
  } else {
    [Procedure modifyProcedure:self.procedure withInfo:[self gatheredFormData] inManagedObjectContext:self.managedObjectContext];
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
  if (textField.tag == 1 || textField.tag == 2 || textField.tag == 3 || textField.tag == 4 ) {
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
  self.results.scrollsToTop = NO;
  self.complications.scrollsToTop = NO;
  self.suggestions.scrollsToTop = NO;
  
  if (!self.procedure) {
    self.title = @"Add Procedure";    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancel;
  } else {
    self.title = @"Edit Procedure";
    [self setFormData:[self.procedure toDictionary]];
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
  self.date.inputView = datePicker;
}

- (void)viewDidUnload
{
  [self setPatient:nil];
  [self setProcedure:nil];
  [self setProcedure:nil];
  [self setDate:nil];
  [self setPhysician:nil];
  [self setFacility:nil];
  [self setResults:nil];
  [self setComplications:nil];
  [self setSuggestions:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

@end
