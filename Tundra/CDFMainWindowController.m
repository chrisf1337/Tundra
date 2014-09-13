//
//  CDFMainWindowController.m
//  Tundra
//
//  Created by Christopher Fu on 9/8/14.
//  Copyright (c) 2014 Christopher Fu. All rights reserved.
//

#import "CDFMainWindowController.h"
#import "NSOutlineView+Additions.h"

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
        NSMutableDictionary *item2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Search", @"itemName", [NSMutableArray array], @"children", nil];
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
    [self.seriesListViewController.seriesInfoArrayController rearrangeObjects];
    NSUInteger row = [[self.seriesListViewController.seriesInfoArrayController arrangedObjects] indexOfObjectIdenticalTo:newSeries];
    [self.seriesListViewController.tableView editColumn:1 row:row withEvent:nil select:YES];
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    return [self.outlineView makeViewWithIdentifier:@"DataCell" owner:self];
}

@end
