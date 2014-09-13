//
//  NSOutlineView+Additions.m
//  Tundra
//
//  Created by Christopher Fu on 9/13/14.
//  Copyright (c) 2014 Christopher Fu. All rights reserved.
//

#import "NSOutlineView+Additions.h"

@implementation NSOutlineView (Additions)

- (void)expandParentsOfItem:(id)item
{
    while (item != nil) {
        id parent = [self parentForItem: item];
        if (![self isExpandable: parent])
            break;
        if (![self isItemExpanded: parent])
            [self expandItem: parent];
        item = parent;
    }
}

- (void)selectItem:(id)item
{
    NSInteger itemIndex = [self rowForItem:item];
    if (itemIndex < 0) {
        [self expandParentsOfItem: item];
        itemIndex = [self rowForItem:item];
        if (itemIndex < 0)
            return;
    }
    [self selectRowIndexes: [NSIndexSet indexSetWithIndex:itemIndex] byExtendingSelection: NO];
}

@end
