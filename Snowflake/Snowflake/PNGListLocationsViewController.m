//
//  PNGListLocationsViewController.m
//  Snowflake
//
//  Created by Andrew Dahlin on 10/15/14.
//  Copyright (c) 2014 Pangomedia. All rights reserved.
//

#import "PNGListLocationsViewController.h"
#import "PNGReportManager.h"

@interface PNGListLocationsViewController ()

@property (strong, nonatomic) NSArray *locations;

@end

@implementation PNGListLocationsViewController


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.locations count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *tableIdentifier = @"LocationTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    
    Region *region = (Region *)[self.locations objectAtIndex:indexPath.row];
    
    //TODO: add the number of reports into the title. In the future this could include how recently it's been updated
    // and how good the trail is (using color as indicators, etc)
    
    cell.textLabel.text = region.name;
    return cell;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //If we have a region set, only get locations from that region.
    // Otherwise load all the regions
    if (self.region){
        self.locations = [PNGReportManager getLocationsInRegion:self.region];
        
    } else {
        self.locations = [PNGReportManager getLocations];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
