//
//  PNGGetDataFromURLHelper.m
//  Snowflake
//
//  Created by Andrew Dahlin on 10/11/14.
//  Copyright (c) 2014 Pangomedia. All rights reserved.
//

#import "PNGGetDataFromURLHelper.h"

@implementation PNGGetDataFromURLHelper

+(void) getDataFromURLAsync:(NSString *) urlString withCompletion: (void (^)(NSData* data, NSHTTPURLResponse *response, NSError* error))completionBlock{
    
    //Run it on a background thread...
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        NSError *error;
        
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:[[PNGSettings sharedInstance] getDefaultServerTimeout]];
        
        NSLog(@"Getting data from url: %@", urlString);
        
        NSHTTPURLResponse *response = nil;
        
        //synchronously call the server (the caller will be running this in an background thread)
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
        //Call the completionBlock on the main thread
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(data, response, error);
            }
        });

    });
}

+(NSData *) getDataFromURLSync:(NSString *) urlString

                  response:(NSURLResponse **)response
                     error:(NSError**) error{
    
        
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:[[PNGSettings sharedInstance] getDefaultServerTimeout]];
    
    NSLog(@"Getting data from url: %@", urlString);
    
    //synchronously call the server (the caller will be running this in an background thread)
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:response error:error];
    
    return data;
}

@end
