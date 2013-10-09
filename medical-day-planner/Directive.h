//
//  Directive.h
//  medical-day-planner
//
//  Created by Ram Krishna on 04/02/13.
//  Copyright (c) 2013 All Things Caregiver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Patient;

@interface Directive : NSManagedObject

@property (nonatomic, retain) NSString * attorney;
@property (nonatomic, retain) NSString * attorneyPhone;
@property (nonatomic, retain) NSNumber * dni;
@property (nonatomic, retain) NSNumber * dnr;
@property (nonatomic, retain) NSNumber * dpoa;
@property (nonatomic, retain) NSString * dpoaName;
@property (nonatomic, retain) NSString * dpoaPhoneCell;
@property (nonatomic, retain) NSString * dpoaPhoneHome;
@property (nonatomic, retain) NSString * dpoaPhoneWork;
@property (nonatomic, retain) NSString * dpoaRelationship;
@property (nonatomic, retain) NSNumber * livingWill;
@property (nonatomic, retain) NSNumber * trust;
@property (nonatomic, retain) Patient *patient;

@end
