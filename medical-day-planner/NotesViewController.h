//
//  NotesViewController.h
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/12/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "Patient.h"

@interface NotesViewController : UIViewController

@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) Patient *patient;
@property (weak, nonatomic) IBOutlet UITextView *patientNotes;

- (IBAction)save:(id)sender;

@end
