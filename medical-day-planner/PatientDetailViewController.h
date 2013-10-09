//
//  PatientDetailViewController.h
//  The Medical Day Planner
//
//  Created by Ronnie Miller on 6/7/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"

enum {
  ActionSheetButtonDelete,
  ActionSheetButtonCancel
} ActionSheetButton;

@interface PatientDetailViewController : UITableViewController <UIActionSheetDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) Patient *patient;

@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UIView *tableHeader;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UITableViewCell *phoneBookCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *medicationsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *appointmentsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *treatmentsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *proceduresCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *testsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *hospitalizationsCell;

- (IBAction)delete:(id)sender;
- (IBAction)callPatient:(id)sender;
- (void)patientUpdated:(Patient *)patient;

@end
