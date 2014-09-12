//
//  CDFMainWindowController.h
//  Tundra
//
//  Created by Christopher Fu on 9/8/14.
//  Copyright (c) 2014 Christopher Fu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CDFSeriesInfoArrayController.h"
#import "SeriesInfo.h"

@interface CDFMainWindowController : NSWindowController <NSWindowDelegate>

@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong) IBOutlet CDFSeriesInfoArrayController *seriesInfoArrayController;
@property (weak) IBOutlet NSTableView *tableView;
@property (nonatomic) IBOutlet NSWindow *addSheet;
@property (nonatomic) IBOutlet NSTextField *addedSeriesName;
@property (strong) IBOutlet NSView *searchView;

- (IBAction)addSeriesOld:(id)sender;
- (IBAction)showAddSheet:(id)sender;
- (IBAction)addSeries:(id)sender;

@end
