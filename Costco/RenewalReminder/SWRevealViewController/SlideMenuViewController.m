//
//  SlideMenuViewController.m
//  RenewalReminder
//
//  Created by MonuRathor on 01/02/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import "SlideMenuViewController.h"
#import "SWRevealViewController.h"
#import "TitleRowCell.h"
#import "HomeViewController.h"

@interface SlideMenuViewController ()
{
    NSArray *menus;
}
@end

@implementation SlideMenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    menus = @[@"logo", @"home", @"profile", @"setting", @"visit_website", @"logout", @"terms_of_use"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openHomePage) name:@"open_home" object:nil];
}

//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return menus.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 170.0f;
    }
    else{
        return 44.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [menus objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        TitleRowCell *cell = (TitleRowCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.lblName.text = [NSString stringWithFormat:@"%@. %@ %@",AppDelegate.sharedAppDelegate.me.title,AppDelegate.sharedAppDelegate.me.first_name,AppDelegate.sharedAppDelegate.me.surname];
        cell.lblRenewalCount.text = [NSString stringWithFormat:@"You've %ld renewals",(long)(AppDelegate.sharedAppDelegate.renewalsList30Days.count+AppDelegate.sharedAppDelegate.renewalsListOther.count)];
        return cell;
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[menus objectAtIndex:indexPath.row] isEqualToString:@"logout"]) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [[AppDelegate sharedAppDelegate] clearUser];
    }
    else if ([[menus objectAtIndex:indexPath.row] isEqualToString:@"visit_website"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.costco.co.uk"]];
    }
}

#pragma mark - Navigation

 - (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
}

- (void)openHomePage{
    [self performSegueWithIdentifier:@"open_home_page" sender:nil];
}

- (IBAction)clickedTermsOfUse:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.costcompare.co.uk/terms-of-use"]];
}


@end
