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
    
    NSString *reportBase = [NSString stringWithFormat:@"%@reports", [[PNGSettings sharedInstance] getServerBaseURL]];
    
    if (options == nil || [options count] == 0){
        return reportBase;
    }
    
    //Build up the get parameters
    NSMutableArray *getComps = [[NSMutableArray alloc] init];
    for (NSString* option in [options keyEnumerator]){
        [getComps addObject:[NSString stringWithFormat:@"%@=%@", option, (NSString *)[options objectForKey:option]]];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@?%@", reportBase, [getComps componentsJoinedByString:@"&"]];
    
    return urlString;
}

-(NSString *)getActivitiesURL{
    NSString *activitiesURL = [NSString stringWithFormat:@"%@activities", [[PNGSettings sharedInstance] getServerBaseURL]];
    
    return activitiesURL;
}

-(NSString *)getRegionsURL{
    NSString *url = [NSString stringWithFormat:@"%@regions", [[PNGSettings sharedInstance] getServerBaseURL]];
    
    return url;
}

-(NSString *)getLocationsURL{
    NSString *url = [NSString stringWithFormat:@"%@locations", [[PNGSettings sharedInstance] getServerBaseURL]];
    
    return url;
}

-(void) getActivitiesJSONwithCompletionBlock:(void (^)(NSData* data, NSHTTPURLResponse *response, NSError* error))completionBlock{
    NSString *activitiesURL = [self getActivitiesURL];
    
    //Just forward the completion block to the URL helper
    [PNGGetDataFromURLHelper getDataFromURLAsync:activitiesURL withCompletion:completionBlock];
}

-(void) getRegionsJSONwithCompletionBlock:(void (^)(NSData* data, NSHTTPURLResponse *response, NSError* error))completionBlock{
    NSString *regionsURL = [self getRegionsURL];
    
    //Just forward the completion block to the URL helper
    [PNGGetDataFromURLHelper getDataFromURLAsync:regionsURL withCompletion:completionBlock];
    
};

-(void) getLocationsJSONwithCompletionBlock:(void (^)(NSData* data, NSHTTPURLResponse *response, NSError* error))completionBlock {
    NSString *locationsURL = [self getLocationsURL];
    
    //Just forward the completion block to the URL helper
    [PNGGetDataFromURLHelper getDataFromURLAsync:locationsURL withCompletion:completionBlock];
}

-(void) getMostRecentReportsWithCompletionBlock:(void (^)(NSData* data, NSHTTPURLResponse *response, NSError* error))completionBlock {
    
    //Let the server decide how many to send back
    NSString *mostRecentURL = [self getReportURLWithOptions:nil];
    
    //Just forward the completion block to the URL helper
    [PNGGetDataFromURLHelper getDataFromURLAsync:mostRecentURL withCompletion:completionBlock];
}

-(void) getMostRecentReportsWithOptions:(NSDictionary *) options
                               completionBlock:(void (^)(NSData* data, NSHTTPURLResponse *response, NSError* error)) completionBlock{
    
    NSString *mostRecentURL = [self getReportURLWithOptions:options];
 
    //Just forward the completion block to the URL helper
    [PNGGetDataFromURLHelper getDataFromURLAsync:mostRecentURL withCompletion:completionBlock];
    
}

-(void) getMostRececentReportsForLocation: (NSString *)locationID options:(NSDictionary *) options completionBlock:(void (^)(NSData* data, NSHTTPURLResponse *response, NSError* error)) completionBlock{
    
    //Just add in the trail to the options
    
    NSMutableDictionary *dict;
    if (options == nil){
        dict = [[NSMutableDictionary alloc] init];
    } else {
        dict = [options mutableCopy];
    }
    
    dict[@"trail"] = locationID;
    
    [self getMostRecentReportsWithOptions:options completionBlock:completionBlock];
}


@end
