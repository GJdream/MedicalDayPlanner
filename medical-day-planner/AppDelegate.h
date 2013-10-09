//
//  AppDelegate.h
//  medical-day-planner
//
//  Created by Ronnie Miller on 6/19/12.
//  Copyright (c) 2012 All Things Caregiver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedicationFormViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) MedicationFormViewController *medicationFormView;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
