//
//  PNGListRegionsViewController.m
//  Snowflake
//
//  Created by Andrew Dahlin on 10/15/14.
//  Copyright (c) 2014 Pangomedia. All rights reserved.
//

#import "PNGListRegionsViewController.h"
#import "PNGReportManager.h"
#import "PNGListLocationsViewController.h"

@interface PNGListRegionsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *regions;
@end

@implementation PNGListRegionsViewController

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.regions count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *tableIdentifier = @"RegionTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    
    Region *region = (Region *)[self.regions objectAtIndex:indexPath.row];
    
    cell.textLabel.text = region.name;
    return cell;
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PNGReportManager *rm = [[PNGReportManager alloc] init];
    
    self.regions = [rm getRegions];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"RegionToLocationSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PNGListLocationsViewController *destViewController = segue.destinationViewController;
        destViewController.region = [self.regions objectAtIndex:indexPath.row];
    }
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
