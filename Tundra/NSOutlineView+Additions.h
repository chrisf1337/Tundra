//
//  NSOutlineView+Additions.h
//  Tundra
//
//  Created by Christopher Fu on 9/13/14.
//  Copyright (c) 2014 Christopher Fu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSOutlineView (Additions)

- (void)expandParentsOfItem:(id)item;
- (void)selectItem:(id)item;

@end
