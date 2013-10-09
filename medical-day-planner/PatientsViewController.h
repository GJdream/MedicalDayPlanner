//
//  PatientsViewController.h
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/15/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient+Methods.h"

@interface PatientsViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray *patients;
@property (nonatomic, strong) Patient *createdPatient;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (void)viewPatient:(id)sender;
- (void)patientCreated:(Patient *)newPatient;

@end
