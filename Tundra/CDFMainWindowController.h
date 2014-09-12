//
//  CDFMainWindowController.h
//  Tundra
//
//  Created by Christopher Fu on 9/8/14.
//  Copyright (c) 2014 Christopher Fu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CDFSeriesInfoArrayController.h"
#import "CDFSeriesListViewController.h"
#import "SeriesInfo.h"

@class CDFSeriesListViewController;

@interface CDFMainWindowController : NSWindowController <NSWindowDelegate>

@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) CDFSeriesListViewController *seriesListViewController;

@property (nonatomic) IBOutlet NSWindow *addSheet;
@property (nonatomic) IBOutlet NSTextField *addedSeriesName;
@property (strong) IBOutlet NSView *searchView;

- (void)showAddSheet;
- (IBAction)addSeries:(id)sender;

@end
