//
//  ButtonColorObject.m
//  color picker
//
//  Created by tran nam on 5/27/15.
//  Copyright (c) 2015 Tran Nam. All rights reserved.
//

#import "ButtonColorObject.h"

@implementation ButtonColorObject
- (id)initWithHexColor:(NSString *)hex tag:(NSInteger)tag{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.HexColor = hex;
    self.tag = tag;
    return self;
}
@end
