//
//  Procedure.h
//  medical-day-planner
//
//  Created by Ram Krishna on 04/02/13.
//  Copyright (c) 2013 All Things Caregiver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Patient;

@interface Procedure : NSManagedObject

@property (nonatomic, retain) NSString * complications;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * facility;
@property (nonatomic, retain) NSString * physician;
@property (nonatomic, retain) NSString * procedureText;
@property (nonatomic, retain) NSString * results;
@property (nonatomic, retain) NSString * suggestions;
@property (nonatomic, retain) Patient *patient;

@end
