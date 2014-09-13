//
//  CDFSeriesSearchViewController.h
//  Tundra
//
//  Created by Christopher Fu on 9/13/14.
//  Copyright (c) 2014 Christopher Fu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CDFMainWindowController.h"

@class CDFMainWindowController;

@interface CDFSeriesSearchViewController : NSViewController

@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, weak) CDFMainWindowController *mainWindowController;

@end
