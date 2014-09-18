//
//  CDFSeriesSearchViewController.m
//  Tundra
//
//  Created by Christopher Fu on 9/13/14.
//  Copyright (c) 2014 Christopher Fu. All rights reserved.
//

#import "CDFSeriesSearchViewController.h"

@interface CDFSeriesSearchViewController ()

@end

@implementation CDFSeriesSearchViewController

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
    self = [super initWithNibName:@"CDFSeriesSearchView" bundle:nil];
    if (self)
    {
        self.title = @"Series Search View";
        self.num = [NSNumber numberWithInt:0];
    }
    return self;
}

@end
