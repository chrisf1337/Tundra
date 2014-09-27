//
//  CDFManagingViewController.m
//  Tundra
//
//  Created by Christopher Fu on 9/13/14.
//  Copyright (c) 2014 Christopher Fu. All rights reserved.
//

/*
 * The parent class of all Tundra view controllers. This is an abstract class
 * that is never directly instantiated. CDFManagingViewControllers contain
 * references to the managed object model for Core Data object access as well as
 * a pointer to the CDFMainWindowController that can be used, for example, to
 * notify the main window controller to show the series search sheet when the
 * user clicks the add button in the CDFListView. Managing View Controllers also
 * contain a property and a method to facilitate the sending of url requests.
 */

#import "CDFManagingViewController.h"
#import "apikeys.h"

@interface CDFManagingViewController ()

@end

@implementation CDFManagingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.HTTPAdditionalHeaders = @{@"User-Agent":MAL_USER_AGENT};
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    return self;
}

@end
