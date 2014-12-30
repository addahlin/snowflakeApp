//
//  PNGSettingsMenuViewController.m
//  Snowflake
//
//  Created by Andrew Dahlin on 12/17/14.
//  Copyright (c) 2014 Pangomedia. All rights reserved.
//

#import "PNGSettingsMenuViewController.h"

@interface PNGSettingsMenuViewController ()

@end

@implementation PNGSettingsMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Give the table an offset so the front frame doesn't cover it up
    CGRect tableRect = self.view.frame;
    tableRect.origin.x += 50; // make the table begin a few pixels right from its origin
    tableRect.size.width -= 50; // reduce the width of the table
    self.view.frame = tableRect;
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
