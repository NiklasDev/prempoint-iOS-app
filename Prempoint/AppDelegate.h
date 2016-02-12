//
//  AppDelegate.h
//  Prempoint
//
//  Created by Niklas Ahola on 10/20/15.
//  Copyright © 2015 Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocation *userLocation;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (AppDelegate*)getDelegate;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

