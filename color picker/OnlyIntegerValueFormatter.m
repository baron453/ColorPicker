//
//  OnlyIntegerValueFormatter.m
//  Memory Cleaner
//
//  Created by Duc Nguyen on 4/20/15.
//  Copyright (c) 2015 do. All rights reserved.
//

#import "OnlyIntegerValueFormatter.h"

@implementation OnlyIntegerValueFormatter

- (BOOL)isPartialStringValid:(NSString*)partialString newEditingString:(NSString**)newString errorDescription:(NSString**)error
{
    if([partialString length] == 0) {
        return YES;
    }
    
    NSScanner* scanner = [NSScanner scannerWithString:partialString];
    
    if(!([scanner scanInt:0] && [scanner isAtEnd])) {
        NSBeep();
        return NO;
    }
    
    return YES;
}

@end
