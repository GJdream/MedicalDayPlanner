//
//  DirectivesFormViewController.h
//  The Medical Day Planner
//
//  Created by Ronnie Miller on 6/14/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormViewController.h"
#import "Patient.h"

@interface DirectivesFormViewController : FormViewController <UITextFieldDelegate>

@property (nonatomic, strong) Patient *patient;

@property (weak, nonatomic) IBOutlet UITextField *attorney;
@property (weak, nonatomic) IBOutlet UITextField *attorneyPhone;

@property (weak, nonatomic) IBOutlet UITextField *dpoaName;
@property (weak, nonatomic) IBOutlet UITextField *dpoaPhoneHome;
@property (weak, nonatomic) IBOutlet UITextField *dpoaPhoneWork;
@property (weak, nonatomic) IBOutlet UITextField *dpoaPhoneCell;
@property (weak, nonatomic) IBOutlet UITextField *dpoaRelationship;

@property (weak, nonatomic) IBOutlet UITableViewCell *livingWill;
@property (weak, nonatomic) IBOutlet UITableViewCell *dnr;
@property (weak, nonatomic) IBOutlet UITableViewCell *dni;
@property (weak, nonatomic) IBOutlet UITableViewCell *dpoa;
@property (weak, nonatomic) IBOutlet UITableViewCell *trust;

@end
