//
//  CDFMainWindowController.m
//  Tundra
//
//  Created by Christopher Fu on 9/8/14.
//  Copyright (c) 2014 Christopher Fu. All rights reserved.
//

#import "CDFMainWindowController.h"

@interface CDFMainWindowController ()

@end

@implementation CDFMainWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)init
{
    self = [super initWithWindowNibName:@"CDFMainWindowController"];
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
//    [self.tableView setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
//    [self.window setContentView:self.searchView];
    self.window.contentView = self.seriesListViewController.view;
}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return self.managedObjectContext.undoManager;
}

- (void)showAddSheet
{
    [NSApp beginSheet:self.addSheet modalForWindow:self.window modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
}


- (IBAction)addSeries:(id)sender
{
    [NSApp endSheet:self.addSheet];
    [self.addSheet orderOut:sender];
    NSLog(@"%@", self.addedSeriesName.stringValue);
    SeriesInfo *newSeries = [self.seriesListViewController.seriesInfoArrayController newObject];
    newSeries.name = self.addedSeriesName.stringValue;
    [self.seriesListViewController.seriesInfoArrayController addObject:newSeries];
    NSUInteger row = [[self.seriesListViewController.seriesInfoArrayController arrangedObjects] indexOfObjectIdenticalTo:newSeries];
    [self.seriesListViewController.tableView editColumn:1 row:row withEvent:nil select:YES];
}

@end
