//
//  CDFMainWindowController.h
//  Tundra
//
//  Created by Christopher Fu on 9/8/14.
//  Copyright (c) 2014 Christopher Fu. All rights reserved.
//

/*
 * The main window controller of the application. At this moment, Tundra only
 * has one active window, although that may change in the future if we decide to
 * add an inspector window. CDFMainWindowController handles view switching logic
 * and the initializing of the list selection view.
 */

#import <Cocoa/Cocoa.h>
#import "CDFSeriesInfoArrayController.h"
#import "CDFListViewController.h"
#import "CDFSearchViewController.h"
#import "CDFPreferencesViewController.h"
#import "SeriesInfo.h"

@interface CDFMainWindowController : NSWindowController <NSWindowDelegate, NSOutlineViewDelegate>

@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) CDFListViewController *seriesListViewController;
@property (nonatomic) CDFSearchViewController *seriesSearchViewController;
@property (nonatomic) CDFPreferencesViewController *preferencesViewController;

@property (nonatomic) NSArray *viewControllers;

@property (strong) IBOutlet NSWindow *addSheet;
@property (strong) IBOutlet NSWindow *loginSheet;
@property (strong) IBOutlet NSWindow *preferencesWindow;
@property (nonatomic) IBOutlet NSTextField *addedSeriesName;
@property (weak) IBOutlet NSTextField *usernameField;
@property (weak) IBOutlet NSTextField *passwordField;
@property (strong) IBOutlet NSView *searchView;
@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSView *sidebarView;
@property (weak) IBOutlet NSView *activeView;
@property (weak) IBOutlet NSBox *box;
@property (weak) IBOutlet NSOutlineView *outlineView;

@property NSURLSession *session;
@property NSMutableArray *outlineSources;

- (void)showAddSheet;
- (void)attemptMALLogin:(NSString *)username password:(NSString *)password;

- (IBAction)addSeries:(id)sender;
- (IBAction)login:(id)sender;

@end
