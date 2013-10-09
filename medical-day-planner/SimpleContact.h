//
//  SimpleContact.h
//  medical-day-planner
//
//  Created by Ram Krishna on 04/02/13.
//  Copyright (c) 2013 All Things Caregiver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Patient;

@interface SimpleContact : NSManagedObject

@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phoneCell;
@property (nonatomic, retain) NSString * phoneHome;
@property (nonatomic, retain) NSString * phoneWork;
@property (nonatomic, retain) NSString * policyNumber;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Patient *patient;

@end
