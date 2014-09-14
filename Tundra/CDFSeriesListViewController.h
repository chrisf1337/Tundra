//
//  CDFSeriesListViewController.h
//  Tundra
//
//  Created by Christopher Fu on 9/12/14.
//  Copyright (c) 2014 Christopher Fu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CDFManagingViewController.h"
#import "CDFSeriesInfoArrayController.h"

@interface CDFSeriesListViewController : CDFManagingViewController <NSTableViewDelegate>

@property (strong) IBOutlet CDFSeriesInfoArrayController *seriesInfoArrayController;
@property (weak) IBOutlet NSTableView *tableView;

- (IBAction)addSeries:(id)sender;
- (void)sortList;

@end
