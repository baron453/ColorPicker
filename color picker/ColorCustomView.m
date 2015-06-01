//
//  ColorCustomView.m
//  color picker
//
//  Created by tran nam on 5/22/15.
//  Copyright (c) 2015 Tran Nam. All rights reserved.
//

#import "ColorCustomView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSColor+hex.h"
@implementation ColorCustomView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

//- (void)mouseDown:(NSEvent *)theEvent{
//    NSString *hexColor =[colors hexadecimalValue];
//    [[NSUserDefaults standardUserDefaults] setValue:hexColor forKey:@"CurrentColor"];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"GetCurrentColor" object:nil];
//}
@end
