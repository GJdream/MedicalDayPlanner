//
//  PatientsViewController.m
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/15/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PatientsViewController.h"
#import "PatientDetailViewController.h"
#import "PatientFormViewController.h"

@interface PatientsViewController ()
{
  UIButton *activeButton;
}
@end

@implementation PatientsViewController

@synthesize managedObjectContext = __managedObjectContext;
@synthesize patients;
@synthesize createdPatient;
@synthesize scrollView;

#pragma mark -
#pragma mark - Target actions

- (void)viewPatient:(id)sender
{
  activeButton = sender;
  [self performSegueWithIdentifier:@"viewPatient" sender:self];
}

#pragma mark -
#pragma mark - View lifecycle

- (void)didRotate:(NSNotification *)notification
{
  [self drawPatients];
}

- (void)drawPatients
{
  [scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

  int tagNumber = 0;
  CGFloat xPos = (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) ? 14.0f : 95.0f;
  CGFloat yPos = 20.0f;
  CGFloat contentSize = 0;
  
  if (self.patients != nil) {
    for (Patient *patient in self.patients) {
      // Create patient image
      UIImageView *patientImage = [[UIImageView alloc] initWithFrame:CGRectMake(xPos + 30.0f, yPos + 17.0f, 230, 200)];
      patientImage.image = [patient parsedPhoto];
      patientImage.contentMode = UIViewContentModeScaleAspectFill;
      patientImage.clipsToBounds = YES;
      [self.scrollView addSubview:patientImage];

      CALayer *imageLayer = patientImage.layer;
      //[imageLayer setCornerRadius:35];
      [imageLayer setBorderWidth:3];
      [imageLayer setBorderColor:[[UIColor whiteColor] CGColor]];
      
      // Create patient name label
      UILabel *label        = [[UILabel alloc] initWithFrame:CGRectMake(xPos + 30.0f, yPos + 220.0f, 230, 35)];
      label.textColor       = [UIColor colorWithRed:0.88f green:0.94f blue:0.96f alpha:1.00f];
      label.font            = [UIFont boldSystemFontOfSize:20];
      label.textAlignment   = ALIGN_CENTER;
      label.backgroundColor = [UIColor clearColor];
      label.shadowColor     = [UIColor colorWithRed:0.00f green:0.14f blue:0.22f alpha:1.00f];
      label.shadowOffset    = CGSizeMake(1.0f, 1.0f);
      label.text            = patient.name;
      [self.scrollView addSubview:label];
      
      // Create button
      UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
      button.backgroundColor = [UIColor clearColor];
      button.frame = CGRectMake(xPos + 30.0f, yPos, 230, 250);
      button.tag = tagNumber;
      [button addTarget:self action:@selector(viewPatient:) forControlEvents:UIControlEventTouchUpInside];
      tagNumber++;
      [self.scrollView addSubview:button];
      
      yPos += 260;
      contentSize += 260;
    }
    
    self.scrollView.contentSize = CGSizeMake(320, contentSize + 30);
  }

  if(self.patients == nil || self.patients.count == 0) {
    NSString *filename = (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) ? @"firstpatient" : @"firstpatient_landscape";
    CGRect frame = (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) ? CGRectMake(0, 0, 320, 480) : CGRectMake(0, 0, 480, 320);
    UIImageView *createFirstPatient = [[UIImageView alloc] initWithFrame:frame];
    createFirstPatient.image = [UIImage imageNamed:filename];
    [self.scrollView addSubview:createFirstPatient];
  }
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // Load patients
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Patient"];
  request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
  
  NSError *error;
  self.patients = [self.managedObjectContext executeFetchRequest:request error:&error];
  
  [self drawPatients];
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  // Custom back button
  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];

  // Set background
  UIColor *pattern = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tableview_bg"]];
  [self.scrollView  setBackgroundColor:pattern];
  
  // Watch for rotations
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

- (void)viewDidUnload
{
  [self setScrollView:nil];
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
  return YES;
}

#pragma mark - 
#pragma mark - Delegation methods

- (void)patientCreated:(Patient *)newPatient
{
  self.createdPatient = newPatient;
  [self performSegueWithIdentifier:@"viewPatient" sender:self];
}

#pragma mark -
#pragma mark - Segue preparations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"viewPatient"])
  {
    Patient *patient;
    PatientDetailViewController *vc = [segue destinationViewController];

    if (activeButton) {
      patient = [self.patients objectAtIndex:activeButton.tag];
      activeButton = nil;
    } else {
      patient = self.createdPatient;
    }

    [vc setManagedObjectContext:self.managedObjectContext];
    [vc setPatient:patient];
  }
  
  else if ([[segue identifier] isEqualToString:@"addPatient"])
  {
    // Get reference to the destination view controller
    UINavigationController *vc = [segue destinationViewController];
    PatientFormViewController *form = [[vc childViewControllers] lastObject];
    [form setManagedObjectContext:self.managedObjectContext];
    [form setDelegate:self];
  }
}

@end
