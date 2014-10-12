//
//  PNGSettings.m
//  Snowflake
//
//  Created by Andrew Dahlin on 10/11/14.
//  Copyright (c) 2014 Pangomedia. All rights reserved.
//

#import "PNGSettings.h"

@implementation PNGSettings

//Thread-safe singlton pattern
+ (PNGSettings*)sharedInstance
{
    static PNGSettings *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[PNGSettings alloc] init];
    });
    return _sharedInstance;
}

//There are probably much better ways to do this, but it gets this up and running

- (NSString *)getServerBaseURL {
    
    return @"http://dev.snowio.com/api/";
}

//How long should we wait before server requests timeout
- (int) getDefaultServerTimeout {
    return 30; //seconds
}

//By default, the server communicator will fetch this many reports
- (NSNumber *) getDefaultNumberOfReportsToFetchFromServer {
    return @20;
}

@end
