//
//  PNGGetDataFromURLHelper.h
//  Snowflake
//
//  Created by Andrew Dahlin on 10/11/14.
//  Copyright (c) 2014 Pangomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNGSettings.h"

@interface PNGGetDataFromURLHelper : NSObject

//asynchronously get data from the server. calls completionBlock on the main thread passing in the data and any error
+(void) getDataFromURLAsync:(NSString *) urlString withCompletion: (void (^)(NSData* data, NSHTTPURLResponse *response, NSError* error))completionBlock;

+(NSData*) getDataFromURLSync:(NSString *) urlString
                  response:(NSURLResponse **)response
                     error:(NSError**) error;

@end
