//
//  CDFManagingViewController.h
//  Tundra
//
//  Created by Christopher Fu on 9/13/14.
//  Copyright (c) 2014 Christopher Fu. All rights reserved.
//

/*
 * The parent class of all Tundra view controllers. This is an abstract class
 * that is never directly instantiated. CDFManagingViewControllers contain
 * references to the managed object model for Core Data object access as well as
 * a pointer to the CDFMainWindowController that can be used, for example, to
 * notify the main window controller to show the series search sheet when the
 * user clicks the add button in the CDFListView. Managing View Controllers also
 * contain a property and a method to facilitate the sending of url requests.
 */

#import <Cocoa/Cocoa.h>

@class CDFMainWindowController;

@interface CDFManagingViewController : NSViewController <NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, weak) CDFMainWindowController *mainWindowController;
@property (nonatomic) NSMutableData *responseData;

- (NSURLConnection *)performRequestWithURLString:(NSString *)urlString;

@end
