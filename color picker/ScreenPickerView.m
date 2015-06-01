/*
     File: ScreenPickerView.m
 
 */

#import "ScreenPickerView.h"

@implementation ScreenPickerView



- (void)drawRect:(NSRect)rect {
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    // Clear the drawing rect.
    CGContextClearRect(context, self.bounds);

    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;

    // mask
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, NULL, rect);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGPathRelease(path);
    if (_imageRef) {
        // draw image
        @try{
            CGContextSetRenderingIntent(context, kCGRenderingIntentRelativeColorimetric);
            CGContextDrawImage(context, NSRectToCGRect(self.bounds), _imageRef);
        }@catch(NSException *p){
            
        }
    }
    
    // draw the aperture
    CGFloat apertureSize = 4;
	CGFloat x = width / 2 - apertureSize / 2;
	CGFloat y = height / 2 - apertureSize / 2;
	CGRect apertureRect = CGRectMake(x, y, apertureSize, apertureSize);
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
    CGContextSetShouldAntialias(context, NO);
    CGContextStrokeRect(context, apertureRect);

    // stroke outer circle
    CGContextSetRGBStrokeColor(context, 0.392, 0.392, 0.392, 1);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetLineWidth(context, 5.0);
    CGContextStrokeEllipseInRect(context, rect);
    
}

@end
