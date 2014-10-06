//
//  CDFAppDelegate.h
//  Tundra
//
//  Created by Christopher Fu on 9/7/14.
//  Copyright (c) 2014 Christopher Fu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CDFMainWindowController.h"
#import "CDFSeriesInfoArrayController.h"

@interface CDFAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) CDFMainWindowController *mainWindowController;

- (IBAction)saveAction:(id)sender;
- (IBAction)addSeries:(id)sender;
- (IBAction)showPreferencesWindow:(id)sender;

@end
