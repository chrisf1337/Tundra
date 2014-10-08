//
//  CDFPreferencesViewController.h
//  Tundra
//
//  Created by Christopher Fu on 10/7/14.
//  Copyright (c) 2014 Christopher Fu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CDFManagingViewController.h"

@class CDFMainWindowController;

@interface CDFPreferencesViewController : NSViewController <NSControlTextEditingDelegate>

@property (nonatomic, weak) CDFMainWindowController *mainWindowController;

@property (weak) IBOutlet NSTextField *usernameField;
@property (weak) IBOutlet NSTextField *passwordField;

@end
