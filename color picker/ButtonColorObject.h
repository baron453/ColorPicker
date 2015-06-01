//
//  ButtonColorObject.h
//  color picker
//
//  Created by tran nam on 5/27/15.
//  Copyright (c) 2015 Tran Nam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ButtonColorObject : NSObject
@property (assign) NSInteger tag;
@property (strong) NSString *HexColor;
- (id)initWithHexColor:(NSString *)hex tag:(NSInteger)tag;
@end
