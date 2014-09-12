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
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    [self.tableView setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [self.window setContentView:self.searchView];
}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return self.managedObjectContext.undoManager;
}

- (IBAction)addSeriesOld:(id)sender
{
    id newSeries = [self.seriesInfoArrayController newObject];
    [self.seriesInfoArrayController addObject:newSeries];
    NSUInteger row = [[self.seriesInfoArrayController arrangedObjects] indexOfObjectIdenticalTo:newSeries];
    [self.tableView editColumn:1 row:row withEvent:nil select:YES];
}

- (IBAction)showAddSheet:(id)sender
{
    [NSApp beginSheet:self.addSheet modalForWindow:self.window modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
}

- (IBAction)addSeries:(id)sender
{
    [NSApp endSheet:self.addSheet];
    [self.addSheet orderOut:sender];
    NSLog(@"%@", self.addedSeriesName.stringValue);
    SeriesInfo *newSeries = [self.seriesInfoArrayController newObject];
    newSeries.name = self.addedSeriesName.stringValue;
    [self.seriesInfoArrayController addObject:newSeries];
    NSUInteger row = [[self.seriesInfoArrayController arrangedObjects] indexOfObjectIdenticalTo:newSeries];
    [self.tableView editColumn:1 row:row withEvent:nil select:YES];
}

@end
