//
//  NSOutlineView+Additions.h
//  Tundra
//
//  Created by Christopher Fu on 9/13/14.
//  Copyright (c) 2014 Christopher Fu. All rights reserved.
//

/*
 * A collection of methods to make selecting and expanding NSOutlineView
 * elements easier.
 */

#import <Cocoa/Cocoa.h>

@interface NSOutlineView (Additions)

- (void)expandParentsOfItem:(id)item;
- (void)selectItem:(id)item;

@end
