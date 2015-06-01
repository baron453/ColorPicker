//
//  ScreenWindow.m
//  ScreenPicker
//
//  Created by durian on 3/26/13.
//  Copyright (c) 2013 durian. All rights reserved.
//

#import "ScreenPickerWindow.h"
#import "ScreenPickerView.h"
#import "NSColor+hex.h"
@implementation ScreenPickerWindow
    NSColor *color;
    BOOL isHexColoValue;
    NSTextField *tex;
- (void)dealloc {
    if (imageRef) {
        CGImageRelease(imageRef);
        imageRef = NULL;
    }
}

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)windowStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)deferCreation
{
    self = [super initWithContentRect:contentRect styleMask:windowStyle backing:bufferingType defer:deferCreation];
    if (self) {
        [self setOpaque:NO];
        [self setBackgroundColor:[NSColor clearColor]];
        [self setLevel:NSPopUpMenuWindowLevel];
        [self setIgnoresMouseEvents:NO];
        
        NSString *displayFormat = [[NSUserDefaults standardUserDefaults] objectForKey:@"DisplayedFormat"];
        isHexColoValue = [displayFormat integerValue];
        if(isHexColoValue)
            tex = [[NSTextField alloc] initWithFrame:NSMakeRect(35, 30, 60, 15)];
        else
            tex = [[NSTextField alloc] initWithFrame:NSMakeRect(25, 30, 80, 15)];
        [tex setAlignment:NSCenterTextAlignment];
        [tex setBordered:NO];
        [tex setBackgroundColor:[NSColor whiteColor]];
        [tex setWantsLayer:YES];
        tex.layer.cornerRadius = 15/2;
        [tex setAlphaValue:0.8];
        
        NSPoint point = [NSEvent mouseLocation];
        CGFloat captureSize = self.frame.size.width / 7;
        NSRect screenFrame = [[NSScreen deepestScreen] frame];
        CGFloat x = floor(point.x) - floor(captureSize / 2);
        CGFloat y = screenFrame.size.height - floor(point.y) - floor(captureSize / 2);
        
        CGWindowID windowID = (CGWindowID)[self windowNumber];
        
        imageRef = CGWindowListCreateImage(CGRectMake(x, y, captureSize, captureSize), kCGWindowListOptionOnScreenBelowWindow, windowID, kCGWindowImageNominalResolution);
        
        ScreenPickerView *captureView = [[ScreenPickerView alloc] initWithFrame:self.frame];
        [captureView setImageRef:imageRef];
        [self setContentView:captureView];
    }
    return self;
}

- (void)mouseMoved:(NSEvent *)event
{
    NSPoint point = [NSEvent mouseLocation];

    uint32_t count = 0;
    CGDirectDisplayID display;
    if (CGGetDisplaysWithPoint(NSPointToCGPoint(point), 1, &display, &count) != kCGErrorSuccess)
    {
        return;
    }
    
    CGFloat captureSize = self.frame.size.width / 7;
    NSRect screenFrame = [[NSScreen deepestScreen] frame];
    CGFloat x = floor(point.x) - floor(captureSize / 2);
    CGFloat y = screenFrame.size.height - floor(point.y) - floor(captureSize / 2);
    
    CGWindowID windowID = (CGWindowID)[self windowNumber];
    
    if (imageRef) {
        CGImageRelease(imageRef);
        imageRef = nil;
    }
    imageRef = CGWindowListCreateImage(CGRectMake(x, y, captureSize, captureSize), kCGWindowListOptionOnScreenBelowWindow, windowID, kCGWindowImageNominalResolution);
        
//    NSImage *image = [[NSImage alloc] initWithCGImage:imageRef size:NSZeroSize];
    
    if (imageRef == nil) {
        return;
    }
    
//    if ([_delegate respondsToSelector:@selector(window:moveToPoint:withImage:)]) {
//        [_delegate window:self moveToPoint:point withImage:image];
//    }
    if (NSPointInRect(point,[self frame])) {
        NSBitmapImageRep *bitmapImageRep = [[NSBitmapImageRep alloc] initWithCGImage:imageRef];
        CGFloat centerX = bitmapImageRep.size.width / 2;
        CGFloat centerY = bitmapImageRep.size.height / 2;
        color = [bitmapImageRep colorAtX:centerX y:centerY];
    }
    [self setFrameOrigin:NSMakePoint(floor(point.x) - floor(self.frame.size.width / 2), floor(point.y) - floor(self.frame.size.height / 2))];
    
    ScreenPickerView *captureView = (ScreenPickerView *)self.contentView;
    [captureView setImageRef:imageRef];
    if(isHexColoValue)
        [tex setStringValue:[color hexadecimalValue]];
    else
        [tex setStringValue:[NSString stringWithFormat:@"%@,%@,%@",
                             [color redValue],
                             [color greenValue],
                             [color blueValue]]];
    [captureView addSubview:tex];
    [captureView setNeedsDisplay:YES];
    [super mouseMoved:event];
}

- (void)mouseDown:(NSEvent *)theEvent {
    NSPoint p = [NSEvent mouseLocation];
    NSRect f = [self frame];
    if (NSPointInRect(p, f)) {
        [self orderOut:self];
        
        if ([_delegate respondsToSelector:@selector(getMouseWithColor:)]) {
//            NSBitmapImageRep *bitmapImageRep = [[NSBitmapImageRep alloc] initWithCGImage:imageRef];
//            CGFloat centerX = bitmapImageRep.size.width / 2;
//            CGFloat centerY = bitmapImageRep.size.height / 2;            
//            NSColor *color = [bitmapImageRep colorAtX:centerX y:centerY];
//
//            NSLog(@"selected color:%@", color);
            [_delegate getMouseWithColor:color];
        }
    }
}


- (BOOL)canBecomeKeyWindow {
    NSPoint point = [NSEvent mouseLocation];
    [self setFrameOrigin:NSMakePoint(floor(point.x) - floor(self.frame.size.width / 2), floor(point.y) - floor(self.frame.size.height / 2))];
    return YES;
}

@end
