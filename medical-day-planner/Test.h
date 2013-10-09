//
//  Test.h
//  medical-day-planner
//
//  Created by Ram Krishna on 04/02/13.
//  Copyright (c) 2013 All Things Caregiver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Patient, TestPhoto;

@interface Test : NSManagedObject

@property (nonatomic, retain) NSString * bodyRegion;
@property (nonatomic, retain) NSString * facility;
@property (nonatomic, retain) NSDate * performedDate;
@property (nonatomic, retain) NSString * physician;
@property (nonatomic, retain) NSString * results;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Patient *patient;
@property (nonatomic, retain) NSSet *photos;
@end

@interface Test (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(TestPhoto *)value;
- (void)removePhotosObject:(TestPhoto *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
