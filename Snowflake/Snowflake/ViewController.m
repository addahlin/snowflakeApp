//
//  ViewController.m
//  Snowflake
//
//  Created by Andrew Dahlin on 10/10/14.
//  Copyright (c) 2014 Pangomedia. All rights reserved.
//

#import "ViewController.h"

//This is a temporary import, it shouldn't communicate directly with this, but
// with a facade that hides where the data is coming from
#import "PNGSnowIOCommunicator.h"

#import "PNGReportManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *regionCountTextView;
@property (weak, nonatomic) IBOutlet UILabel *locationCountTextView;
@property (weak, nonatomic) IBOutlet UILabel *reportCountTextView;
@property (weak, nonatomic) IBOutlet UILabel *activitiesCountTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //TEMPORARY: just for testing before we have a real infrastructure setup
    PNGSnowIOCommunicator *serverComm = [[PNGSnowIOCommunicator alloc] init];
    
    /*
    //Get activities from the server
    [serverComm getActivitiesJSONwithCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Got response for activities: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } ];
    
    //Get Regions from the server
    [serverComm getRegionsJSONwithCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Got response for regions: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } ];
    
    //Get Locations from the server
    [serverComm getLocationsJSONwithCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Got response for regions: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } ];
     
    
    //Get most recent Reports
    NSDictionary *options = @{@"rows" : @1};
    
    //Get Locations from the server
    [serverComm getMostRecentReportsWithOptions:options completionBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Got response for reports: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } ];
    */
    PNGReportManager *reportManager = [[PNGReportManager alloc] init];
    
    [reportManager syncAppData:^(NSError *error) {
        [reportManager syncAllReports:^(NSError *error) {
            
        }];

    }];
    
        //[reportManager syncAllReports];
    
    //Update the UI
    [self refreshUI:nil];
    
    
}
- (IBAction)refreshUI:(id)sender {
    PNGReportManager *reportManager = [[PNGReportManager alloc] init];
    self.regionCountTextView.text = [NSString stringWithFormat:@"%lu", (unsigned long)[[reportManager getRegions] count]];
    
    self.activitiesCountTextView.text = [NSString stringWithFormat:@"%lu", (unsigned long)[[reportManager getActivites] count]];
    
    self.locationCountTextView.text = [NSString stringWithFormat:@"%lu", (unsigned long)[[reportManager getLocations] count]];
    
    self.reportCountTextView.text = [NSString stringWithFormat:@"%lu", (unsigned long)[[reportManager getAllReports] count]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
