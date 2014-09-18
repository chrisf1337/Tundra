//
//  CDFTableView.m
//  Tundra
//
//  Created by Christopher Fu on 9/15/14.
//  Copyright (c) 2014 Christopher Fu. All rights reserved.
//

#import "CDFTableView.h"

@implementation CDFTableView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (BOOL)validateProposedFirstResponder:(NSResponder *)responder forEvent:(NSEvent *)event
{
    if ([responder isKindOfClass:[NSStepper class]])
    {
        return YES;
    }
    else
    {
        return [super validateProposedFirstResponder:responder forEvent:event];
    }
}

@end
