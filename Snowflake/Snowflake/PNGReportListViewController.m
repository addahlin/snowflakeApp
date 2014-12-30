//
//  PNGReportListViewController.m
//  Snowflake
//
//  Created by Andrew Dahlin on 12/1/14.
//  Copyright (c) 2014 Pangomedia. All rights reserved.
//

#import "PNGReportListViewController.h"
#import "SWRevealViewController.h"
#import "Region+user.h"
#import "Report+user.h"
#import "PNGReportManager.h"

@interface PNGReportListViewController ()
    @property (strong, nonatomic) NSArray *reports;

@end

@implementation PNGReportListViewController 
{
    NSArray *myMenuItems;
    

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadRecentReports];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    myMenuItems = [NSArray arrayWithObjects:@"object 1", @"object 2", @"Object 3", nil];
    
    // Do any additional setup after loading the view.
    SWRevealViewController *revealController = [self revealViewController];
    
    //Add the gesture recognizers
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    //Add the widget at the top of the menu
    UIBarButtonItem *rightRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                              style:UIBarButtonItemStylePlain target:revealController action:@selector(rightRevealToggle:)];
    
    [rightRevealButtonItem setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = rightRevealButtonItem;

    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor grayColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self
                            action:@selector(updateData)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];

    
    
}

- (void) loadRecentReports {
    //Better as Singleton
    PNGReportManager *reportManager = [[PNGReportManager alloc] init];
    
    //Get all the cached report
    self.reports = [reportManager getAllReports];
    
    //Send an update request to the server to get the newest reports.
    [reportManager syncAllReports:^(NSError *error) {
        self.reports = [reportManager getAllReports];
        [self.tableView reloadData];
    }];
    
}

- (void) updateData{
    
    //Simulate a delay so we can get a feel for the look and feel of the UI
    NSLog(@"Running update...");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        //Hide the refresh controller
        [self.refreshControl endRefreshing];
        
        //        [self.tableView reloadData];


    });
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Report Count: %lul", (unsigned long)[self.reports count]);
    return [self.reports count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 102;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Snag a cell to reuse or create a new one
    static NSString *cellIdentifier = @"ReportSummaryViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //Grab the labels we need from the XIB file
    UILabel *locationLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *reportDateLabel = (UILabel *)[cell viewWithTag:101];
    UILabel *descLabel = (UILabel *)[cell viewWithTag:103];

    //Get the report to display
    Report *report = [self.reports objectAtIndex:indexPath.row];
    
    //locationLabel.text = report.trail.name;
    locationLabel.text = report.raw_trail_name;
    reportDateLabel.text = @"Wed Jun 26th 6:00PM";
    descLabel.text = report.text;
    
    return cell;
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // If they selected a specific safety minute, let the PNGSafetyMinuteDetailViewController know which one
     if ([[segue identifier] isEqualToString:@"showReportDetailFromList"]) {
         NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
         //PNGSafetyMinuteDetailViewController *destViewController = segue.destinationViewController;
         //destViewController.safetyMinute = [self.minutesForCategory objectAtIndex:indexPath.row];
         //destViewController.fromCategoryId = [self.category id];
     }

}


@end