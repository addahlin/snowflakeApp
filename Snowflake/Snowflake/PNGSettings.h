//
//  PNGSettings.h
//  Snowflake
//
//  Created by Andrew Dahlin on 10/11/14.
//  Copyright (c) 2014 Pangomedia. All rights reserved.
//

#import <Foundation/Foundation.h>

//This class holds all the settings in the application. This implement the singleton pattern
// to avoid having to access global variables

@interface PNGSettings : NSObject

+ (PNGSettings*)sharedInstance;

- (NSString *)getServerBaseURL;
- (int) getDefaultServerTimeout;
- (NSNumber *) getDefaultNumberOfReportsToFetchFromServer;

@end
