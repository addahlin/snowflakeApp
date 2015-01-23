//
//  PNGSnowflakeSettings.m
//  Snowflake
//
//  Created by Andrew Dahlin on 1/22/15.
//  Copyright (c) 2015 Pangomedia. All rights reserved.
//

#import "PNGSnowflakeSettings.h"

@implementation PNGSnowflakeSettings

@synthesize daysToRetainReports;

#pragma mark Singleton Methods

+ (id)sharedSettings {
    static PNGSnowflakeSettings *sharedPNGSnowflakeSettings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPNGSnowflakeSettings = [[self alloc] init];
    });
    return sharedPNGSnowflakeSettings;
}

- (id)init {
    if (self = [super init]) {
        [self loadSettings];
    }
    return self;
}

//Persist the settings
- (void) saveSettings{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:self.daysToRetainReports forKey:daysToRetainReportsKey];
    
    [defaults synchronize];
}

//Pull out the stored settings from the persistence layer (NSUserDefaults)
-(void) loadSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    if ([defaults objectForKey:daysToRetainReportsKey] != nil){
        daysToRetainReports = [defaults integerForKey:daysToRetainReportsKey];
    } else {
        daysToRetainReports = DEFAULT_DAYS_TO_RETAIN_REPORTS;
    }
    
    
}
@end