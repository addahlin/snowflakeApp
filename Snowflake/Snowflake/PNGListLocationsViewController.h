//
//  PNGListLocationsViewController.h
//  Snowflake
//
//  Created by Andrew Dahlin on 10/15/14.
//  Copyright (c) 2014 Pangomedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Region+user.h"

@interface PNGListLocationsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

// Set by the viewController this transitioned from
@property Region *region;

@end
