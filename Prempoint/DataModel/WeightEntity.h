//
//  WeightEntity.h
//  Prempoint
//
//  Created by Niklas Ahola on 10/20/15.
//  Copyright © 2015 Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeightEntity : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+ (WeightEntity*)createWeightEntityObject;

+ (NSArray*)loadWeightObjects:(NSDate*)dateFrom to:(NSDate*)dateTo;

- (void)saveObject;

- (void)deleteObject;

@end

NS_ASSUME_NONNULL_END

#import "WeightEntity+CoreDataProperties.h"
