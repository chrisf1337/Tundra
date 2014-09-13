//
//  CDFSeriesListViewController.h
//  Tundra
//
//  Created by Christopher Fu on 9/12/14.
//  Copyright (c) 2014 Christopher Fu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CDFMainWindowController.h"

@class CDFMainWindowController;

@interface CDFSeriesListViewController : NSViewController <NSTableViewDelegate>

@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong) IBOutlet CDFSeriesInfoArrayController *seriesInfoArrayController;
@property (weak) IBOutlet NSTableView *tableView;

@property (nonatomic, weak) CDFMainWindowController *mainWindowController;

- (IBAction)addSeries:(id)sender;
- (void)sortList;

@end
