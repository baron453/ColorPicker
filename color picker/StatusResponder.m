//
//  StatusResponder.m
//  Memory Cleaner
//
//  Created by tran nam on 5/8/15.
//  Copyright (c) 2015 do. All rights reserved.
//

#import "StatusResponder.h"

@implementation StatusResponder
- (void)mouseDown:(NSEvent *)event
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LeftClickButtonStatusItem" object:nil];}
- (void)rightMouseDown:(NSEvent *)event{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RightClickButtonStatusItem" object:nil];}
@end
