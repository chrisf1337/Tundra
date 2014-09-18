//
//  CDFSeriesListViewController.m
//  Tundra
//
//  Created by Christopher Fu on 9/12/14.
//  Copyright (c) 2014 Christopher Fu. All rights reserved.
//

#import "CDFSeriesListViewController.h"
#import "CDFMainWindowController.h"
#import "XMLDictionary.h"
#import "SeriesInfo.h"

@interface CDFSeriesListViewController ()

@property (nonatomic) NSURLConnection *animeListRequest;

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
        self.responseData = [[NSMutableData alloc] init];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self sortList];
//    NSString *requestString = @"http://myanimelist.net/malappinfo.php?u=optikol&status=all&type=anime";
    NSString *requestString = @"http://localhost:8000/malappinfo.xml";
    self.animeListRequest = [self performRequestWithURLString:requestString];
    
    NSFetchRequest *allSeries = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SeriesInfo" inManagedObjectContext:self.managedObjectContext];
    allSeries.entity = entity;
    NSError *error = nil;
    NSArray *series = [self.managedObjectContext executeFetchRequest:allSeries error:&error];
    for (SeriesInfo *info in series)
    {
        [self.managedObjectContext deleteObject:info];
    }
    [self.managedObjectContext save:&error];
}

- (IBAction)addSeries:(id)sender
{
    [self.mainWindowController showAddSheet];
}

- (void)sortList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
//    [self.tableView setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSLog(@"%@", self.seriesInfoAllArrayController.sortDescriptors);
    NSLog(@"%@", self.seriesInfoCurrentlyWatchingArrayController.sortDescriptors);
    self.seriesInfoAllArrayController.sortDescriptors = @[sortDescriptor];
    [self.seriesInfoAllArrayController rearrangeObjects];
    self.seriesInfoCurrentlyWatchingArrayController.sortDescriptors = @[sortDescriptor];
    [self.seriesInfoCurrentlyWatchingArrayController rearrangeObjects];
    self.seriesInfoCompletedArrayController.sortDescriptors = @[sortDescriptor];
    [self.seriesInfoCurrentlyWatchingArrayController rearrangeObjects];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData.length = 0;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"Received data!");
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == self.animeListRequest)
    {
        NSLog(@"%@", [NSString stringWithUTF8String:[self.responseData bytes]]);
        NSError *error;
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        nf.numberStyle = NSNumberFormatterDecimalStyle;
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:self.responseData];
        NSLog(@"%@", [xmlDoc objectForKey:@"myinfo"]);
        NSLog(@"%lu", [(NSArray *)[xmlDoc objectForKey:@"anime"] count]);
        NSArray *animeSeries = [xmlDoc objectForKey:@"anime"];
        for (NSDictionary *series in animeSeries)
        {
            NSLog(@"%@", [series objectForKey:@"series_title"]);
            NSLog(@"%@/%@", [series objectForKey:@"my_watched_episodes"], [series objectForKey:@"series_episodes"]);
            SeriesInfo *seriesInfo = [NSEntityDescription insertNewObjectForEntityForName:@"SeriesInfo"
                                                                   inManagedObjectContext:self.managedObjectContext];
            seriesInfo.name = [series objectForKey:@"series_title"];
            seriesInfo.episodesWatched = [nf numberFromString:[series objectForKey:@"my_watched_episodes"]];
            seriesInfo.totalEpisodes = [nf numberFromString:[series objectForKey:@"series_episodes"]];
            seriesInfo.status = [nf numberFromString:[series objectForKey:@"my_status"]];
        }
        [self.managedObjectContext save:&error];
    }
}

- (IBAction)dumpData:(id)sender
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SeriesInfo"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSLog(@"--START--");
    for (SeriesInfo *info in fetchedObjects)
    {
        NSLog(@"%@ (%@/%@, status: %@)", info.name, info.episodesWatched, info.totalEpisodes, info.status);
    }
    NSLog(@"--END--");
}

- (void)switchBindingsToArrayController:(CDFSeriesInfoArrayController *)arrayController
{
    [self.tableView unbind:NSContentBinding];
    [self.tableView unbind:NSSelectionIndexesBinding];
    [self.tableView unbind:NSSortDescriptorsBinding];
    [self.searchField unbind:NSPredicateBinding];
    [self.tableView bind:NSContentBinding
                toObject:arrayController
             withKeyPath:@"arrangedObjects"
                 options:[NSDictionary dictionaryWithObject:NSOptionsKey forKey:NSRaisesForNotApplicableKeysBindingOption]];
    [self.tableView bind:NSSelectionIndexesBinding
                toObject:arrayController
             withKeyPath:@"selectionIndexes"
                 options:[NSDictionary dictionaryWithObject:NSOptionsKey forKey:NSRaisesForNotApplicableKeysBindingOption]];
    [self.tableView bind:NSSortDescriptorsBinding
                toObject:arrayController
             withKeyPath:@"sortDescriptors"
                 options:[NSDictionary dictionaryWithObject:NSOptionsKey forKey:NSRaisesForNotApplicableKeysBindingOption]];
    [self.searchField bind:NSPredicateBinding
                  toObject:arrayController
               withKeyPath:@"filterPredicate"
                   options:[NSDictionary dictionaryWithObjectsAndKeys:@"predicate", NSDisplayNameBindingOption,
                            @"name contains[cd] $value", NSPredicateFormatBindingOption, nil]];
}

@end
