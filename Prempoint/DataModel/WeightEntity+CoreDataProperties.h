//
//  WeightEntity+CoreDataProperties.h
//  Prempoint
//
//  Created by Niklas Ahola on 10/20/15.
//  Copyright © 2015 Yang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "WeightEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeightEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *desc;
@property (nullable, nonatomic, retain) NSNumber *temp;
@property (nullable, nonatomic, retain) NSNumber *weight;

@end

NS_ASSUME_NONNULL_END
