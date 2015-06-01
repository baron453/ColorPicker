//
//  CustomView.m
//  color picker
//
//  Created by tran nam on 5/22/15.
//  Copyright (c) 2015 Tran Nam. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

- (void)drawRect:(NSRect)dirtyRect {
    [[NSColor colorWithCalibratedRed:0.318f green:0.318f blue:0.318f alpha:1.00f] setFill];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
    // Drawing code here.
}

- (BOOL)isFlipped {
    return YES;
}

@end
