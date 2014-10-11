//
//  Region.h
//  Snowflake
//
//  Created by Andrew Dahlin on 10/10/14.
//  Copyright (c) 2014 Pangomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location;

@interface Region : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * neLatitude;
@property (nonatomic, retain) NSString * neLongitude;
@property (nonatomic, retain) NSString * swLatitude;
@property (nonatomic, retain) NSString * swLongitude;
@property (nonatomic, retain) Location *locations;

@end
