//
//  Patient+Methods.h
//  The Medical Day Planner
//
//  Created by Ronnie Miller on 6/8/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "Patient.h"

@interface Patient (Methods)

#pragma mark - 
#pragma mark - CRUD operations

+ (Patient *)createPatientWithInfo:(NSDictionary *)patientFields
            inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Patient *)modifyPatient:(Patient *)patient
                  withInfo:(NSDictionary *)patientFields
    inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Patient *)processPatient:(Patient *)patient withInfo:(NSDictionary *)patientFields;

- (NSString *)availablePhone;
- (UIImage *)parsedPhoto;
- (NSInteger)age;

@end
