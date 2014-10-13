//
//  PNGReportManager.m
//  Snowflake
//
//  Created by Andrew Dahlin on 10/11/14.
//  Copyright (c) 2014 Pangomedia. All rights reserved.
//

#import "PNGReportManager.h"

@implementation PNGReportManager

-(void) saveContext{
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        
        //Check to see if there was an error. Success is coming back as "NO" even thought it appears to have persisted/saved without
        // any problems.
        if (!error){
            NSLog(@"Successfully saved contex");
        } else{
            NSLog(@"Problem saving context: %@", error.localizedDescription);
        }
    }];
}

//The following return data immediately (most likely from Core Data)
-(NSArray *) getRegions{
    return [Region MR_findAll];
}

-(NSArray *) getActivites{
    return [Activity MR_findAll];
}

-(NSArray *) getLocationsInRegion: (Region *) region{
    return [Location MR_findByAttribute:@"region" withValue:region.id];
}

-(NSArray *) getLocations {
    return [Location MR_findAll];
}

-(NSArray *) getReportsForRegion: (Region *) region{
    return nil;
}

-(NSArray *) getReportsForLocation:(Location *) location{
    return nil;
}

-(NSArray *) getAllReports{
    return [Report MR_findAll];
}

// Functions to sync the app with the server. This is done asynchronously.
// Rather than provide callbacks, these will trigger NSNotification events interested parties can listen to
-(void) syncAll{
    
}

-(void) syncAppData:(void (^)(NSError* error))completionBlock{
    
    [self syncRegions:^(NSError *error) {
        if(!error){
            [self syncLocations:^(NSError *error) {
                if(!error){
                    [self syncActivities:^(NSError *error) {
                        completionBlock(error);
                    }];
                } else {
                    NSLog(@"Error syncing Locations");
                    completionBlock(error);
                }
            }];
            
        } else {
            NSLog(@"Error syncing Regions");
            completionBlock(error);
        }
    }];
    
}


//TODO: put somewhere more appropriate
-(void) buildRegionsFromJSON:(NSData *) json{
    NSError *error;
    
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:json options:0 error:&error];
    //NSLog(@"JSON data: %@", parsedObject);
    
    for (NSString *regionId in [parsedObject keyEnumerator]){
        NSLog(@"processing trail: %@", regionId);
        
        //Get the region if it already exists, otherwise, create one.
        Region *region = [Region MR_findFirstOrCreateByAttribute:@"id" withValue:regionId];
        
        NSDictionary *data = (NSDictionary *)[parsedObject objectForKey:regionId];
        
        region.id = regionId;
        region.name = [data objectForKey:@"name"];
        region.neLatitude = [data objectForKey:@"neLat"];
        region.neLongitude = [data objectForKey:@"neLng"];
        region.swLatitude = [data objectForKey:@"swLat"];
        region.swLongitude = [data objectForKey:@"swLng"];
    }
    
    [self saveContext];
    
}
-(void) syncRegions:(void (^)(NSError* error))completionBlock{
    //TODO: I really need to turn this into a class member or singleton.
    PNGSnowIOCommunicator *comm = [[PNGSnowIOCommunicator alloc] init];
    [comm getRegionsJSONwithCompletionBlock:^(NSData *data, NSHTTPURLResponse *response, NSError *error) {
        if (!error){
            NSLog(@"Retrieved JSON for regions");
            [self buildRegionsFromJSON:data];
        } else {
            NSLog(@"Error retrieving Regions from server");
        }
        completionBlock(error);
        
    }];
}


//TODO: put somewhere more appropriate
-(void) buildActivitiesFromJSON:(NSData *) json{
    NSError *error;
    
    NSArray *parsedObject = [NSJSONSerialization JSONObjectWithData:json options:0 error:&error];
    //NSLog(@"JSON data: %@", parsedObject);
    
    for (NSDictionary *actDict in parsedObject) {
        NSString *actId = [actDict objectForKey:@"activity_id"];
        Activity *activity = [Activity MR_findFirstOrCreateByAttribute:@"id" withValue:actId];
        
        activity.name = [actDict objectForKey:@"activity_name"];
        activity.iconOffURL = [actDict objectForKey:@"iconOn"];
        activity.iconOnURL = [actDict objectForKey:@"iconOff"];
        
    }
    
    [self saveContext];
    
    
}
-(void) syncActivities:(void (^)(NSError* error))completionBlock{
    
    //Get the Activities JSON from the server (async)
    //TODO: I really need to turn this into a class member or singleton.
    PNGSnowIOCommunicator *comm = [[PNGSnowIOCommunicator alloc] init];
    [comm getActivitiesJSONwithCompletionBlock:^(NSData *data, NSHTTPURLResponse *response, NSError *error) {
        if (!error){
            NSLog(@"Retrieved JSON for activities");
            [self buildActivitiesFromJSON:data];
        } else {
            NSLog(@"Error retrieving Activities from server");
        }
        completionBlock(error);
    }];
}

//TODO: put somewhere more appropriate
-(void) buildLocationsFromJSON:(NSData *) json{
    NSError *error;
    
    NSArray *parsedObject = [NSJSONSerialization JSONObjectWithData:json options:0 error:&error];
    NSLog(@"JSON data: %@", parsedObject);
    
    for (NSDictionary *locDict in parsedObject) {
        NSString *locId = [locDict objectForKey:@"location_id"];
        NSLog(@"Processing for trail id: %@", locId);
        Location *location = [Location MR_findFirstOrCreateByAttribute:@"id" withValue:locId];
        
        location.name = [locDict objectForKey:@"location_name"];
        location.raw_region_id = [locDict objectForKey:@"region"];
        
        location.latitude = [locDict objectForKey:@"lat"];
        
        location.longitude = [locDict objectForKey:@"lng"];
        
    }
    
    [self saveContext];
    
}

-(void) syncLocations:(void (^)(NSError* error))completionBlock{
    //TODO: I really need to turn this into a class member or singleton.
    PNGSnowIOCommunicator *comm = [[PNGSnowIOCommunicator alloc] init];
    [comm getLocationsJSONwithCompletionBlock:^(NSData *data, NSHTTPURLResponse *response, NSError *error) {
        if (!error){
            NSLog(@"Retrieved JSON for Locations");
            [self buildLocationsFromJSON:data];
        } else {
            NSLog(@"Error retrieving Locations from server");
        }
        completionBlock(error);
    }];
}


//TODO: put somewhere more appropriate
-(void) buildReportsFromJSON:(NSData *) json{
    NSError *error;
    
    NSArray *parsedObject = [NSJSONSerialization JSONObjectWithData:json options:0 error:&error];
    NSLog(@"JSON data: %@", parsedObject);
    
    for (NSDictionary *reportDict in parsedObject) {
        NSString *reportId = [reportDict objectForKey:@"report_id"];
        Report *report = [Report MR_findFirstOrCreateByAttribute:@"id" withValue:reportId];
        
        report.raw_trail_id = [reportDict objectForKey:@"trail_id"];
        report.text = [reportDict objectForKey:@"report"];  //TODO: clean up this text
        report.raw_region_id = [reportDict objectForKey:@"region"];
        report.raw_trail_name = [reportDict objectForKey:@"trail_name"];
        report.poster_name = [reportDict objectForKey:@"name"];
        //report.posted_date = [reportDict objectForKey:@"posted]; //TODO: format
        report.latitude = [reportDict objectForKey:@"lat"];
        report.latitude = [reportDict objectForKey:@"lng"];
        //todo: activities?
        //todo: add report_time
    }
    
    [self saveContext];
}

-(void) syncAllReports:(void (^)(NSError* error))completionBlock{
    //TODO: I really need to turn this into a class member or singleton.
    PNGSnowIOCommunicator *comm = [[PNGSnowIOCommunicator alloc] init];
    [comm getMostRecentReportsWithOptions:nil completionBlock:^(NSData *data, NSHTTPURLResponse *response, NSError *error) {
        if (!error){
            NSLog(@"Retrieved JSON for Reports");
            [self buildLocationsFromJSON:data];
        } else {
            NSLog(@"Error retrieving Reports from server");
        }
        completionBlock(error);
    }];
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
