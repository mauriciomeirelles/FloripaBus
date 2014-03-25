//
//  FLBMasterTableViewController.h
//  FloripaBus
//
//  Created by Mauricio Meirelles on 3/8/14.
//  Copyright (c) 2014 Mauricio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLBManager.h"

@interface FLBMasterTableViewController : UITableViewController <UISearchBarDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
