//
//  CDFPreferencesViewController.m
//  Tundra
//
//  Created by Christopher Fu on 10/7/14.
//  Copyright (c) 2014 Christopher Fu. All rights reserved.
//

#import "CDFPreferencesViewController.h"
#import "CDFMainWindowController.h"
#import <SSKeychain/SSKeychain.h>

@interface CDFPreferencesViewController ()

@end

@implementation CDFPreferencesViewController

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
    self = [super initWithNibName:@"CDFPreferencesView" bundle:nil];
    if (self)
    {

    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.usernameField.stringValue = @"optikol";
    self.passwordField.stringValue = [SSKeychain passwordForService:@"Tundra MAL" account:@"optikol"];
}

@end
