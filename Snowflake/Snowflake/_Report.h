//
//  _Report.h
//  Snowflake
//
//  Created by Andrew Dahlin on 10/10/14.
//  Copyright (c) 2014 Pangomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class _Location;

@interface _Report : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * raw_trail_id;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * posted_date;
@property (nonatomic, retain) NSString * poster_name;
@property (nonatomic, retain) NSString * raw_region_id;
@property (nonatomic, retain) UNKNOWN_TYPE raw_trail_name;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) _Location *trail;

@end
