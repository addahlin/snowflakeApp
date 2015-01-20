//
//  PNGReportListViewController.m
//  Snowflake
//
//  Created by Andrew Dahlin on 12/1/14.
//  Copyright (c) 2014 Pangomedia. All rights reserved.
//

#import "PNGReportListViewController.h"
#import "PNGReportDetailViewController.h"
#import "SWRevealViewController.h"
#import "Region+user.h"
#import "Report+user.h"
#import "PNGReportManager.h"

@interface PNGReportListViewController ()
    @property (strong, nonatomic) NSArray *reports;

@end

@implementation PNGReportListViewController 
{
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadRecentReports];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

    //Listen for reports
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reportsUpdated:)
                                                 name:PNGReportsDidUpdateNotification object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:PNGReportsDidUpdateNotification object:nil];
    
}

//Called by PNGReport manager when reports have been updated from the server
-(void)reportsUpdated:(NSNotification *) notification {
    NSLog(@"*****Reports updated Notification Received!*****");
}

- (void) loadRecentReports {
    //Get all the cached report
    self.reports = [PNGReportManager getAllReports];
    //TODO: show a spinner so they know it's updating
    //Send an update request to the server to get the newest reports.
    [PNGReportManager syncAllReports:^(NSError *error) {
        //Update our list of reports and redisplay the table
        self.reports = [PNGReportManager getAllReports];
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
    
    // If we know the trial this is for, use that name. Otherwise use whatever they submitted
    if (report.trail) {
        locationLabel.text = report.trail.name;
    } else {
        locationLabel.text = report.raw_trail_name;
    }
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    reportDateLabel.text = [formatter stringFromDate:report.report_date];
    descLabel.text = report.text;
    
    return cell;
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // If they selected a specific safety minute, let the PNGSafetyMinuteDetailViewController know which one
     if ([[segue identifier] isEqualToString:@"showReportDetailFromList"]) {
         NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
         PNGReportDetailViewController *destViewController = segue.destinationViewController;
         destViewController.report = [self.reports objectAtIndex:indexPath.row];
     }

}


@end
