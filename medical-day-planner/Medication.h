//
//  Medication.h
//  medical-day-planner
//
//  Created by Ram Krishna on 06/02/13.
//  Copyright (c) 2013 All Things Caregiver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MedicationPhoto, Patient;

@interface Medication : NSManagedObject

@property (nonatomic, retain) NSDate * actualAlarmDate;
@property (nonatomic, retain) NSDate * alarmTime;
@property (nonatomic, retain) NSNumber * dc;
@property (nonatomic, retain) NSString * descriptionText;
@property (nonatomic, retain) NSString * dosage;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * frequency;
@property (nonatomic, retain) NSNumber * generic;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pharmacy;
@property (nonatomic, retain) NSString * prescriptionNumber;
@property (nonatomic, retain) NSString * prescriptionPhysician;
@property (nonatomic, retain) NSString * purpose;
@property (nonatomic, retain) NSString * sideEffects;
@property (nonatomic, retain) NSDate * startDate;

@property (nonatomic, retain) Patient *patient;
@property (nonatomic, retain) NSSet *photos;
@end

@interface Medication (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(MedicationPhoto *)value;
- (void)removePhotosObject:(MedicationPhoto *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
