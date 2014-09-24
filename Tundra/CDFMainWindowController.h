//
//  CDFMainWindowController.h
//  Tundra
//
//  Created by Christopher Fu on 9/8/14.
//  Copyright (c) 2014 Christopher Fu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CDFSeriesInfoArrayController.h"
#import "CDFListViewController.h"
#import "CDFSearchViewController.h"
#import "SeriesInfo.h"

@interface CDFMainWindowController : NSWindowController <NSWindowDelegate, NSOutlineViewDelegate>

@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) CDFListViewController *seriesListViewController;
@property (nonatomic) CDFSearchViewController *seriesSearchViewController;

@property (nonatomic) NSArray *viewControllers;

@property (nonatomic) IBOutlet NSWindow *addSheet;
@property (nonatomic) IBOutlet NSTextField *addedSeriesName;
@property (strong) IBOutlet NSView *searchView;
@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSView *sidebarView;
@property (weak) IBOutlet NSView *activeView;
@property (weak) IBOutlet NSBox *box;
@property (weak) IBOutlet NSOutlineView *outlineView;

@property NSMutableArray *outlineSources;

- (void)showAddSheet;
- (IBAction)addSeries:(id)sender;

@end
