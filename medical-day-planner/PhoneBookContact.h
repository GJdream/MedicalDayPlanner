//
//  PhoneBookContact.h
//  medical-day-planner
//
//  Created by Ram Krishna on 04/02/13.
//  Copyright (c) 2013 All Things Caregiver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Patient;

@interface PhoneBookContact : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * contactName;
@property (nonatomic, retain) NSString * contactPhone;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * fax;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSNumber * quickContact;
@property (nonatomic, retain) NSString * specialty;
@property (nonatomic, retain) Patient *patient;

@end
