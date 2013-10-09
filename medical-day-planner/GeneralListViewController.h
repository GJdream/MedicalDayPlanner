//
//  GeneralListViewController.h
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/1/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "PlainCustomCell.h"
#import "Patient.h"

@interface GeneralListViewController : CoreDataTableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Patient *patient;
@property (nonatomic, strong) NSString *editSegue;

@end
