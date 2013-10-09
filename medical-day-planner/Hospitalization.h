//
//  Hospitalization.h
//  medical-day-planner
//
//  Created by Ram Krishna on 04/02/13.
//  Copyright (c) 2013 All Things Caregiver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Patient;

@interface Hospitalization : NSManagedObject

@property (nonatomic, retain) NSDate * admitDate;
@property (nonatomic, retain) NSString * admitPhysician;
@property (nonatomic, retain) NSDate * dischargeDate;
@property (nonatomic, retain) NSString * facility;
@property (nonatomic, retain) NSString * outcome;
@property (nonatomic, retain) NSString * symptoms;
@property (nonatomic, retain) Patient *patient;

@end
