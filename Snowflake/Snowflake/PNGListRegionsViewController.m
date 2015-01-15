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

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation PNGListRegionsViewController

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    // Return the number of sections.
    if ([self.regions count] > 0) {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
        
    } else {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];   //TODO: more appropriate font
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return 0;
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
    
    //Get the list of regions from the Manager
    self.regions = [PNGReportManager getRegions];
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor grayColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self
                            action:@selector(updateRegions)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
}

- (void) updateRegions{
    
    PNGReportManager *rm = [[PNGReportManager alloc] init];
    
    [rm syncRegions:^(NSError *error) {
        
        //TODO: Handle errors
        
        NSLog(@"Synced regions");
        //Hide the refresh controller
        [self.refreshControl endRefreshing];
        
        //update our list of regions
        self.regions = [PNGReportManager getRegions];
        [self.tableView reloadData];
        
    }];
    
    
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
