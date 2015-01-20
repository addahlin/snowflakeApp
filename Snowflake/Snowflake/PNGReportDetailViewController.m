//
//  PNGReportDetailViewController.m
//  Snowflake
//
//  Created by Andrew Dahlin on 12/17/14.
//  Copyright (c) 2014 Pangomedia. All rights reserved.
//

#import "PNGReportDetailViewController.h"

@interface PNGReportDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *ReportTitle;
@property (weak, nonatomic) IBOutlet UILabel *reportDateOutlet;
@property (weak, nonatomic) IBOutlet UILabel *reportAuthorOutlet;
@property (weak, nonatomic) IBOutlet UITextView *reportTextView;

@end

@implementation PNGReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // If we don't have a report, we don't have anything to show...
    if (!self.report) {
        return;
    }
    
    NSLog(@"Showing details for report: %@", self.report.raw_trail_name);
    
    self.reportTextView.text = self.report.text;
    self.ReportTitle.text = self.report.raw_trail_name;
    self.reportDateOutlet.text = self.report.raw_report_time;
    self.reportAuthorOutlet.text = self.report.poster_name;
 
    [self.reportAuthorOutlet sizeToFit];
    
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
