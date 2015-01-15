//
//  Location.h
//  Snowflake
//
//  Created by Andrew Dahlin on 1/15/15.
//  Copyright (c) 2015 Pangomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Region, Report;

@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * raw_region_id;
@property (nonatomic, retain) Region *region;
@property (nonatomic, retain) NSSet *trails;
@property (nonatomic, retain) Report *reports;
@end

@interface Location (CoreDataGeneratedAccessors)

- (void)addTrailsObject:(Report *)value;
- (void)removeTrailsObject:(Report *)value;
- (void)addTrails:(NSSet *)values;
- (void)removeTrails:(NSSet *)values;

@end
