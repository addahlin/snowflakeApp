//
//  Region.h
//  Snowflake
//
//  Created by Andrew Dahlin on 1/15/15.
//  Copyright (c) 2015 Pangomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location, Report;

@interface Region : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * neLatitude;
@property (nonatomic, retain) NSString * neLongitude;
@property (nonatomic, retain) NSString * swLatitude;
@property (nonatomic, retain) NSString * swLongitude;
@property (nonatomic, retain) NSSet *locations;
@property (nonatomic, retain) Report *reports;
@end

@interface Region (CoreDataGeneratedAccessors)

- (void)addLocationsObject:(Location *)value;
- (void)removeLocationsObject:(Location *)value;
- (void)addLocations:(NSSet *)values;
- (void)removeLocations:(NSSet *)values;

@end
