//
//  PNGSnowIOCommunicator.m
//  Snowflake
//
//  Created by Andrew Dahlin on 10/11/14.
//  Copyright (c) 2014 Pangomedia. All rights reserved.
//

#import "PNGSnowIOCommunicator.h"
#import "PNGSettings.h"

//This class is responsible for communicating with the snowIO server

@interface PNGSnowIOCommunicator (PNGSnowIOCommunicator)

@property (nonatomic, strong) PNGSettings *settings;


@end

@implementation PNGSnowIOCommunicator

-(instancetype)init{
    self = [super init];
    
    if (self){
        //self._settings = [PNGSettings sharedInstance];
    }
    
    return self;
}

// Returns the URL to get report with the given options.
// options is just a dictionary with GET parameters
- (NSString *)getReportURLWithOptions:(NSDictionary *)options{
    
    NSString *reportBase = [NSString stringWithFormat:@"%@reports/", [[PNGSettings sharedInstance] getServerBaseURL]];
    
    if (options == nil || [options count] == 0){
        return reportBase;
    }
    
    //Build up the get parameters
    NSMutableArray *getComps = [[NSMutableArray alloc] init];
    for (NSString* option in [options keyEnumerator]){
        [getComps addObject:[NSString stringWithFormat:@"%@=%@", option, (NSString *)[options objectForKey:option]]];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@&%@", reportBase, [getComps componentsJoinedByString:@"="]];
    
    return urlString;
}

-(NSString *)getActivitiesURL{
    NSString *activitiesURL = [NSString stringWithFormat:@"%@activities/", [[PNGSettings sharedInstance] getServerBaseURL]];
    
    return activitiesURL;
}

-(NSString *)getRegionsURL{
    NSString *url = [NSString stringWithFormat:@"%@regions/", [[PNGSettings sharedInstance] getServerBaseURL]];
    
    return url;
}

-(NSString *)getLocationsURL{
    NSString *url = [NSString stringWithFormat:@"%@locations/", [[PNGSettings sharedInstance] getServerBaseURL]];
    
    return url;
}

-(void) getActivitiesJSONwithCompletionBlock:(void (^)(NSData* data, NSHTTPURLResponse *response, NSError* error))completionBlock{
    NSString *activitiesURL = [self getActivitiesURL];
    
    //Run it on a background thread...
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        NSError *error;
        NSHTTPURLResponse  *response;
        
        NSData *data = [PNGGetDataFromURLHelper getDataFromURLSync:activitiesURL response:&response error:&error];
        
        //Call the completionBlock on the main thread
        dispatch_sync(dispatch_get_main_queue(), ^{
            completionBlock(data, response, error);
        });

    });

}


@end
