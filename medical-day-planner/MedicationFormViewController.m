//
//  MedicationFormViewController.m
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/1/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "MedicationFormViewController.h"
#import "Patient.h"
#import "PhoneBookContact.h"

enum {
  PickerViewPhysicianPicker
} PickerView;

extern NSString *notificationID;
NSString *notificationIDVal=nil;
@interface MedicationFormViewController ()
{
  UITextField *pickerTarget;
  NSString *documentsDirectory;
  UIPickerView *physicianPicker;
  UIToolbar *keyboardToolbar;
  UIToolbar *pickerToolbar;
    NSDate *pickerTime;
    NSDictionary *infoDict;
    UIDatePicker *timePicker;
    
}
@end

@implementation MedicationFormViewController

//testing date picker
@synthesize datePicker;
@synthesize patient;
@synthesize medication;
@synthesize medicationFormView;
@synthesize name;
@synthesize startDate;
@synthesize endDate;
@synthesize dosage;
@synthesize frequency;
@synthesize purpose;
@synthesize descriptionText;
@synthesize sideEffects;
@synthesize prescriptionPhysician;
@synthesize prescriptionNumber;
@synthesize pharmacy;
@synthesize generic;
@synthesize dc;
@synthesize galleryPhotos = galleryPhotos;
@synthesize photosCountLabel = _photosCountLabel;
@synthesize deletePhotos = _deletePhotos;
@synthesize alarmTime;
@synthesize alarmStatus;
@synthesize actualAlarmDate;

#pragma mark -
#pragma mark Form data gathering

- (NSDictionary *)gatheredFormData
{
  // override super to add in photos.
  NSDictionary *fields = [super gatheredFormData];
  [fields setValue:self.galleryPhotos forKey:@"photos"];
  return fields;
}

- (NSDictionary *)gatheredFormDataWithAlarmDate
{
    // override super to add in photos.
    NSDictionary *fields = [self gatheredFormData];
    if(pickerTime!=nil){
        actualAlarmDate=[self constructDate];
       // NSLog(@"[self constructDate] %@",actualAlarmDate);
        [fields setValue:actualAlarmDate forKey:@"actualAlarmDate"];
    }
    return fields;
}

#pragma mark - 
#pragma mark - Target actions

- (IBAction)save:(id)sender
{
  if (!self.medication) {
   
   [self dismissViewControllerAnimated:YES completion:nil];
     
    Medication *medicationVal=[Medication createMedicationWithInfo:[self gatheredFormDataWithAlarmDate] forPatient:self.patient inManagedObjectContext:self.managedObjectContext];
        // NSLog(@"1===%@",medicationVal);
       NSManagedObjectID *managedObjectID=medicationVal.objectID;
      NSURL *objURL = [managedObjectID URIRepresentation];
      notificationIDVal=[objURL absoluteString];
      infoDict= [NSDictionary dictionaryWithObject:notificationIDVal forKey:notificationID];
      if(pickerTime!=nil){
          [self scheduleAlarm:pickerTime];
      }
  } else {
   
    [self deletePhotoFiles:self.deletePhotos];
    Medication *medicationVal=[Medication modifyMedication:self.medication withInfo:[self gatheredFormDataWithAlarmDate] inManagedObjectContext:self.managedObjectContext];
       //  NSLog(@"2===%@",medicationVal);
      NSManagedObjectID *managedObjectID=medicationVal.objectID;
      NSURL *objURL = [managedObjectID URIRepresentation];
      notificationIDVal=[objURL absoluteString];
      if(pickerTime!=nil){
          [self scheduleAlarm:pickerTime];
      }
    [self.navigationController popViewControllerAnimated:YES];
  }   
}

- (IBAction)cancel:(id)sender
{
  // The user didn't end up saving this entity, so delete stored images, if any
  // Cancel button only available on Add form, so just remove them all

  if (self.galleryPhotos.count > 0) {
    [self deletePhotoFiles:self.galleryPhotos];
  }
  
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
-(void)timePickerValueChanged:(id)sender
{   
    pickerTime = [sender date];
    timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"hh:mm a"];
    pickerTarget.text = [timeFormatter stringFromDate:pickerTime];
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
#pragma mark - Table view delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (section == 2) {
    // If we have photos, show the gallery link/cell
    return ([self.galleryPhotos count] < 1) ? 1 : 2;
  }
  
  return [super tableView:tableView numberOfRowsInSection:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  
  if ((indexPath.section == 1 && indexPath.row == 3) || (indexPath.section==0 && indexPath.row==9)) {
    BOOL checked = (cell.accessoryType == UITableViewCellAccessoryCheckmark);
    cell.accessoryType = (checked) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
  }

  else if (indexPath.section == 2 && indexPath.row == 0) {
    // Add photo

    UIActionSheet *source_select = [[UIActionSheet alloc] initWithTitle:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:@"Take Photo", @"Choose Existing Photo", nil];
    
    source_select.tag = 0;
    [source_select showInView:self.view];    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
  }

  else if (indexPath.section == 2 && indexPath.row == 1) {
    [self showPhotoGallery];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
  }
  
  else {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
  }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
  // Only one detail indicator, so no need to check index path here
  [self showPhotoGallery];
}

#pragma mark - 
#pragma mark - Action sheet delegation

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{  
  // Action sheet handling for the source type selector
  if (actionSheet.tag == ActionSheetImageSourceType) {
    switch (buttonIndex)
    {
      case ImagePickerSourceTypeCamera:
      {
        [self displayImagePicker:UIImagePickerControllerSourceTypeCamera];
        break;
      }
      case ImagePickerSourceTypePhotoLibrary:
      {
        [self displayImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
        break;
      }
    }
  }

  // Action sheet handling for the photo delete confirmation
  else if (actionSheet.tag == ActionSheetConfirmPhotoDelete) {
    switch (buttonIndex) {
      case PhotoDeleteConfirmDelete:
        [self deleteGalleryPhoto];
        break;
    }
  }
}

#pragma mark - 
#pragma mark - Image picker handling

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

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  UIImage *image    = [info objectForKey:UIImagePickerControllerEditedImage];
  if (!image) image = [info objectForKey:UIImagePickerControllerOriginalImage];
  
  if (image) {
    [self dismissImagePicker];

    // Create unique filename
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uniqueName = (__bridge NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    NSString *fileName = [NSString stringWithFormat:@"%@.png", uniqueName];

    // Save image to bundle location
    NSString *imageFilePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
    [imageData writeToFile:imageFilePath atomically:YES];

    // Add image to array of photos for later storing in CoreData.
    [self.galleryPhotos addObject:fileName];
    [self updatePhotosCount];
    
    return;
  }
  
  [self dismissImagePicker];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [self dismissImagePicker];
}

#pragma mark - 
#pragma mark - Photo gallery handling

- (void)updatePhotosCount
{
  NSString *photosText = @"Photo";
  if (self.galleryPhotos.count != 1) {
    photosText = [photosText stringByAppendingString:@"s"];
  }  
 
  [self.tableView reloadData];
  self.photosCountLabel.text = [NSString stringWithFormat:@"%u %@", self.galleryPhotos.count, photosText];
}

- (void)confirmPhotoDelete:(id)sender
{
  UIActionSheet *confirm_select = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to delete this photo?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete Photo"
                                                    otherButtonTitles:nil];
  
  confirm_select.tag = 1;
  [confirm_select showInView:localGallery.view];
}

- (void)deleteGalleryPhoto
{
  NSError *error;
  int photoIndex = [localGallery currentIndex];
  NSString *fileName = [self.galleryPhotos objectAtIndex:photoIndex];
  
  // If we're adding a medication, delete the file immediately
  if (!self.medication) {
    NSString *imageFilePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
    [[NSFileManager defaultManager] removeItemAtPath:imageFilePath error:&error];
  }

  // otherwise, add it to a list of photos to delete upon save
  // if the save is cancelled, we don't delete the photo(s)
  else {
    [self.deletePhotos addObject:fileName];
  }

  // Remove it from the array of files and gallery
  [self.galleryPhotos removeObjectAtIndex:photoIndex];
  [localGallery removeImageAtIndex:[localGallery currentIndex]];
  
  // Update photos label
  [self updatePhotosCount];

  // No more photos in the gallery, go back to form
  if ([self.galleryPhotos count] < 1) {
    [self.navigationController popViewControllerAnimated:YES];
  }
}

- (void)deletePhotoFiles:(NSArray *)filenames
{
  NSError *error;
  for (NSString *fileName in filenames) {
    NSString *imageFilePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
    [[NSFileManager defaultManager] removeItemAtPath:imageFilePath error:&error]; 
  }
}

- (void)showPhotoGallery
{
  UIImage *trashIcon = [UIImage imageNamed:@"photo-gallery-trashcan.png"];
  UIBarButtonItem *trashButton = [[UIBarButtonItem alloc] initWithImage:trashIcon style:UIBarButtonItemStylePlain target:self action:@selector(confirmPhotoDelete:)];
  UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

  NSArray *barItems = [NSArray arrayWithObjects: flexSpace, trashButton, nil];  
  localGallery = [[FGalleryViewController alloc] initWithPhotoSource:self barItems:barItems];
  [self.navigationController pushViewController:localGallery animated:YES];
}

- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController*)gallery
{
  return [self.galleryPhotos count];
}

- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController*)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
  return FGalleryPhotoSourceTypeLocal;
}

- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index
{
  return [self.galleryPhotos objectAtIndex:index];
}

#pragma mark - 
#pragma mark - Text field delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
  // Set the current date for the picker
     if (textField.tag == 1 || textField.tag == 2 || textField.tag == 8) {
    pickerTarget = textField;
  }

  if (textField.tag == 1 || textField.tag == 2 )
  {
    if([textField.text length] != 0)
    {
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateFormat:@"MM/dd/yyyy"];
      NSDate *dateOfCurrentTextField = [dateFormatter dateFromString:textField.text];
      [(UIDatePicker *)textField.inputView setDate:dateOfCurrentTextField];
    }
      
  }
   if (textField.tag == 8)
    {
        if([textField.text length] != 0)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"hh:mm a"];
            NSDate *dateOfCurrentTextField = [dateFormatter dateFromString:textField.text];
            if (dateOfCurrentTextField)
            {
                [(UIDatePicker *)textField.inputView setDate:dateOfCurrentTextField];
            }
        }

    }
  
      
  return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  // Hide the keyboard when enter key press on pharmacy field
  if (textField.tag == 10) {
    [textField resignFirstResponder];
  }
  
  return [super textFieldShouldReturn:textField];
}


#pragma mark - 
#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];

  // For elements that are subclasses of UIScrollView disable
  // scrollToTop so tableView scrolls when tapping status bar
  self.purpose.scrollsToTop = NO;
  self.descriptionText.scrollsToTop = NO;
  self.sideEffects.scrollsToTop = NO;
  
  if (!self.medication)
  {
    self.title = @"Add Medication";
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancel;
  }
  else
  {
      
    self.title = @"Edit Medication";
      NSDictionary *dict=[self.medication toDictionary];
     // NSLog(@"[self.medication toDictionary] %@ ",dict);
      [self setFormData:dict];  
      
      pickerTime = [[self.medication toDictionary] valueForKey:@"alarmTime"] ;
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
    self.prescriptionPhysician.inputView = physicianPicker;
    [self.prescriptionPhysician setInputAccessoryView:keyboardToolbar];
  }

  // Grab bundle location for save path    
  documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  
  // Initialize photos array
  self.galleryPhotos = [[NSMutableArray alloc] init];
  self.deletePhotos  = [[NSMutableArray alloc] init];

  // Setup gallery photos array if the medication already has photos
  if (self.medication.photos && self.galleryPhotos.count == 0) {
    [self.galleryPhotos addObjectsFromArray:self.medication.photoFilenames];
  }

  // Update the count if needed
  [self updatePhotosCount];
  
  // Make the start and end date fields use a date picker instead of keyboard
  datePicker = [[UIDatePicker alloc] init]; 
  datePicker.datePickerMode = UIDatePickerModeDate;
  [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
  self.startDate.inputView = datePicker;
  self.endDate.inputView = datePicker;
    
  
  timePicker = [[UIDatePicker alloc] init];
    
    timePicker.datePickerMode = UIDatePickerModeTime;
    [timePicker addTarget:self action:@selector(timePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.alarmTime.inputView = timePicker;
   
  
}

-(NSDate *)constructDate{
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    
	// Get the current date
	NSDate *currentDate = pickerTime;
    NSDate *currentAlarmDate = [NSDate date];
    NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit )
												   fromDate:currentAlarmDate];
	NSDateComponents *timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit )
												   fromDate:currentDate];
    
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setDay:[dateComponents day]];
    [dateComps setMonth:[dateComponents month]];
    [dateComps setYear:[dateComponents year]];
    [dateComps setHour:[timeComponents hour]];
	
    [dateComps setMinute:[timeComponents minute]];
	[dateComps setSecond:[timeComponents second]];
    
    return [calendar dateFromComponents:dateComps];
}

-(NSDate *)constructEndDate:(NSDate *)edate{
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    
    NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit )
												   fromDate:edate];

    
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setDay:[dateComponents day]];
    [dateComps setMonth:[dateComponents month]];
    [dateComps setYear:[dateComponents year]];
    [dateComps setHour:23];
	
    [dateComps setMinute:59];
	[dateComps setSecond:59];
    
    return [calendar dateFromComponents:dateComps];
}
- (void) scheduleAlarm:alarmtime
{      
	
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    NSDate *edate =  [self constructEndDate:[dateFormatter dateFromString:endDate.text]];
    NSDate *sdate=[dateFormatter dateFromString:startDate.text];
     NSDate *currDate= [NSDate date];
    UILocalNotification *localNotif;
      if (!self.medication) {
          localNotif = [[UILocalNotification alloc] init];
          localNotif.userInfo = infoDict;
          
      }else{
          UILocalNotification *cancelThisNotification = nil;
          BOOL hasNotification = NO;
          for (UILocalNotification *someNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
              if([[someNotification.userInfo objectForKey:notificationID] isEqualToString:notificationIDVal]) {
                            cancelThisNotification=someNotification;
                  hasNotification = YES;
                  break;
              }
          }
          if (hasNotification == YES) {
            localNotif = cancelThisNotification;
              [[UIApplication sharedApplication] cancelLocalNotification:cancelThisNotification];
              
          }else{             
              if (nil==localNotif ){
                  localNotif = [[UILocalNotification alloc] init];
                  localNotif.userInfo = infoDict;
              }
          }
      }

    if (localNotif == nil)
        return;
    
    if (([sdate compare:edate] != NSOrderedDescending) && ([actualAlarmDate compare:edate] != NSOrderedDescending) && ([actualAlarmDate compare:currDate]!=NSOrderedAscending))
    {
        localNotif.fireDate =actualAlarmDate;
        
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
        
        NSString *alertBody=[NSString stringWithFormat:@"%@ medication time",name.text];
        localNotif.alertBody = alertBody;
        
        
        localNotif.alertAction = @"View";
        
        [localNotif setRepeatInterval:NSDayCalendarUnit];
        
      //  localNotif.soundName = UILocalNotificationDefaultSoundName;
          localNotif.soundName = @"alarm.wav";
        localNotif.applicationIconBadgeNumber=[[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    }
    
  	// Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
//    NSLog(@"notification id val== %@",notificationIDVal);
//    NSLog(@"count== %d",[[UIApplication sharedApplication] scheduledLocalNotifications].count);
}

-(void)turnoffAlarm:(UILocalNotification*)notification
{
    [[UIApplication sharedApplication] cancelLocalNotification:notification];
}

//-(void)getFormtedDate:date:str
//{
//    NSDate *today = date;
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"dd/MM/yyyy hh:mm:ss:aa"];
//    NSString *dateString = [dateFormat stringFromDate:today];
//   // NSLog(@"date: %@   ==  %@",str, dateString);
//}


- (void)viewDidUnload
{
  [self setPatient:nil];
  [self setMedication:nil];
  [self setName:nil];
  [self setStartDate:nil];
  [self setEndDate:nil];
  [self setDosage:nil];
  [self setFrequency:nil];
  [self setDescriptionText:nil];
  [self setPurpose:nil];
  [self setSideEffects:nil];
  [self setPrescriptionPhysician:nil];
  [self setPrescriptionNumber:nil];
  [self setPharmacy:nil];
  [self setGeneric:nil];
  [self setPhotosCountLabel:nil];
  [self setGalleryPhotos:nil];
  [self setDeletePhotos:nil];
  [self setAlarmTime:nil];
  [self setAlarmStatus:nil];
  [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear: animated];

  // If we're editing an existing medication and
  // back button was pressed, need to delete photos not saved
  if (self.medication && [self.navigationController.viewControllers indexOfObjectIdenticalTo: self] == NSNotFound)
  {
    [self.galleryPhotos removeObjectsInArray:self.medication.photoFilenames];
    [self deletePhotoFiles:self.galleryPhotos];
  }
}

#pragma mark - 
#pragma mark - Memory handling

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
}

@end
