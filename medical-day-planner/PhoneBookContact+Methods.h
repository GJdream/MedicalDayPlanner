//
//  PhoneBookContact+Methods.h
//  medical-day-planner
//
//  Created by Ronnie Miller on 6/25/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "PhoneBookContact.h"

@interface PhoneBookContact (Methods)

+ (PhoneBookContact *)createPhoneBookContactWithInfo:(NSDictionary *)phoneBookContactFields
                            forPatient:(Patient *)aPatient
                inManagedObjectContext:(NSManagedObjectContext *)context;

+ (PhoneBookContact *)modifyPhoneBookContact:(PhoneBookContact *)phoneBookContact
                      withInfo:(NSDictionary *)phoneBookContactFields
    inManagedObjectContext:(NSManagedObjectContext *)context;

+ (PhoneBookContact *)processPhoneBookContact:(PhoneBookContact *)phoneBookContact withInfo:(NSDictionary *)phoneBookContactFields;

- (NSString *)availablePhone;

@end
