//
//  PNGSnowIOCommunicator.h
//  Snowflake
//
//  Created by Andrew Dahlin on 10/11/14.
//  Copyright (c) 2014 Pangomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNGGetDataFromURLHelper.h"

//Keys for the options dictionary to reports can be:
// - rows : limit the number of rows returned
// - trail : Only get Reports for the given trail ID
// - region : Only get Reports for teh given region ID
// - q : perform a search over the reports
// - since : only return reports created since a given time

@interface PNGSnowIOCommunicator : NSObject

-(void) getActivitiesJSONwithCompletionBlock:(void (^)(NSData* data, NSHTTPURLResponse *response, NSError* error))completionBlock;

-(void) getRegionsJSONwithCompletionBlock:(void (^)(NSData* data, NSHTTPURLResponse *response, NSError* error))completionBlock;

-(void) getLocationsJSONwithCompletionBlock:(void (^)(NSData* data, NSHTTPURLResponse *response, NSError* error))completionBlock;

-(void) getMostRecentReportsWithOptions:(NSDictionary *) options
                               completionBlock:(void (^)(NSData* data, NSHTTPURLResponse *response, NSError* error)) completionBlock;

-(void) getMostRececentReportsForLocation: (NSString *)locationID options:(NSDictionary *) options completionBlock:(void (^)(NSData* data, NSHTTPURLResponse *response, NSError* error)) completionBlock;

@end
