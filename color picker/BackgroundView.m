//
//  BackgroundView.m
//  color picker
//
//  Created by tran nam on 5/20/15.
//  Copyright (c) 2015 Tran Nam. All rights reserved.
//

#import "BackgroundView.h"

@implementation BackgroundView

- (void)drawRect:(NSRect)dirtyRect {
    [[NSColor colorWithCalibratedRed:0.35f green:0.35f blue:0.35f alpha:1.00f] setFill];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
    // Drawing code here.
}

@end
