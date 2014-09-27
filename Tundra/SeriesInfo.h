//
//  SeriesInfo.h
//  Tundra
//
//  Created by Christopher Fu on 9/25/14.
//  Copyright (c) 2014 Christopher Fu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SeriesInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * episodesWatched;
@property (nonatomic, retain) NSNumber * idNumber;
@property (nonatomic, retain) NSNumber * lastUpdated;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * totalEpisodes;
@property (nonatomic, retain) NSString * imageUrl;

@end
