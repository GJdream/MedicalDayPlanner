//
//  Appointment.h
//  medical-day-planner
//
//  Created by Ram Krishna on 04/02/13.
//  Copyright (c) 2013 All Things Caregiver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Patient;

@interface Appointment : NSManagedObject

@property (nonatomic, retain) NSString * caregiver;
@property (nonatomic, retain) NSDate * dateTime;
@property (nonatomic, retain) NSDate * nextDateTime;
@property (nonatomic, retain) NSString * physician;
@property (nonatomic, retain) NSString * purpose;
@property (nonatomic, retain) NSString * results;
@property (nonatomic, retain) Patient *patient;

@end
