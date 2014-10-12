//
//  PNGReportManager.m
//  Snowflake
//
//  Created by Andrew Dahlin on 10/11/14.
//  Copyright (c) 2014 Pangomedia. All rights reserved.
//

#import "PNGReportManager.h"

@implementation PNGReportManager

//The following return data immediately (most likely from Core Data)
-(NSArray *) getRegions{
    //return [Region MR_];
    return nil;
}

-(NSArray *) getActivites{
    return nil;
}

-(NSArray *) getLocationsInRegion: (Region *) region{
    return nil;
}

-(NSArray *) getReportsForRegion: (Region *) region{
    return nil;
}

-(NSArray *) getReportsForLocation:(Location *) location{
    return nil;
}

-(NSArray *) getAllReports{
    return nil;
}

// Functions to sync the app with the server. This is done asynchronously.
// Rather than provide callbacks, these will trigger NSNotification events interested parties can listen to
-(void) syncAll{
    
}

-(void) syncRegions{
    
}

-(void) syncActivities{
    
}

-(void) syncLocations{
    
}

-(void) syncAllReports{
    
}

-(void) syncReportsForLocation:(Location *) location{
    
}

-(void) syncReportsForRegion: (Region *) region{
    
}

-(void) syncReportsSinceDate: (NSDate *) date{
    
}

-(void) trimOldReports{
    
}


@end
