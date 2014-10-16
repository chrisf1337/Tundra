//
//  SeriesInfo.m
//  Tundra
//
//  Created by Christopher Fu on 10/3/14.
//  Copyright (c) 2014 Christopher Fu. All rights reserved.
//

#import "SeriesInfo.h"


@implementation SeriesInfo

@dynamic endDate;
@dynamic episodesWatched;
@dynamic idNumber;
@dynamic imageUrl;
@dynamic lastUpdated;
@dynamic name;
@dynamic startDate;
@dynamic status;
@dynamic totalEpisodes;
@dynamic score;

- (void)initSeriesInfoUsingValues:(NSDictionary *)series
{
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    nf.numberStyle = NSNumberFormatterDecimalStyle;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    self.name = [series objectForKey:@"series_title"];
    self.episodesWatched = [nf numberFromString:[series objectForKey:@"my_watched_episodes"]];
    self.totalEpisodes = [nf numberFromString:[series objectForKey:@"series_episodes"]];
    self.status = [nf numberFromString:[series objectForKey:@"my_status"]];
    self.idNumber = [nf numberFromString:[series objectForKey:@"series_animedb_id"]];
    self.lastUpdated = [nf numberFromString:[series objectForKey:@"my_last_updated"]];
    self.startDate = [dateFormatter dateFromString:[series objectForKey:@"my_start_date"]];
    self.endDate = [dateFormatter dateFromString:[series objectForKey:@"my_finish_date"]];
    self.score = [nf numberFromString:[series objectForKey:@"my_score"]];
    self.imageUrl = [series objectForKey:@"series_image"];
}

- (BOOL)isEqualToMALSeries:(NSDictionary *)series;
{
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    nf.numberStyle = NSNumberFormatterDecimalStyle;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
//    
//    if (![self.name isEqualToString:[series objectForKey:@"series_title"]]) NSLog(@"name");
//    if (![self.episodesWatched isEqualToNumber:[nf numberFromString:[series objectForKey:@"my_watched_episodes"]]]) NSLog(@"episodesWatched");
//    if (![self.totalEpisodes isEqualToNumber:[nf numberFromString:[series objectForKey:@"series_episodes"]]]) NSLog(@"totalEpisodes");
//    if (![self.status isEqualToNumber:[nf numberFromString:[series objectForKey:@"my_status"]]]) NSLog(@"status");
//    if (![self.idNumber isEqualToNumber:[nf numberFromString:[series objectForKey:@"series_animedb_id"]]]) NSLog(@"idNumber");
//    if (![self.lastUpdated isEqualToNumber:[nf numberFromString:[series objectForKey:@"my_last_updated"]]]) NSLog(@"lastUpdated");
//    
//    if (![self.startDate isEqualToDate:[dateFormatter dateFromString:[series objectForKey:@"my_start_date"]]])
//    {
//        NSLog(@"startDate");
//        NSLog(@"%@ %@", self.startDate, [dateFormatter dateFromString:[series objectForKey:@"my_start_date"]]);
//    }
//    if (![self.endDate isEqualToDate:[dateFormatter dateFromString:[series objectForKey:@"my_finish_date"]]])
//    {
//        NSLog(@"endDate");
//        NSLog(@"%@ %@", self.endDate, [dateFormatter dateFromString:[series objectForKey:@"my_finish_date"]]);
//    }
//
//    if (![self.score isEqualToNumber:[nf numberFromString:[series objectForKey:@"my_score"]]]) NSLog(@"score");
//    if (![self.imageUrl isEqualToString:[series objectForKey:@"series_image"]]) NSLog(@"imageUrl");

    return [self.name isEqualToString:[series objectForKey:@"series_title"]] &&
    [self.episodesWatched isEqualToNumber:[nf numberFromString:[series objectForKey:@"my_watched_episodes"]]] &&
    [self.totalEpisodes isEqualToNumber:[nf numberFromString:[series objectForKey:@"series_episodes"]]] &&
    [self.status isEqualToNumber:[nf numberFromString:[series objectForKey:@"my_status"]]] &&
    [self.idNumber isEqualToNumber:[nf numberFromString:[series objectForKey:@"series_animedb_id"]]] &&
    [self.lastUpdated isEqualToNumber:[nf numberFromString:[series objectForKey:@"my_last_updated"]]] &&
    ((self.startDate == nil && [dateFormatter dateFromString:[series objectForKey:@"my_start_date"]] == nil) || [self.startDate isEqualToDate:[dateFormatter dateFromString:[series objectForKey:@"my_start_date"]]]) &&
    ((self.endDate == nil && [dateFormatter dateFromString:[series objectForKey:@"my_finish_date"]] == nil) || [self.endDate isEqualToDate:[dateFormatter dateFromString:[series objectForKey:@"my_finish_date"]]]) &&
    [self.score isEqualToNumber:[nf numberFromString:[series objectForKey:@"my_score"]]] &&
    [self.imageUrl isEqualToString:[series objectForKey:@"series_image"]];
}

@end
