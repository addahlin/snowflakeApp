//
//  _Location.h
//  Snowflake
//
//  Created by Andrew Dahlin on 10/10/14.
//  Copyright (c) 2014 Pangomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class _Region, _Report;

@interface _Location : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * raw_region_id;
@property (nonatomic, retain) NSSet *trails;
@property (nonatomic, retain) _Region *region;
@end

@interface _Location (CoreDataGeneratedAccessors)

- (void)addTrailsObject:(_Report *)value;
- (void)removeTrailsObject:(_Report *)value;
- (void)addTrails:(NSSet *)values;
- (void)removeTrails:(NSSet *)values;

@end
