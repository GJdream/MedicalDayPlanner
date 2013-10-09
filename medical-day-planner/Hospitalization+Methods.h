//
//  Hospitalization+Methods.h
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/12/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "Hospitalization.h"
#import "Patient.h"

@interface Hospitalization (Methods)

+ (Hospitalization *)createHospitalizationWithInfo:(NSDictionary *)hospitalizationFields
                                        forPatient:(Patient *)aPatient
                            inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Hospitalization *)modifyHospitalization:(Hospitalization *)hospitalization
                                  withInfo:(NSDictionary *)hospitalizationFields
                    inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Hospitalization *)processHospitalization:(Hospitalization *)hospitalization
                                   withInfo:(NSDictionary *)hospitalizationFields
                                  inContext:context;

- (NSString *)admitDateString;
- (NSString *)dischargeDateString;
- (NSString *)detailText;

@end
