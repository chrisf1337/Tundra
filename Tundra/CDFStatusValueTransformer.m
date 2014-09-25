//
//  CDFStatusValueTransformer.m
//  Tundra
//
//  Created by Christopher Fu on 9/22/14.
//  Copyright (c) 2014 Christopher Fu. All rights reserved.
//

#import "CDFStatusValueTransformer.h"

@implementation CDFStatusValueTransformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

- (id)transformedValue:(id)value
{
    CDFSeriesStatus status = [value intValue];
    if (status == kSeriesStatusWatching)
    {
        return @"Currently Watching";
    }
    else if (status == kSeriesStatusCompleted)
    {
        return @"Completed";
    }
    else if (status == kSeriesStatusOnHold)
    {
        return @"On Hold";
    }
    else if (status == kSeriesStatusDropped)
    {
        return @"Dropped";
    }
    else if (status == kSeriesStatusPlanned)
    {
        return @"Plan to Watch";
    }
    else
    {
        return nil;
    }
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)reverseTransformedValue:(id)value
{
    if ([value isEqualToString:@"Currently Watching"])
    {
        return [NSNumber numberWithInt:kSeriesStatusWatching];
    }
    else if ([value isEqualToString:@"Completed"])
    {
        return [NSNumber numberWithInt:kSeriesStatusCompleted];
    }
    else if ([value isEqualToString:@"On Hold"])
    {
        return [NSNumber numberWithInt:kSeriesStatusOnHold];
    }
    else if ([value isEqualToString:@"Dropped"])
    {
        return [NSNumber numberWithInt:kSeriesStatusDropped];
    }
    else if ([value isEqualToString:@"Plan to Watch"])
    {
        return [NSNumber numberWithInt:kSeriesStatusPlanned];
    }
    else
    {
        return nil;
    }
}

@end
