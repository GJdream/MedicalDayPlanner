//
//  Procedure+Methods.h
//  medical-day-planner
//
//  Created by Ronnie Miller on 7/12/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import "Procedure.h"
#import "Patient.h"

@interface Procedure (Methods)

+ (Procedure *)createProcedureWithInfo:(NSDictionary *)procedureFields
                            forPatient:(Patient *)aPatient
                inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Procedure *)modifyProcedure:(Procedure *)procedure
                      withInfo:(NSDictionary *)procedureFields
        inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Procedure *)processProcedure:(Procedure *)procedure
                       withInfo:(NSDictionary *)procedureFields
                      inContext:context;

- (NSString *)dateString;
- (NSString *)detailText;

@end
