//
//  RadiusColorWell.m
//  color picker
//
//  Created by tran nam on 5/20/15.
//  Copyright (c) 2015 Tran Nam. All rights reserved.
//

#import "RadiusColorWell.h"

@implementation RadiusColorWell

- (void)drawRect:(NSRect)dirtyRect
{
    NSPoint origin = { 0.0,0.0 };
    NSRect rect;
    rect.origin = origin;
    rect.size.width  = [self bounds].size.width;
    rect.size.height = [self bounds].size.height;
    
    NSBezierPath * path;
    path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:5 yRadius:5];
    [path setLineWidth:2];
//    [[NSColor colorWithCalibratedWhite:1.0 alpha:0.394] set];
//    [path fill];
//    [[NSColor grayColor] set];
//    [path stroke];
    
//    if (([[self window] firstResponder] == [self currentEditor]) && [NSApp isActive])
//    {
//        [NSGraphicsContext saveGraphicsState];
//        NSSetFocusRingStyle(NSFocusRingOnly);
//        [path fill];
//        [NSGraphicsContext restoreGraphicsState];
//    }
//    else
//    {
//        [[self attributedStringValue] drawInRect:rect];
//    }
}

@end
