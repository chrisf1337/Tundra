//
//  CDFMainWindowController.m
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

#import "CDFMainWindowController.h"
#import "NSOutlineView+Additions.h"
#import "CDFManagingViewController.h"

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
    if (self)
    {
        self.outlineSources = [[NSMutableArray alloc] init];
        NSMutableDictionary *item1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"List", @"itemName", [NSMutableArray array], @"children", nil];
        NSMutableDictionary *item1_1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"All", @"itemName", [NSMutableArray array], @"children", nil];
        NSMutableDictionary *item1_2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Currently Watching", @"itemName", [NSMutableArray array], @"children", nil];
        NSMutableDictionary *item1_3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Plan to Watch", @"itemName", [NSMutableArray array], @"children", nil];
        NSMutableDictionary *item1_4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Completed", @"itemName", [NSMutableArray array], @"children", nil];
        NSMutableDictionary *item1_5 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"On Hold", @"itemName", [NSMutableArray array], @"children", nil];
        NSMutableDictionary *item1_6 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Dropped", @"itemName", [NSMutableArray array], @"children", nil];
        NSMutableDictionary *item2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Search", @"itemName", [NSMutableArray array], @"children", nil];
        NSMutableArray *item1Children = [item1 objectForKey:@"children"];
        [item1Children addObjectsFromArray:[NSArray arrayWithObjects:item1_1, item1_2, item1_3, item1_4, item1_5, item1_6, nil]];
        [self.outlineSources addObjectsFromArray:[NSArray arrayWithObjects:item1, item2, nil]];
        
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    self.box.contentView = self.seriesListViewController.view;
//    self.box.contentView = self.seriesSearchViewController.view;
    
    NSLog(@"%@", [self.outlineView itemAtRow:0]);
    [self.outlineView selectItem:[self.outlineView itemAtRow:0]];
    [self.outlineView expandItem:[self.outlineView itemAtRow:0]];
}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return self.managedObjectContext.undoManager;
}

- (void)showAddSheet;
{
    [NSApp beginSheet:self.addSheet modalForWindow:self.window modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
}


- (IBAction)addSeries:(id)sender
{
    [NSApp endSheet:self.addSheet];
    [self.addSheet orderOut:sender];
    NSLog(@"%@", self.addedSeriesName.stringValue);
    SeriesInfo *newSeries = [self.seriesListViewController.seriesInfoAllArrayController newObject];
    newSeries.name = self.addedSeriesName.stringValue;
    newSeries.status = [NSNumber numberWithInt:1];
    [self.seriesListViewController.seriesInfoAllArrayController addObject:newSeries];
    NSUInteger row = [[self.seriesListViewController.seriesInfoAllArrayController arrangedObjects] indexOfObjectIdenticalTo:newSeries];
    [self.seriesListViewController.tableView editColumn:1 row:row withEvent:nil select:YES];
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    return [self.outlineView makeViewWithIdentifier:@"DataCell" owner:self];
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    if (self.outlineView.selectedRow == 0)
    {
        self.box.contentView = self.seriesListViewController.view;
    }
    else if (self.outlineView.selectedRow == 1)
    {
        self.box.contentView = self.seriesListViewController.view;
        [self.seriesListViewController switchBindingsToArrayController:self.seriesListViewController.seriesInfoAllArrayController];
    }
    else if (self.outlineView.selectedRow == 2)
    {
        self.box.contentView = self.seriesListViewController.view;
        [self.seriesListViewController switchBindingsToArrayController:self.seriesListViewController.seriesInfoCurrentlyWatchingArrayController];
    }
    else if (self.outlineView.selectedRow == 3)
    {
        self.box.contentView = self.seriesListViewController.view;
        [self.seriesListViewController switchBindingsToArrayController:self.seriesListViewController.seriesInfoPlanToWatchArrayController];
    }
    else if (self.outlineView.selectedRow == 4)
    {
        self.box.contentView = self.seriesListViewController.view;
        [self.seriesListViewController switchBindingsToArrayController:self.seriesListViewController.seriesInfoCompletedArrayController];
    }
    else if (self.outlineView.selectedRow == 5)
    {
        self.box.contentView = self.seriesListViewController.view;
        [self.seriesListViewController switchBindingsToArrayController:self.seriesListViewController.seriesInfoOnHoldArrayController];
    }
    else if (self.outlineView.selectedRow == 6)
    {
        self.box.contentView = self.seriesListViewController.view;
        [self.seriesListViewController switchBindingsToArrayController:self.seriesListViewController.seriesInfoDroppedArrayController];
    }
    else if (self.outlineView.selectedRow == self.outlineView.numberOfRows - 1)
    {
        self.box.contentView = self.seriesSearchViewController.view;
    }
}

@end
