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
#import <XMLDictionary/XMLDictionary.h>
#import <SSKeychain/SSKeychain.h>
#import "SeriesInfo.h"
#import "apikeys.h"

@interface CDFListViewController ()

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
        self.statusNames = @[@"Currently Watching", @"Plan to Watch", @"Completed", @"On Hold", @"Dropped"];
        self.currentlySelectedStatus = 1;
        [self fetchAllSeries];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.currentSeriesInfoArrayController = self.seriesInfoAllArrayController;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDataModelChange:)
                                                 name:NSManagedObjectContextObjectsDidChangeNotification
                                               object:self.managedObjectContext];
    // This hack is disgusting, but it's getting really late
    // Blame Core Data and threading shenanigans
    [self performSelector:@selector(startObservingAllSeries) withObject:self afterDelay:0.3];

    [self refreshAllSeriesArray];
    // deletion code moved to pullData:
    [SSKeychain setPassword:@"password" forService:@"Tundra MAL" account:@"optikol"];
    NSLog(@"%@", [SSKeychain passwordForService:@"Tundra MAL" account:@"optikol"]);
}

- (IBAction)addSeries:(id)sender
{
    [self.mainWindowController showAddSheet];
}

- (IBAction)removeSeries:(id)sender
{
//    for (SeriesInfo *series in self.currentSeriesInfoArrayController.selectedObjects)
//    {
//        [self stopObservingSeries:series];
//    }
    [self.currentSeriesInfoArrayController remove:self];
    [self refreshAllSeriesArray];
}

- (void)sortList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    
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
        NSLog(@"%@ (%@/%@, status: %@, id: %@, last updated: %@), start: %@, end: %@", info.name, info.episodesWatched, info.totalEpisodes,
              info.status, info.idNumber, info.lastUpdated, info.startDate, info.endDate);
    }
    NSLog(@"--END--");

}

- (void)startObservingAllSeries
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SeriesInfo"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (SeriesInfo *info in fetchedObjects)
    {
        [self startObservingSeries:info];
    }
}

- (void)switchBindingsToArrayController:(CDFSeriesInfoArrayController *)arrayController
{
    self.currentSeriesInfoArrayController = arrayController;
    [self.tableView unbind:NSContentBinding];
    [self.tableView unbind:NSSelectionIndexesBinding];
    [self.tableView unbind:NSSortDescriptorsBinding];
    [self.searchField unbind:NSPredicateBinding];
    [self.statusField unbind:[NSString stringWithFormat:@"%@1", NSDisplayPatternValueBinding]]; // @"displayPatternValue1"
    [self.statusField unbind:[NSString stringWithFormat:@"%@2", NSDisplayPatternValueBinding]]; // @"displayPatternValue2"
    [self.removeButton unbind:NSEnabledBinding];
    [self.tableView bind:NSContentBinding
                toObject:arrayController
             withKeyPath:@"arrangedObjects"
                 options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:NSRaisesForNotApplicableKeysBindingOption]];
    [self.tableView bind:NSSelectionIndexesBinding
                toObject:arrayController
             withKeyPath:@"selectionIndexes"
                 options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:NSRaisesForNotApplicableKeysBindingOption]];
    [self.tableView bind:NSSortDescriptorsBinding
                toObject:arrayController
             withKeyPath:@"sortDescriptors"
                 options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:NSRaisesForNotApplicableKeysBindingOption]];
    [self.searchField bind:NSPredicateBinding
                  toObject:arrayController
               withKeyPath:@"filterPredicate"
                   options:[NSDictionary dictionaryWithObjectsAndKeys:@"predicate", NSDisplayNameBindingOption,
                            @"name contains[cd] $value", NSPredicateFormatBindingOption, [NSNumber numberWithBool:YES],
                            NSRaisesForNotApplicableKeysBindingOption, nil]];
    [self.statusField bind:[NSString stringWithFormat:@"%@1", NSDisplayPatternValueBinding]
                  toObject:arrayController
               withKeyPath:@"selection.@count"
                   options:[NSDictionary dictionaryWithObjectsAndKeys:@"%{value1}@ of %{value2}@ series", NSDisplayPatternBindingOption,
                            [NSNumber numberWithBool:YES], NSRaisesForNotApplicableKeysBindingOption, nil]];
    [self.statusField bind:[NSString stringWithFormat:@"%@2", NSDisplayPatternValueBinding]
                  toObject:arrayController
               withKeyPath:@"arrangedObjects.@count"
                   options:[NSDictionary dictionaryWithObjectsAndKeys:@"%{value1}@ of %{value2}@ series", NSDisplayPatternBindingOption,
                            [NSNumber numberWithBool:YES], NSRaisesForNotApplicableKeysBindingOption, nil]];
    [self.removeButton bind:NSEnabledBinding
                   toObject:arrayController
                withKeyPath:@"canRemove"
                    options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:NSRaisesForNotApplicableKeysBindingOption]];
}

- (void)startObservingSeries:(SeriesInfo *)series
{
    [series addObserver:self forKeyPath:@"episodesWatched" options:NSKeyValueObservingOptionOld context:&CDFKVOContext];
    [series addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionOld context:&CDFKVOContext];
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
        id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
        if (![oldValue isEqualTo:[object valueForKey:keyPath]] && object != nil)
        {
            SeriesInfo *series = (SeriesInfo *)object;
            NSLog(@"%@ %@ %@", ((SeriesInfo *)object).name, oldValue, series.episodesWatched);
            NSMutableDictionary *seriesDict = [[NSMutableDictionary alloc] init];
            NSMutableDictionary *entry = [[NSMutableDictionary alloc] init];
            [entry setValue:series.episodesWatched forKey:@"episode"];
            [entry setValue:series.status forKey:@"status"];
            [seriesDict setValue:entry forKey:@"entry"];
            NSString *requestString = [NSString stringWithFormat:@"http://%@:%@@myanimelist.net/api/animelist/update/19769.xml", MAL_USERNAME, MAL_PASSWORD];
            NSURL *url = [NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            request.HTTPBody = [[NSString stringWithFormat:@"data=%@", [seriesDict XMLString]] dataUsingEncoding:NSUTF8StringEncoding];
            request.HTTPMethod = @"POST";
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            void (^completionHandler)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error)
            {
                if (!error)
                {
                    NSLog(@"%@", [NSString stringWithUTF8String:data.bytes]);
                }
            };
            NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                             completionHandler:completionHandler];
            [dataTask resume];
            NSLog(@"%@", [seriesDict XMLString]);
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)refreshAllSeriesArray
{
    NSFetchRequest *allSeries = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SeriesInfo" inManagedObjectContext:self.managedObjectContext];
    allSeries.entity = entity;
    NSError *error = nil;
    self.allSeriesArray = [self.managedObjectContext executeFetchRequest:allSeries error:&error];
}

- (void)fetchAllSeries
{
    NSString *requestString = @"http://myanimelist.net/malappinfo.php?u=optikol&status=all&type=anime";
    NSURL *url = [NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    void (^completionHandler)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSManagedObjectContext *managedObjectContext = [self createNewManagedObjectContext];
        NSFetchRequest *allSeries = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"SeriesInfo" inManagedObjectContext:managedObjectContext];
        allSeries.entity = entity;
        NSArray *allSeriesArray = [managedObjectContext executeFetchRequest:allSeries error:&error];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(mergeChanges:) name:NSManagedObjectContextDidSaveNotification object:managedObjectContext];
        if (!error)
        {
            NSError *error;
            NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
            nf.numberStyle = NSNumberFormatterDecimalStyle;
            NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
            NSArray *animeSeries = [xmlDoc objectForKey:@"anime"];
            for (NSDictionary *series in animeSeries)
            {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idNumber == %@", [nf numberFromString:[series objectForKey:@"series_animedb_id"]]];
                NSArray *results = [allSeriesArray filteredArrayUsingPredicate:predicate];
                if (results.count == 0)
                {
                    NSLog(@"New series found: %@. Syncing info.", [series objectForKey:@"series_title"]);
                    SeriesInfo *seriesInfo = [NSEntityDescription insertNewObjectForEntityForName:@"SeriesInfo"
                                                                           inManagedObjectContext:managedObjectContext];
                    [seriesInfo initSeriesInfoUsingValues:series];
                }
                else if (results.count == 1)
                {
                    if ([((SeriesInfo *)results[0]).lastUpdated isLessThan:[nf numberFromString:[series objectForKey:@"my_last_updated"]]])
                    {
                        NSLog(@"Newer info for %@. Syncing info.", ((SeriesInfo *)results[0]).name);
                        SeriesInfo *seriesInfo = results[0];
                        [seriesInfo initSeriesInfoUsingValues:series];
                    }
                }
            }
            [managedObjectContext save:&error];
            [self sortList];
        }
    };
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url
                                                 completionHandler:completionHandler];
    [dataTask resume];
}

- (IBAction)pullData:(id)sender
{
    [self refreshAllSeriesArray];
    for (SeriesInfo *info in self.allSeriesArray)
    {
        [self stopObservingSeries:info];
        [self.managedObjectContext deleteObject:info];
    }
    NSString *requestString = @"http://myanimelist.net/malappinfo.php?u=optikol&status=all&type=anime";
    NSURL *url = [NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    void (^completionHandler)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if (!error)
        {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200)
            {
                NSError *error;
                NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLData:data];
                NSArray *animeSeries = [xmlDoc objectForKey:@"anime"];
                for (NSDictionary *series in animeSeries)
                {
                    SeriesInfo *seriesInfo = [NSEntityDescription insertNewObjectForEntityForName:@"SeriesInfo"
                                                                           inManagedObjectContext:self.managedObjectContext];
                    [seriesInfo initSeriesInfoUsingValues:series];
                    [self startObservingSeries:seriesInfo];
                }
                [self.managedObjectContext save:&error];
                NSFetchRequest *allSeries = [[NSFetchRequest alloc] init];
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"SeriesInfo" inManagedObjectContext:self.managedObjectContext];
                allSeries.entity = entity;
                self.allSeriesArray = [self.managedObjectContext executeFetchRequest:allSeries error:&error];
            }
        }
    };
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url
                                                 completionHandler:completionHandler];
    [dataTask resume];
}

- (void)handleDataModelChange:(NSNotification *)notification
{
    NSLog(@"change detected!");
}

- (NSManagedObjectContext *)createNewManagedObjectContext
{
    NSManagedObjectContext *managedObjectContext = nil;
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}

- (void)mergeChanges:(NSNotification *)notification
{
    @synchronized(self)
    {
        [self.managedObjectContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
                                                    withObject:notification
                                                 waitUntilDone:YES];
    }
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSLog(@"tableViewSelectionDidChange:");
//    if (self.tableView.numberOfSelectedRows == 1)
//    {
//        NSString *imageUrl = ((SeriesInfo *)self.currentSeriesInfoArrayController.selectedObjects[0]).imageUrl;
//        NSURL *url = [NSURL URLWithString:[imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        NSURLSessionDownloadTask *downloadImageTask = [self.session downloadTaskWithURL:url
//                                                                      completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
//                                                                          self.imageView.image = [[NSImage alloc] initWithData:[NSData dataWithContentsOfURL:location]];
//                                                                          [self.imageProgressIndicator stopAnimation:self];
//                                                                          [self.imageProgressIndicator setHidden:YES];
//                                                                      }];
//        [downloadImageTask resume];
//        [self.imageProgressIndicator setHidden:NO];
//        [self.imageProgressIndicator startAnimation:self];
//    }
}

@end
