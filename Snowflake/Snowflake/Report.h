//
//  Report.h
//  Snowflake
//
//  Created by Andrew Dahlin on 1/15/15.
//  Copyright (c) 2015 Pangomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location, Region;

@interface Report : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSDate * posted_date;
@property (nonatomic, retain) NSString * poster_name;
@property (nonatomic, retain) NSString * raw_region_id;
@property (nonatomic, retain) NSString * raw_trail_id;
@property (nonatomic, retain) NSString * raw_trail_name;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * report_id;
@property (nonatomic, retain) NSString * raw_report_time;
@property (nonatomic, retain) NSString * raw_posted_timestamp;
@property (nonatomic, retain) NSDate * report_date;
@property (nonatomic, retain) Location *trail;
@property (nonatomic, retain) Region *region;
@property (nonatomic, retain) Location *location;

@end
