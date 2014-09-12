//
//  SeriesInfo.h
//  Tundra
//
//  Created by Christopher Fu on 9/8/14.
//  Copyright (c) 2014 Christopher Fu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SeriesInfo : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * episodesWatched;

@end
