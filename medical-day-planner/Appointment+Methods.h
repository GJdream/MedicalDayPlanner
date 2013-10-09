//
//  Appointment+Methods.h
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/11/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "Appointment.h"

@interface Appointment (Methods)

+ (Appointment *)createAppointmentWithInfo:(NSDictionary *)appointmentFields
                                          forPatient:(Patient *)aPatient
                              inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Appointment *)modifyAppointment:(Appointment *)appointment
                                    withInfo:(NSDictionary *)appointmentFields
                      inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Appointment *)processAppointment:(Appointment *)appointment withInfo:(NSDictionary *)appointmentFields;

- (NSString *)formattedDateTime;

@end
