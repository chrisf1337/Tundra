//
//  CDFSeriesListViewController.m
//  Tundra
//
//  Created by Christopher Fu on 9/12/14.
//  Copyright (c) 2014 Christopher Fu. All rights reserved.
//

#import "CDFSeriesListViewController.h"

@interface CDFSeriesListViewController ()

@end

@implementation CDFSeriesListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (instancetype)init
{
    self = [super initWithNibName:@"CDFSeriesListView" bundle:nil];
    if (self)
    {
        self.title = @"Series List View";
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self sortList];
}

- (IBAction)addSeries:(id)sender
{
    [self.mainWindowController showAddSheet];
}

- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSLog(@"tablewView:shouldEditTableColumn:row:");
    return YES;
}

- (void)sortList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    [self.tableView setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

@end
