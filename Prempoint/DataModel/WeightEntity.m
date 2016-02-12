//
//  WeightEntity.m
//  Prempoint
//
//  Created by Niklas Ahola on 10/20/15.
//  Copyright © 2015 Yang. All rights reserved.
//

#import "WeightEntity.h"
#import "AppDelegate.h"

#define EntityName @"WeightEntity"

@implementation WeightEntity

// Insert code here to add functionality to your managed object subclass
+ (WeightEntity*)createWeightEntityObject {
    AppDelegate *appDelegate = [AppDelegate getDelegate];
    NSEntityDescription *entity = [NSEntityDescription entityForName:EntityName inManagedObjectContext:appDelegate.managedObjectContext];
    WeightEntity *object = [[WeightEntity alloc] initWithEntity:entity insertIntoManagedObjectContext:appDelegate.managedObjectContext];
    object.date = [NSDate date];
    return object;
}

+ (NSArray*)loadWeightObjects:(NSDate*)dateFrom to:(NSDate*)dateTo {
    
    AppDelegate *appDelegate = [AppDelegate getDelegate];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:EntityName inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    if (dateFrom && dateTo) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date > %@) AND (date <= %@)", dateFrom, dateTo];
        [fetchRequest setPredicate:predicate];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *fetchedObjects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return fetchedObjects;
}

- (void)saveObject {
    NSError *error;
    [self.managedObjectContext save:&error];
    if (error)  {
        NSLog(@"%@", [error localizedDescription]);
    }
}

- (void)deleteObject {
    AppDelegate *appDelegate = [AppDelegate getDelegate];
    [appDelegate.managedObjectContext deleteObject:self];
    [appDelegate.managedObjectContext save:nil];
}

@end
