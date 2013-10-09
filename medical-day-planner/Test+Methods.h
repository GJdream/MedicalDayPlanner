//
//  Test+Methods.h
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/12/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "Test.h"

@interface Test (Methods)

+ (Test *)createTestWithInfo:(NSDictionary *)testFields
                  forPatient:(Patient *)aPatient
      inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Test *)modifyTest:(Test *)test
            withInfo:(NSDictionary *)testFields
inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Test *)processTest:(Test *)test
             withInfo:(NSDictionary *)testFields
            inContext:context;

- (NSString *)performedDateString;
- (NSString *)detailText;

- (NSArray *)photoFilenames;
- (void)deletePhotoFiles;

@end
