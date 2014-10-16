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

//The following return data immediately (most likely from Core Data)
-(NSArray *) getRegions;

-(NSArray *) getActivites;

-(NSArray *) getLocationsInRegion: (Region *) region;

-(NSArray *) getLocations;

-(NSArray *) getReportsForRegion: (Region *) region;

-(NSArray *) getReportsForLocation:(Location *) location;

-(NSArray *) getAllReports;

// Functions to sync the app with the server. This is done asynchronously.
 
-(void) syncAppData:(void (^)(NSError* error))completionBlock;  //Syncs everything except reports

-(void) syncRegions:(void (^)(NSError* error))completionBlock;

-(void) syncActivities:(void (^)(NSError* error))completionBlock;

-(void) syncLocations:(void (^)(NSError* error))completionBlock;

-(void) syncAllReports:(void (^)(NSError* error))completionBlock;

-(void) syncReportsForLocation:(Location *) location;

-(void) syncReportsForRegion: (Region *) region;

-(void) syncReportsSinceDate: (NSDate *) date;

-(void) trimOldReports;

@end
