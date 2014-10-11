//
//  PNGSnowIOCommunicator.h
//  Snowflake
//
//  Created by Andrew Dahlin on 10/11/14.
//  Copyright (c) 2014 Pangomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNGGetDataFromURLHelper.h"

@interface PNGSnowIOCommunicator : NSObject

-(void) getActivitiesJSONwithCompletionBlock:(void (^)(NSData* data, NSHTTPURLResponse *response, NSError* error))completionBlock;

@end
