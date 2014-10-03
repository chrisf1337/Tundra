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
}

@end
