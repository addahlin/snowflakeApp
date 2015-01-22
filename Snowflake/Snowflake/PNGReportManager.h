//
//  PNGReportManager.h
//  Snowflake
//
//  Created by Andrew Dahlin on 10/11/14.
//  Copyright (c) 2014 Pangomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Region+user.h"
#import "Report+user.h"
#import "Activity+user.h"
#import "Location+user.h"

#import "PNGSnowIOCommunicator.h"

@interface PNGReportManager : NSObject

extern NSString * const PNGReportsWillUpdateNotification;
extern NSString * const PNGReportsDidUpdateNotification;    //implemented

extern NSString * const PNGAppDataWillUpdateNotification;
extern NSString * const PNGAppDataDidUpdateNotification;

+ (NSString *) stringByUnescapingCodes: (NSString * ) dataString;

//The following return data immediately (most likely from Core Data)
+(NSArray *) getRegions;

+(NSArray *) getActivites;

+(NSArray *) getLocationsInRegion: (Region *) region;

+(NSArray *) getLocations;

+(NSArray *) getReportsForRegion: (Region *) region;

+(NSArray *) getReportsForLocation:(Location *) location;

+(NSArray *) getAllReports;

// Functions to sync the app with the server. These are run asynchronously.
 
+(void) syncAppData;  //Syncs everything except reports
+(void) syncAppData:(void (^)(NSError* error))completionBlock;

+(void) syncRegions;
+(void) syncRegions:(void (^)(NSError* error))completionBlock;

+(void) syncActivities;
+(void) syncActivities:(void (^)(NSError* error))completionBlock;

+(void) syncLocations;
+(void) syncLocations:(void (^)(NSError* error))completionBlock;

+(void) syncAllReports;
+(void) syncAllReports:(void (^)(NSError* error))completionBlock;

+(void) syncReportsForLocation:(Location *) location;

+(void) syncReportsForRegion: (Region *) region;

+(void) syncReportsSinceDate: (NSDate *) date;

+(void) trimOldReports;

@end
