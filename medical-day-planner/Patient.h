//
//  Patient.h
//  medical-day-planner
//
//  Created by Ram Krishna on 04/02/13.
//  Copyright (c) 2013 All Things Caregiver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Appointment, Directive, Hospitalization, Medication, PhoneBookContact, Procedure, SimpleContact, Test, Treatment;

@interface Patient : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * bloodType;
@property (nonatomic, retain) NSString * diagnosis;
@property (nonatomic, retain) NSString * dietaryRestrictions;
@property (nonatomic, retain) NSDate * dobDate;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * knownAllergies;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * phoneCell;
@property (nonatomic, retain) NSString * phoneHome;
@property (nonatomic, retain) NSString * phoneWork;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSSet *appointments;
@property (nonatomic, retain) Directive *directive;
@property (nonatomic, retain) NSSet *hospitalizations;
@property (nonatomic, retain) NSSet *medications;
@property (nonatomic, retain) NSSet *phonebookContacts;
@property (nonatomic, retain) NSSet *procedures;
@property (nonatomic, retain) NSSet *simpleContacts;
@property (nonatomic, retain) NSSet *tests;
@property (nonatomic, retain) NSSet *treatments;
@end

@interface Patient (CoreDataGeneratedAccessors)

- (void)addAppointmentsObject:(Appointment *)value;
- (void)removeAppointmentsObject:(Appointment *)value;
- (void)addAppointments:(NSSet *)values;
- (void)removeAppointments:(NSSet *)values;

- (void)addHospitalizationsObject:(Hospitalization *)value;
- (void)removeHospitalizationsObject:(Hospitalization *)value;
- (void)addHospitalizations:(NSSet *)values;
- (void)removeHospitalizations:(NSSet *)values;

- (void)addMedicationsObject:(Medication *)value;
- (void)removeMedicationsObject:(Medication *)value;
- (void)addMedications:(NSSet *)values;
- (void)removeMedications:(NSSet *)values;

- (void)addPhonebookContactsObject:(PhoneBookContact *)value;
- (void)removePhonebookContactsObject:(PhoneBookContact *)value;
- (void)addPhonebookContacts:(NSSet *)values;
- (void)removePhonebookContacts:(NSSet *)values;

- (void)addProceduresObject:(Procedure *)value;
- (void)removeProceduresObject:(Procedure *)value;
- (void)addProcedures:(NSSet *)values;
- (void)removeProcedures:(NSSet *)values;

- (void)addSimpleContactsObject:(SimpleContact *)value;
- (void)removeSimpleContactsObject:(SimpleContact *)value;
- (void)addSimpleContacts:(NSSet *)values;
- (void)removeSimpleContacts:(NSSet *)values;

- (void)addTestsObject:(Test *)value;
- (void)removeTestsObject:(Test *)value;
- (void)addTests:(NSSet *)values;
- (void)removeTests:(NSSet *)values;

- (void)addTreatmentsObject:(Treatment *)value;
- (void)removeTreatmentsObject:(Treatment *)value;
- (void)addTreatments:(NSSet *)values;
- (void)removeTreatments:(NSSet *)values;

@end
