//
//  Medication+Methods.h
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/1/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "Medication.h"

@interface Medication (Methods)

+ (Medication *)createMedicationWithInfo:(NSDictionary *)medicationFields
                                          forPatient:(Patient *)aPatient
                              inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Medication *)modifyMedication:(Medication *)medication
                                    withInfo:(NSDictionary *)medicationFields
                      inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Medication *)processMedication:(Medication *)medication
                         withInfo:(NSDictionary *)medicationFields
                        inContext:context;

- (NSString *)startDateString;
- (NSString *)endDateString;
- (NSString *)detailText;
- (NSString *)alarmTimeString;
- (NSArray *)photoFilenames;
- (void)deletePhotoFiles;

@end
