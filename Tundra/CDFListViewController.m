//
//  CDFSeriesListViewController.m
//  Tundra
//
//  Created by Christopher Fu on 9/12/14.
//  Copyright (c) 2014 Christopher Fu. All rights reserved.
//

/*
 * CDFListViewController controls the logic for the series list. It contains
 * array controllers for all the status categories: currently watching,
 * compeleted, planned, on hold, and dropped. These array controllers are bound
 * to view-based NSTableView (actually CDFTableView) columns. Switching in
 * between these categories on the NSOutlineView switches which array controller
 * is currently bound to the table view. The list view controller is in charge
 * of handling user edits to the series list and saving those changes to the
 * Core Data store and can be perhaps considered the most important function of
 * Tundra.
 */

#import "CDFListViewController.h"
#import "CDFMainWindowController.h"
#import "XMLDictionary.h"
#import "SeriesInfo.h"

@interface CDFListViewController ()

@property (nonatomic) NSURLConnection *animeListSyncDataRequest;
@property (nonatomic) NSURLConnection *animeListPullDataRequest;
@property (nonatomic) NSArray *allSeriesArray;

@end

@implementation CDFListViewController

static void *CDFKVOContext;

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
    self = [super initWithNibName:@"CDFListView" bundle:nil];
    if (self)
    {
        self.title = @"Series List View";
        self.responseData = [[NSMutableData alloc] init];
        self.statusNames = @[@"Currently Watching", @"Plan to Watch", @"Completed", @"On Hold", @"Dropped"];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self sortList];
    
    NSFetchRequest *allSeries = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SeriesInfo" inManagedObjectContext:self.managedObjectContext];
    allSeries.entity = entity;
    NSError *error = nil;
    self.allSeriesArray = [self.managedObjectContext executeFetchRequest:allSeries error:&error];
    
    // deletion code moved to pullData:
    
    NSString *requestString = @"http://myanimelist.net/malappinfo.php?u=optikol&status=all&type=anime";
//    NSString *requestString = @"http://localhost:8000/malappinfo.xml";
    self.animeListSyncDataRequest = [self performRequestWithURLString:requestString];
}

- (IBAction)addSeries:(id)sender
{
    [self.mainWindowController showAddSheet];
}

- (IBAction)pullData:(id)sender
{
    for (SeriesInfo *info in self.allSeriesArray)
    {
        [self stopObservingSeries:info];
        [self.managedObjectContext deleteObject:info];
    }
    NSString *requestString = @"http://myanimelist.net/malappinfo.php?u=optikol&status=all&type=anime";
    self.animeListPullDataRequest = [self performRequestWithURLString:requestString];
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
    
    self.seriesInfoPlanToWatchArrayController.sortDescriptors = @[sortDescriptor];
    [self.seriesInfoPlanToWatchArrayController rearrangeObjects];
    
    self.seriesInfoCompletedArrayController.sortDescriptors = @[sortDescriptor];
    [self.seriesInfoCurrentlyWatchingArrayController rearrangeObjects];
    
    self.seriesInfoOnHoldArrayController.sortDescriptors = @[sortDescriptor];
    [self.seriesInfoOnHoldArrayController rearrangeObjects];
    
    self.seriesInfoDroppedArrayController.sortDescriptors = @[sortDescriptor];
    [self.seriesInfoDroppedArrayController rearrangeObjects];
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
    if (connection == self.animeListSyncDataRequest)
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
//            SeriesInfo *seriesInfo = [NSEntityDescription insertNewObjectForEntityForName:@"SeriesInfo"
//                                                                   inManagedObjectContext:self.managedObjectContext];
//            seriesInfo.name = [series objectForKey:@"series_title"];
//            seriesInfo.episodesWatched = [nf numberFromString:[series objectForKey:@"my_watched_episodes"]];
//            seriesInfo.totalEpisodes = [nf numberFromString:[series objectForKey:@"series_episodes"]];
//            seriesInfo.status = [nf numberFromString:[series objectForKey:@"my_status"]];
//            seriesInfo.idNumber = [nf numberFromString:[series objectForKey:@"series_animedb_id"]];
//            seriesInfo.lastUpdated = [nf numberFromString:[series objectForKey:@"my_last_updated"]];
//            [self startObservingSeries:seriesInfo];
            
//            for (SeriesInfo *existingSeries in self.allSeriesArray)
//            {
//                if ([existingSeries.idNumber isEqualToNumber:[nf numberFromString:[series objectForKey:@"series_animedb_id"]]])
//                {
//                    NSLog(@"%@ (%@): %@", existingSeries.name, existingSeries.idNumber, [series objectForKey:@"series_animedb_id"]);
//                }
//            }
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idNumber == %@", [nf numberFromString:[series objectForKey:@"series_animedb_id"]]];
            NSArray *results = [self.allSeriesArray filteredArrayUsingPredicate:predicate];
            if (results.count == 0)
            {
                NSLog(@"New series found: %@. Syncing info.", [series objectForKey:@"series_title"]);
                SeriesInfo *seriesInfo = [NSEntityDescription insertNewObjectForEntityForName:@"SeriesInfo"
                                                                       inManagedObjectContext:self.managedObjectContext];
                seriesInfo.name = [series objectForKey:@"series_title"];
                seriesInfo.episodesWatched = [nf numberFromString:[series objectForKey:@"my_watched_episodes"]];
                seriesInfo.totalEpisodes = [nf numberFromString:[series objectForKey:@"series_episodes"]];
                seriesInfo.status = [nf numberFromString:[series objectForKey:@"my_status"]];
                seriesInfo.idNumber = [nf numberFromString:[series objectForKey:@"series_animedb_id"]];
                seriesInfo.lastUpdated = [nf numberFromString:[series objectForKey:@"my_last_updated"]];
            }
            else if (results.count == 1)
            {
                if ([((SeriesInfo *)results[0]).lastUpdated isLessThan:[nf numberFromString:[series objectForKey:@"my_last_updated"]]])
                {
                    NSLog(@"Newer info for %@. Syncing info.", ((SeriesInfo *)results[0]).name);
                    [self.managedObjectContext deleteObject:results[0]];
                    SeriesInfo *seriesInfo = [NSEntityDescription insertNewObjectForEntityForName:@"SeriesInfo"
                                                                           inManagedObjectContext:self.managedObjectContext];
                    seriesInfo.name = [series objectForKey:@"series_title"];
                    seriesInfo.episodesWatched = [nf numberFromString:[series objectForKey:@"my_watched_episodes"]];
                    seriesInfo.totalEpisodes = [nf numberFromString:[series objectForKey:@"series_episodes"]];
                    seriesInfo.status = [nf numberFromString:[series objectForKey:@"my_status"]];
                    seriesInfo.idNumber = [nf numberFromString:[series objectForKey:@"series_animedb_id"]];
                    seriesInfo.lastUpdated = [nf numberFromString:[series objectForKey:@"my_last_updated"]];
                }
            }
        }
        [self.managedObjectContext save:&error];
        NSFetchRequest *allSeries = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"SeriesInfo" inManagedObjectContext:self.managedObjectContext];
        allSeries.entity = entity;
        self.allSeriesArray = [self.managedObjectContext executeFetchRequest:allSeries error:&error];
        for (SeriesInfo *info in self.allSeriesArray)
        {
            [self startObservingSeries:info];
        }
    }
    else if (connection == self.animeListPullDataRequest)
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
            SeriesInfo *seriesInfo = [NSEntityDescription insertNewObjectForEntityForName:@"SeriesInfo"
                                                                   inManagedObjectContext:self.managedObjectContext];
            seriesInfo.name = [series objectForKey:@"series_title"];
            seriesInfo.episodesWatched = [nf numberFromString:[series objectForKey:@"my_watched_episodes"]];
            seriesInfo.totalEpisodes = [nf numberFromString:[series objectForKey:@"series_episodes"]];
            seriesInfo.status = [nf numberFromString:[series objectForKey:@"my_status"]];
            seriesInfo.idNumber = [nf numberFromString:[series objectForKey:@"series_animedb_id"]];
            seriesInfo.lastUpdated = [nf numberFromString:[series objectForKey:@"my_last_updated"]];
            [self startObservingSeries:seriesInfo];
        }
        [self.managedObjectContext save:&error];
        NSFetchRequest *allSeries = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"SeriesInfo" inManagedObjectContext:self.managedObjectContext];
        allSeries.entity = entity;
        self.allSeriesArray = [self.managedObjectContext executeFetchRequest:allSeries error:&error];
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
        NSLog(@"%@ (%@/%@, status: %@, id: %@, last updated: %@)", info.name, info.episodesWatched, info.totalEpisodes,
              info.status, info.idNumber, info.lastUpdated);
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

- (void)startObservingSeries:(SeriesInfo *)series
{
    [series addObserver:self forKeyPath:@"episodesWatched" options:NSKeyValueObservingOptionNew context:&CDFKVOContext];
    [series addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:&CDFKVOContext];
}

- (void)stopObservingSeries:(SeriesInfo *)series
{
    [series removeObserver:self forKeyPath:@"episodesWatched" context:&CDFKVOContext];
    [series removeObserver:self forKeyPath:@"status" context:&CDFKVOContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == &CDFKVOContext)
    {
        id newValue = [change objectForKey:NSKeyValueChangeNewKey];
        NSLog(@"%@ %@", ((SeriesInfo *)object).name, newValue);
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
