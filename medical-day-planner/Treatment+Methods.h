//
//  Treatment+Methods.h
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/12/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "Treatment.h"
#import "Patient.h"

@interface Treatment (Methods)

+ (Treatment *)createTreatmentWithInfo:(NSDictionary *)treatmentFields
                            forPatient:(Patient *)aPatient
                inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Treatment *)modifyTreatment:(Treatment *)treatment
                      withInfo:(NSDictionary *)treatmentFields
        inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Treatment *)processTreatment:(Treatment *)treatment
                       withInfo:(NSDictionary *)treatmentFields
                      inContext:context;

- (NSString *)startDateString;
- (NSString *)endDateString;
- (NSString *)detailText;

@end
