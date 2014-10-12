//
//  Activity.h
//  Snowflake
//
//  Created by Andrew Dahlin on 10/11/14.
//  Copyright (c) 2014 Pangomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Activity : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * iconOnURL;
@property (nonatomic, retain) NSString * iconOffURL;
@property (nonatomic, retain) NSData * iconOn;
@property (nonatomic, retain) NSData * iconOff;

@end
