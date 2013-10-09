//
//  PatientFormViewController.m
//  The Medical Day Planner
//
//  Created by Ronnie L Miller on 6/3/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "PatientsViewController.h"
#import "PatientFormViewController.h"
#import "PatientDetailViewController.h"

extern NSString *notificationID;
@interface PatientFormViewController ()
{
  BOOL hasPhoto;
  NSArray *bloodTypes;
}

@end

@implementation PatientFormViewController

@synthesize patient;
@synthesize delegate;

@synthesize photo;
@synthesize photoLabel;

@synthesize name;
@synthesize phoneHome;
@synthesize phoneWork;
@synthesize phoneCell;
@synthesize email;
@synthesize bloodPicker;
@synthesize workPhoneCell;
@synthesize cellPhoneCell;
@synthesize homePhoneCell;
@synthesize address;

@synthesize dobDate;
@synthesize bloodType;
@synthesize knownAllergies;
@synthesize dietaryRestrictions;
@synthesize diagnosis;
@synthesize notes;

#pragma mark -
#pragma mark Form data gathering

- (NSDictionary *)gatheredFormData
{
  // override super to add in photo.
  // must add in any non-standard text fields, text views, and other properties
  NSDictionary *fields = [super gatheredFormData];

  if (hasPhoto) {
    [fields setValue:self.photo.image forKey:@"photo"];
  }

  return fields;
}

#pragma mark - 
#pragma mark - Target actions

- (IBAction)save:(id)sender
{
  if (!self.patient) {
    Patient *newPatient = [Patient createPatientWithInfo:[self gatheredFormData] inManagedObjectContext:self.managedObjectContext];
    if ([[self delegate] respondsToSelector:@selector(patientCreated:)]) {    
      [self.delegate patientCreated:newPatient];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
  } else {
    [Patient modifyPatient:self.patient withInfo:[self gatheredFormData] inManagedObjectContext:self.managedObjectContext];
    if ([[self delegate] respondsToSelector:@selector(patientUpdated:)]) {
      [self.delegate patientUpdated:self.patient];
    }
    [self.navigationController popViewControllerAnimated:YES];
  }
}

- (IBAction)cancel:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)datePickerValueChanged:(id)sender
{
  NSDate *pickerDate = [sender date];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"MM/dd/yyyy"];
  self.dobDate.text = [formatter stringFromDate:pickerDate];
}

#pragma mark - 
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 0 && indexPath.row == 0) {    
    NSString *delete_text = nil;
    
    if (hasPhoto) {
      delete_text = @"Delete Photo";
    }

    UIActionSheet *source_select = [[UIActionSheet alloc] initWithTitle:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:@"Take Photo", @"Choose Existing Photo", delete_text, nil];
    
    [source_select showInView:self.view];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  }
  
  else {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
  }
}

#pragma mark - 
#pragma mark - Image picker handling

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex)
	{
		case 0:
		{
      [self displayImagePicker:UIImagePickerControllerSourceTypeCamera];
			break;
		}
		case 1:
		{
      [self displayImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
			break;
		}
    case 2:
    {
      self.photo.image = [UIImage imageNamed:@"choosephoto"];
      self.photoLabel.text = @"Add Photo";
      hasPhoto = NO;
			break;      
    }
	}
}

- (void)displayImagePicker:(UIImagePickerControllerSourceType)sourceType
{
  UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
  imagePicker.delegate = self;
  imagePicker.allowsEditing = YES;
  imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
  imagePicker.sourceType = sourceType;
  [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)dismissImagePicker
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

#define MAX_IMAGE_WIDTH 60

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  UIImage *image    = [info objectForKey:UIImagePickerControllerEditedImage];
  if (!image) image = [info objectForKey:UIImagePickerControllerOriginalImage];

  if (image) {
    [self dismissImagePicker];
    self.photo.image = image;
    self.photoLabel.text = @"Change Photo";
    hasPhoto = YES;
    return;
  }
  
  [self dismissImagePicker];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [self dismissImagePicker];
}

#pragma mark -
#pragma mark - Extra Textfield delegates

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  // Only do formatting for the phone number fields
  NSArray *phoneFields = [NSArray arrayWithObjects: [NSNumber numberWithInt:1], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3], nil];  
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
  // Set the current date for the picker
  if (textField.tag == 6 && [textField.text length] != 0) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *dateOfCurrentTextField = [dateFormatter dateFromString:self.dobDate.text];
    [(UIDatePicker *)textField.inputView setDate:dateOfCurrentTextField];
  }

  return YES;
}

#pragma mark - 
#pragma mark - Picker delegates

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
  NSString *type = [self pickerView:self.bloodPicker titleForRow:[self.bloodPicker selectedRowInComponent:0] forComponent:0];
  NSString *sign = [self pickerView:self.bloodPicker titleForRow:[self.bloodPicker selectedRowInComponent:1] forComponent:1];

  if (row == 0) {
    [self.bloodPicker selectRow:0 inComponent:0 animated:YES];
    [self.bloodPicker selectRow:0 inComponent:1 animated:YES];
    type = [self pickerView:self.bloodPicker titleForRow:[self.bloodPicker selectedRowInComponent:0] forComponent:0];
    sign = [self pickerView:self.bloodPicker titleForRow:[self.bloodPicker selectedRowInComponent:1] forComponent:1];
  }
  
  else if (component == 0 && [sign length] == 0) {
    [self.bloodPicker selectRow:1 inComponent:1 animated:YES];
    sign = [self pickerView:self.bloodPicker titleForRow:[self.bloodPicker selectedRowInComponent:1] forComponent:1];
  }
                                                          
  else if (component == 1 && [type length] == 0) {
    [self.bloodPicker selectRow:1 inComponent:0 animated:YES];
    type = [self pickerView:self.bloodPicker titleForRow:[self.bloodPicker selectedRowInComponent:0] forComponent:0];
  }
  
  self.bloodType.text = [NSString stringWithFormat:@"%@%@", type, sign];
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  if (component == 0) {
    return 5;
  } else {
    return 3;
  }
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 2;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  if (row == 0) {
    return @"";
  } else if (component == 0) {
    return [bloodTypes objectAtIndex:row];
  } else {
    return (row == 1) ? @"-" : @"+";
  }
}

#pragma mark - 
#pragma mark - View lifecycle

- (NSArray *)textFieldsForKeyboardControls
{
  return [NSArray arrayWithObjects:self.name, self.phoneHome, self.phoneWork, self.phoneCell, self.email, self.address, self.dobDate, 
          self.bloodType, self.knownAllergies, self.dietaryRestrictions, self.diagnosis, nil];
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  // For elements that are subclasses of UIScrollView disable
  // scrollToTop so tableView scrolls when tapping status bar
  self.address.scrollsToTop = NO;
  self.knownAllergies.scrollsToTop = NO;
  self.dietaryRestrictions.scrollsToTop = NO;
  self.diagnosis.scrollsToTop = NO;
  
  if (!self.patient) {
    self.title = @"Add Patient";    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancel;
  } else {
    self.title = @"Edit Patient";
    [self setFormData:[self.patient toDictionary]];

    if (self.patient.photo) {
      self.photo.image = [self.patient parsedPhoto];
      self.photoLabel.text = @"Change Photo";
    }
  }

  // Check if we have a photo already
  hasPhoto = !!self.patient.photo;

  // Make the DOB field use a date picker instead of keyboard
  UIDatePicker *datePicker = [[UIDatePicker alloc] init]; 
  datePicker.datePickerMode = UIDatePickerModeDate;
  [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
  self.dobDate.inputView = datePicker;

  // Make the blood type field use a picker
  bloodTypes = [NSArray arrayWithObjects:@"", @"O", @"A", @"B", @"AB", nil];
  self.bloodPicker = [[UIPickerView alloc] init];
  self.bloodPicker.delegate = self;
  self.bloodPicker.showsSelectionIndicator = YES;
  self.bloodType.inputView = self.bloodPicker;
}

- (void)viewDidUnload
{
  [self setPhoto:nil];
  [self setPhotoLabel:nil];

  [self setName:nil];
  [self setPhoneHome:nil];
  [self setPhoneWork:nil];
  [self setPhoneCell:nil];
  [self setEmail:nil];
  [self setAddress:nil];
  
  [self setDobDate:nil];
  [self setBloodType:nil];
  [self setKnownAllergies:nil];
  [self setDietaryRestrictions:nil];
  [self setDiagnosis:nil];  
  [self setBloodPicker:nil];
  
  [self setHomePhoneCell:nil];
  [self setWorkPhoneCell:nil];
  [self setCellPhoneCell:nil];

  [super viewDidUnload];
}

#pragma mark - 
#pragma mark - Memory handling

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
}

@end
