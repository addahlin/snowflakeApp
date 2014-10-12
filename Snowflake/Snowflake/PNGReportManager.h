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

@interface PNGReportManager : NSObject

//The following return data immediately (most likely from Core Data)
-(NSArray *) getRegions;

-(NSArray *) getActivites;

-(NSArray *) getLocationsInRegion: (Region *) region;

-(NSArray *) getReportsForRegion: (Region *) region;

-(NSArray *) getReportsForLocation:(Location *) location;

-(NSArray *) getAllReports;

// Functions to sync the app with the server. This is done asynchronously.
// Rather than provide callbacks, these will trigger NSNotification events interested parties can listen to
-(void) syncAll;

-(void) syncRegions;

-(void) syncActivities;

-(void) syncLocations;

-(void) syncAllReports;

-(void) syncReportsForLocation:(Location *) location;

-(void) syncReportsForRegion: (Region *) region;

-(void) syncReportsSinceDate: (NSDate *) date;

-(void) trimOldReports;

@end
