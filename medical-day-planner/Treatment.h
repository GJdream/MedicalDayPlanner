//
//  Treatment.h
//  medical-day-planner
//
//  Created by Ram Krishna on 04/02/13.
//  Copyright (c) 2013 All Things Caregiver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Patient;

@interface Treatment : NSManagedObject

@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * facility;
@property (nonatomic, retain) NSString * physician;
@property (nonatomic, retain) NSString * sideEffects;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * treatmentText;
@property (nonatomic, retain) Patient *patient;

@end
