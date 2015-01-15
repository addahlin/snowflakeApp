//
//  PNGReportManager.m
//  Snowflake
//
//  Created by Andrew Dahlin on 10/11/14.
//  Copyright (c) 2014 Pangomedia. All rights reserved.
//

#import "PNGReportManager.h"
#import "PNGReportDetailViewController.h"

@implementation PNGReportManager


// Used to fix up the incoming report text. Should put this somewhere more appropriate.
- (NSString *) stringByUnescapingCodes: (NSString * ) dataString
{
    
    NSUInteger myLength = [dataString length];
    NSUInteger ampIndex = [dataString rangeOfString:@"&" options:NSLiteralSearch].location;
    
    // Short-circuit if there are no ampersands.
    if (ampIndex == NSNotFound) {
        return dataString;
    }
    // Make result string with some extra capacity.
    NSMutableString *result = [NSMutableString stringWithCapacity:(myLength * 1.25)];
    
    // First iteration doesn't need to scan to & since we did that already, but for code simplicity's sake we'll do it again with the scanner.
    NSScanner *scanner = [NSScanner scannerWithString:dataString];
    do {
        // Scan up to the next entity or the end of the string.
        NSString *nonEntityString;
        if ([scanner scanUpToString:@"&" intoString:&nonEntityString]) {
            [result appendString:nonEntityString];
        }
        if ([scanner isAtEnd]) {
            goto finish;
        }
        // Scan either a HTML or numeric character entity reference.
        if ([scanner scanString:@"&amp;" intoString:NULL])
            [result appendString:@"&"];
        else if ([scanner scanString:@"&apos;" intoString:NULL])
            [result appendString:@"'"];
        else if ([scanner scanString:@"&quot;" intoString:NULL])
            [result appendString:@"\""];
        else if ([scanner scanString:@"&lt;" intoString:NULL])
            [result appendString:@"<"];
        else if ([scanner scanString:@"&gt;" intoString:NULL])
            [result appendString:@">"];
        else if ([scanner scanString:@"&#" intoString:NULL]) {
            BOOL gotNumber;
            unsigned charCode;
            NSString *xForHex = @"";
            
            // Is it hex or decimal?
            if ([scanner scanString:@"x" intoString:&xForHex]) {
                gotNumber = [scanner scanHexInt:&charCode];
            }
            else {
                gotNumber = [scanner scanInt:(int*)&charCode];
            }
            if (gotNumber) {
                [result appendFormat:@"%C", charCode];
            }
            else {
                NSString *unknownEntity = @"";
                [scanner scanUpToString:@";" intoString:&unknownEntity];
                [result appendFormat:@"&#%@%@;", xForHex, unknownEntity];
                NSLog(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);
            }
            [scanner scanString:@";" intoString:NULL];
        }
        else {
            NSString *unknownEntity = @"";
            [scanner scanUpToString:@";" intoString:&unknownEntity];
            NSString *semicolon = @"";
            [scanner scanString:@";" intoString:&semicolon];
            [result appendFormat:@"%@%@", unknownEntity, semicolon];
            NSLog(@"Unsupported XML character entity %@%@", unknownEntity, semicolon);
        }
    } while (![scanner isAtEnd]);
    
finish:
    return result;
}


-(void) saveContext{
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        
        //Check to see if there was an error. Success is coming back as "NO" even thought it appears to have persisted/saved without
        // any problemls.
        if (!error){
            NSLog(@"Successfully saved contex");
        } else{
            NSLog(@"Problem saving context: %@", error.localizedDescription);
        }
    }];
}

//The following return data immediately (most likely from Core Data)

+(NSArray *) getRegions{
    return [Region MR_findAllSortedBy:@"name" ascending:YES ];
}

+(NSArray *) getActivites{
    return [Activity MR_findAll];
}

+(NSArray *) getLocationsInRegion: (Region *) region{
    //Sort the locations by name
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    return [[region.locations allObjects] sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    //return [Location MR_findByAttribute:@"region" withValue:region.id];
}

+(NSArray *) getLocations {
    return [Location MR_findAll];
}

+(NSArray *) getReportsForRegion: (Region *) region{
    return nil;
    
}

+(NSArray *) getReportsForLocation:(Location *) location{
    return nil;
}

+(NSArray *) getAllReports{
    return [Report MR_findAllSortedBy:@"report_date" ascending:NO];
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
        //NSLog(@"processing trail: %@", regionId);
        
        //Get the region if it already exists, otherwise, create one.
        Region *region = [Region MR_findFirstOrCreateByAttribute:@"id" withValue:regionId];
        
        NSDictionary *data = (NSDictionary *)[parsedObject objectForKey:regionId];
        
        region.id = regionId;
        region.name = [self stringByUnescapingCodes:[data objectForKey:@"name"]];
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
        if (completionBlock) {
            completionBlock(error);
        }
        
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
        if (completionBlock){
            completionBlock(error);
        }
    }];
}

//TODO: put somewhere more appropriate
-(void) buildLocationsFromJSON:(NSData *) json{
    NSError *error;
    
    NSArray *parsedObject = [NSJSONSerialization JSONObjectWithData:json options:0 error:&error];
    //NSLog(@"JSON data: %@", parsedObject);
    
    for (NSDictionary *locDict in parsedObject) {
        NSString *locId = [locDict objectForKey:@"location_id"];
        //NSLog(@"Processing for trail id: %@", locId);
        Location *location = [Location MR_findFirstOrCreateByAttribute:@"id" withValue:locId];
        
        location.name = [self stringByUnescapingCodes:[locDict objectForKey:@"location_name"]];
        location.raw_region_id = [locDict objectForKey:@"region"];
        
        //Map the location to it's region
        Region *region = [Region MR_findFirstByAttribute:@"id" withValue:location.raw_region_id];
        if (region){
            location.region = region;
        } else {
            NSLog(@"Could not bind region id %@ for location %@", location.raw_region_id, location.name);
        }
        
        //Make sure the lattitude isn't null. If it isn't, assign it.
        NSString *lat = [locDict objectForKey:@"lat"];
        if (lat != (id)[NSNull null]){
            location.latitude = lat;
        }
        
        NSString *lng = [locDict objectForKey:@"lng"];
        if (lng != (id)[NSNull null]){
            location.longitude = lng;
        }
        
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
        
        if (completionBlock){
            completionBlock(error);
        }
    }];
}


//TODO: put somewhere more appropriate
-(void) buildReportsFromJSON:(NSData *) json{
    NSError *error;
    
    NSArray *parsedObject = [NSJSONSerialization JSONObjectWithData:json options:0 error:&error];
    //NSLog(@"JSON data: %@", parsedObject);
    
    for (NSDictionary *reportDict in parsedObject) {
        NSString *reportId = [reportDict objectForKey:@"report_id"];
        Report *report = [Report MR_findFirstOrCreateByAttribute:@"id" withValue:reportId];
        
        report.report_id = reportId;
        
        report.raw_trail_id = [reportDict objectForKey:@"trail_id"];
        report.text = [self stringByUnescapingCodes:[reportDict objectForKey:@"report"]];  //TODO: clean up this text
        report.raw_region_id = [reportDict objectForKey:@"region"];
        report.raw_trail_name = [self stringByUnescapingCodes:[reportDict objectForKey:@"trail_name"]];
        report.poster_name = [self stringByUnescapingCodes:[reportDict objectForKey:@"name"]];
        //report.posted_date = [reportDict objectForKey:@"posted]; //TODO: format
        
        //Make sure the lattitude isn't null. If it isn't, assign it.
        NSString *lat = [reportDict objectForKey:@"lat"];
        if (lat != (id)[NSNull null]){
            report.latitude = lat;
        }

        //Make sure the lng isn't null. If it isn't, assign it.
        NSString *lng = [reportDict objectForKey:@"lng"];
        if (lng != (id)[NSNull null]){
            report.longitude = lat;
        }
        
        //Deal with the dates (convert from time stamp/text)
        //Report Time (string) -- This is the time the report is for, not when it was submitted
        NSString *reportDateStr = [reportDict objectForKey:@"report_time"];
        
        //TODO: Need to test this with all months
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM dd,yyyy"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        
        NSDate *reportDate = [dateFormatter dateFromString: reportDateStr];
        //NSLog(@"Converted raw report time from %@ -> %@", reportDateStr, [reportDate description]);
        
        report.raw_report_time = reportDateStr;
        report.report_date = reportDate;
        
        //Posted Time (timestamp) -- When the report was actually posted to the site
        NSString *postedTimestamp = [reportDict objectForKey:@"posted"];
        report.posted_date = [NSDate dateWithTimeIntervalSince1970:[postedTimestamp doubleValue]];
        report.raw_posted_timestamp = postedTimestamp;
        
        //todo: activities?

        // Link up the foreign keys
        
        //Map the report to it's region
        // Note: The region can't always be found via it's location because it's possible the report doesn't belong to a known location
        Region *region = [Region MR_findFirstByAttribute:@"id" withValue:report.raw_region_id];
        if (region){
            report.region = region;
        } else {
            NSLog(@"Could not bind region id %@ for report", report.raw_region_id);
        }
        
        Location *location = [Location MR_findFirstByAttribute:@"id" withValue:report.raw_trail_id];
        if (location){
            report.location = location;
        } else {
            NSLog(@"Could not bind location id %@ for report", report.raw_trail_id);
        }
        
    }
    NSLog(@"Found %lul reports", (unsigned long)[parsedObject count]);

    
    [self saveContext];
}

-(void) syncAllReports:(void (^)(NSError* error))completionBlock{
    //TODO: I really need to turn this into a class member or singleton.
    PNGSnowIOCommunicator *comm = [[PNGSnowIOCommunicator alloc] init];
    [comm getMostRecentReportsWithOptions:nil completionBlock:^(NSData *data, NSHTTPURLResponse *response, NSError *error) {
        if (!error){
            NSLog(@"Retrieved JSON for Reports");
            [self buildReportsFromJSON:data];
        } else {
            NSLog(@"Error retrieving Reports from server");
        }
        
        if (completionBlock) {
            completionBlock(error);
        }
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
