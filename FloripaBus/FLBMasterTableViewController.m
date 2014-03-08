//
//  FLBMasterTableViewController.m
//  FloripaBus
//
//  Created by Mauricio Meirelles on 3/8/14.
//  Copyright (c) 2014 Mauricio. All rights reserved.
//

#import "FLBMasterTableViewController.h"
#import "FLBDetailViewController.h"

@interface FLBMasterTableViewController ()
{
    NSMutableArray *routes;
}

@end

@implementation FLBMasterTableViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    routes = [[NSMutableArray alloc] init];
    
    [self.refreshControl beginRefreshing];
    [self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:YES];

    [_searchBar setUserInteractionEnabled:NO];
    _searchBar.alpha = .75;
    
    [self loadDataWithStopName:@""];
    
}

#pragma mark - Load from server

-(void)loadDataWithStopName: (NSString *)stopName
{
    [[FLBManager singleton] getRoutesWithStopName:stopName
                                          success:^(NSArray *routesAux) {
                                              
                                              routes = [routesAux mutableCopy];
                                              
                                              [self performSelectorOnMainThread:@selector(updateUI)
                                                                     withObject:nil
                                                                  waitUntilDone:NO];
                                          } error:^(NSString *errorMsg) {
                                              [self performSelectorOnMainThread:@selector(showErrorAlterWithMessage:)
                                                                     withObject:errorMsg
                                                                  waitUntilDone:NO];
                                          }];
}

#pragma mark - Update UI

-(void)updateUI
{
    [self.refreshControl endRefreshing];
    
    [_searchBar setUserInteractionEnabled:YES];
    _searchBar.alpha = 1;
    
    [self.tableView reloadData];
}

#pragma mark - Alert View

-(void)showErrorAlterWithMessage: (NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:@"Error"
                               message:message
                              delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil] show];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return routes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    FLBRoute *route = (FLBRoute *)routes[indexPath.row];
    
    UILabel *lblLongName = (UILabel *)[cell viewWithTag:10];
    UILabel *lblShortName = (UILabel *)[cell viewWithTag:11];

    lblLongName.text = route.longName;
    lblShortName.text = [NSString stringWithFormat:@"%d",route.shortName];

    return cell;
}

#pragma mark - UISearchBarDelegate Delegate Methods
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *stopName = [searchBar.text stringByReplacingCharactersInRange:range withString:text];

    [self loadDataWithStopName:stopName];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText isEqualToString:@""])
    {
        [self loadDataWithStopName:@""];
    }
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
    
    [self loadDataWithStopName:_searchBar.text];


}

#pragma mark - UIScrollView Delegate Methods

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
    
}

#pragma mark - Refresh Table

- (IBAction)refreshTable:(id)sender {
    
    [self loadDataWithStopName:_searchBar.text];

}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    FLBDetailViewController *detailVC = (FLBDetailViewController *)segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    detailVC.route = routes[indexPath.row];
}

 

@end
