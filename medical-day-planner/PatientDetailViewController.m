//
//  PatientDetailViewController.m
//  The Medical Day Planner
//
//  Created by Ronnie Miller on 6/7/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "PatientDetailViewController.h"
#import "Patient+Methods.h"
extern NSString *notificationID;
@interface PatientDetailViewController ()
- (void)setupView;
@end

@implementation PatientDetailViewController

@synthesize managedObjectContext = __managedObjectContext;
@synthesize patient;

@synthesize photo;
@synthesize tableHeader;
@synthesize name;
@synthesize phone;
@synthesize deleteButton;
@synthesize phoneBookCell;
@synthesize medicationsCell;
@synthesize appointmentsCell;
@synthesize treatmentsCell;
@synthesize proceduresCell;
@synthesize testsCell;
@synthesize hospitalizationsCell;

#pragma mark - 
#pragma mark - Target Actions

- (IBAction)delete:(id)sender
{
  UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to delete this patient?\nAll related data will be removed."
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                       destructiveButtonTitle:@"Delete Patient"
                                            otherButtonTitles:nil];
  [sheet showInView:self.view];  
}


- (IBAction)callPatient:(id)sender {
  NSString *phoneNumber = self.patient.availablePhone;
  NSString *cleanedString = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
  NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", escapedPhoneNumber]];
  [[UIApplication sharedApplication] openURL:telURL];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == ActionSheetButtonDelete) {
      if(self.patient.medications.count>0){
         if([[UIApplication sharedApplication] scheduledLocalNotifications].count>0){
              for (UILocalNotification *someNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
                  NSSet *medicationsSet=self.patient.medications;
                  for (NSManagedObject *medication in medicationsSet){
                      NSManagedObjectID *managedObjectID=medication.objectID;
                      NSURL *objURL = [managedObjectID URIRepresentation];
                      NSString *notificationIDVal=[objURL absoluteString];
                      
                      
                      if([[someNotification.userInfo objectForKey:notificationID] isEqualToString:notificationIDVal]) {
                          [[UIApplication sharedApplication] cancelLocalNotification:someNotification];
                          break;
                      }
                  }
              }
          }
          
          
      } 

    // Deleting user, delete the related photos as well
    [self.patient.medications makeObjectsPerformSelector:@selector(deletePhotoFiles)];
    [self.patient.tests makeObjectsPerformSelector:@selector(deletePhotoFiles)];
    
    NSError *error;
    [self.managedObjectContext deleteObject:self.patient];
    [self.managedObjectContext save:&error];
    [self.navigationController popViewControllerAnimated:YES];
  }
}

#pragma mark -
#pragma mark - View lifecycle

- (void)setupView
{
  // Set dynamic fields with patient info
  self.name.text = self.patient.name;
  self.phone.text = self.patient.availablePhone;
  self.photo.image = self.patient.parsedPhoto;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  // Update counts of related objects
  NSString *emptyCount = @"";
  self.phoneBookCell.detailTextLabel.text = (self.patient.phonebookContacts.count > 0) ? [NSString stringWithFormat:@"%u", self.patient.phonebookContacts.count] : emptyCount;
  self.medicationsCell.detailTextLabel.text = (self.patient.medications.count > 0) ? [NSString stringWithFormat:@"%u", self.patient.medications.count] : emptyCount;
  self.appointmentsCell.detailTextLabel.text = (self.patient.appointments.count > 0) ? [NSString stringWithFormat:@"%u", self.patient.appointments.count] : emptyCount;
  self.treatmentsCell.detailTextLabel.text = (self.patient.treatments.count > 0) ? [NSString stringWithFormat:@"%u", self.patient.treatments.count] : emptyCount;
  self.proceduresCell.detailTextLabel.text = (self.patient.procedures.count > 0) ? [NSString stringWithFormat:@"%u", self.patient.procedures.count] : emptyCount;
  self.testsCell.detailTextLabel.text = (self.patient.tests.count > 0) ? [NSString stringWithFormat:@"%u", self.patient.tests.count] : emptyCount;
  self.hospitalizationsCell.detailTextLabel.text = (self.patient.hospitalizations.count > 0) ? [NSString stringWithFormat:@"%u", self.patient.hospitalizations.count] : emptyCount;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setupView];

  // Setup delete button
  [self.deleteButton setBackgroundImage:[[UIImage imageNamed:@"delete_button.png"]
                                         stretchableImageWithLeftCapWidth:8.0f
                                         topCapHeight:0.0f]
                               forState:UIControlStateNormal];
  
  [self.deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  self.deleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
  self.deleteButton.titleLabel.shadowColor = [UIColor lightGrayColor];
  self.deleteButton.titleLabel.shadowOffset = CGSizeMake(0, -1);

  // Set background of tableview
  UIColor *pattern = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tableview_bg"]];
  [self.tableView setBackgroundColor:pattern];
}

- (void)viewDidUnload
{
  [self setPhoto:nil];
  [self setName:nil];
  [self setPhone:nil];
  [self setTableHeader:nil];
  [self setDeleteButton:nil];
  [self setPhoneBookCell:nil];
  [self setMedicationsCell:nil];
  [self setAppointmentsCell:nil];
  [self setTreatmentsCell:nil];
  [self setProceduresCell:nil];
  [self setTestsCell:nil];
  [self setHospitalizationsCell:nil];
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
  return YES;
}

#pragma mark - 
#pragma mark - Delegation

- (void)patientUpdated:(Patient *)aPatient
{
  self.patient = aPatient;
  [self setupView];
}

#pragma mark - Segue preparations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  // Get reference to the destination view controller
  id vc = [segue destinationViewController];
  if ([vc isKindOfClass:[UINavigationController class]]) {
    vc = [[vc childViewControllers] lastObject];
  }

  // Setup the MOC
  if ([vc respondsToSelector:@selector(setManagedObjectContext:)]) {
    [vc setManagedObjectContext:self.managedObjectContext];
  }

  // Setup the delegate
  if ([vc respondsToSelector:@selector(setDelegate:)]) {
    [vc setDelegate:self];
  }
  
  // Setup the patient
  if ([vc respondsToSelector:@selector(setPatient:)]) {
    [vc setPatient:self.patient];
  }

  // Make the back button text small
  UIBarButtonItem *newBarButtonItem = [[UIBarButtonItem alloc] init];
	newBarButtonItem.title = @"Back";
  self.navigationItem.backBarButtonItem = newBarButtonItem;
}

@end
