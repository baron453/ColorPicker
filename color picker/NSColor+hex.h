//
//  NSColor+hex.h
//  color picker
//
//  Created by tran nam on 5/20/15.
//  Copyright (c) 2015 Tran Nam. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (Hex)

- (NSString *)hexadecimalValue;
-  (NSString *)redValue;
-  (NSString *)greenValue;
-  (NSString *)blueValue;
-  (NSString *)redFloatValue;
-  (NSString *)greenFloatValue;
-  (NSString *)blueFloatValue;
+ (NSColor *)colorFromHexadecimalValue:(NSString *)hex;
+ (NSColor *) colorFromIntRed:(NSInteger)redIntValue intGreen:(NSInteger)greenIntValue intBlue:(NSInteger)blueIntValue;
@end
