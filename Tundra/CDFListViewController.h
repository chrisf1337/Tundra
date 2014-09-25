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

@interface CDFListViewController : CDFManagingViewController <NSTableViewDelegate>

@property (strong) IBOutlet CDFSeriesInfoArrayController *seriesInfoAllArrayController;
@property (strong) IBOutlet CDFSeriesInfoArrayController *seriesInfoCurrentlyWatchingArrayController;
@property (strong) IBOutlet CDFSeriesInfoArrayController *seriesInfoCompletedArrayController;
@property (strong) IBOutlet CDFSeriesInfoArrayController *seriesInfoPlanToWatchArrayController;
@property (strong) IBOutlet CDFSeriesInfoArrayController *seriesInfoOnHoldArrayController;
@property (strong) IBOutlet CDFSeriesInfoArrayController *seriesInfoDroppedArrayController;
@property (strong) IBOutlet NSArrayController *popUpStatusNames;

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSSearchField *searchField;

@property (strong) NSArray *statusNames;

- (IBAction)addSeries:(id)sender;
- (void)sortList;
- (void)switchBindingsToArrayController:(CDFSeriesInfoArrayController *)arrayController;
- (IBAction)dumpData:(id)sender;

@end