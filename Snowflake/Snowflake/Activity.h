//
//  Activity.h
//  Snowflake
//
//  Created by Andrew Dahlin on 1/15/15.
//  Copyright (c) 2015 Pangomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Activity : NSManagedObject

@property (nonatomic, retain) NSData * iconOff;
@property (nonatomic, retain) NSString * iconOffURL;
@property (nonatomic, retain) NSData * iconOn;
@property (nonatomic, retain) NSString * iconOnURL;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;

@end
