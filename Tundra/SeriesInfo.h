//
//  SeriesInfo.h
//  Tundra
//
//  Created by Christopher Fu on 10/3/14.
//  Copyright (c) 2014 Christopher Fu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SeriesInfo : NSManagedObject

@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * episodesWatched;
@property (nonatomic, retain) NSNumber * idNumber;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSNumber * lastUpdated;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * totalEpisodes;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSArray * synonyms;

- (void)initSeriesInfoUsingValues:(NSDictionary *)series;
- (BOOL)isEqualToMALSeries:(NSDictionary *)series;

@end
