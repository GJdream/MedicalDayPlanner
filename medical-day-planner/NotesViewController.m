//
//  NotesViewController.m
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/12/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "NotesViewController.h"

@interface NotesViewController ()
{
  BOOL keyboardVisible;
  id activeTextView;
}
@end

@implementation NotesViewController

@synthesize managedObjectContext;
@synthesize patient;
@synthesize patientNotes;

#pragma mark -
#pragma mark - Target actions

- (IBAction)save:(id)sender {
  self.patient.notes = self.patientNotes.text;

  NSError *error;
  [self.managedObjectContext save:&error];

  if (sender != nil) {
    [self.navigationController popViewControllerAnimated:YES];
  }
}

#pragma mark -
#pragma mark - View lifecycle

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self save:nil];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.patientNotes setText:self.patient.notes];
  [self.patientNotes becomeFirstResponder];
  [self.patientNotes setSelectedRange:NSMakeRange(0,0)];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

- (void)viewDidUnload
{
  [self setPatient:nil];
  [self setPatientNotes:nil];
  [super viewDidUnload];
}

- (void)didRotate:(NSNotification *)notification
{   
  UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];

  if (UIInterfaceOrientationIsLandscape(orientation))
    [self.patientNotes setFrame:CGRectMake(10, 10, 465, 90)];
  else
    [self.patientNotes setFrame:CGRectMake(10, 10, 305, 184)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
  if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
  {
    [self.patientNotes setFrame:CGRectMake(10, 10, 465, 90)];
  }
  return YES;
}

@end
