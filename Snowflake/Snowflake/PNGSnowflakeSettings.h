//
//  PNGSnowflakeSettings.h
//  Snowflake
//
//  Created by Andrew Dahlin on 1/22/15.
//  Copyright (c) 2015 Pangomedia. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 This is a singleton class to store and retrieve the application wide settings for snowflake.
 This would ideally passed to classes via DI, but this gets it up and running (and really, is probably just fine)
*/

//This should be defined in a non-global manner...
#define DEFAULT_DAYS_TO_RETAIN_REPORTS 30

static NSString *daysToRetainReportsKey = @"PNGdayToRetainReportsKey";

@interface PNGSnowflakeSettings : NSObject {
    int daysToRetainReports;
    
}

@property (nonatomic) int daysToRetainReports;

+ (id)sharedSettings;

- (void) saveSettings;

@end