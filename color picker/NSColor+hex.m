//
//  NSColor+hex.m
//  color picker
//
//  Created by tran nam on 5/20/15.
//  Copyright (c) 2015 Tran Nam. All rights reserved.
//

#import "NSColor+hex.h"

@implementation NSColor (Hex)

- (NSString *)hexadecimalValue {
    return [self getColorValue:0];
}

- (NSString *)redValue {
    return [self getColorValue:1];
}

- (NSString *)greenValue {
    return [self getColorValue:2];
}

- (NSString *)blueValue {
    return [self getColorValue:3];
}

-  (NSString *)redFloatValue{
    return [self getColorValue:4];
}

-  (NSString *)greenFloatValue{
    return [self getColorValue:5];
}

-  (NSString *)blueFloatValue{
    return [self getColorValue:6];
}
+ (NSColor *)colorFromHexadecimalValue:(NSString *)hex {
    
    if ([hex hasPrefix:@"#"]) {
        hex = [hex substringWithRange:NSMakeRange(1, [hex length] - 1)];
    }
    
    NSColor* color = nil;
    unsigned int colorCode = 0;
    unsigned char red, green, blue;
    
    if (hex) {
        NSScanner *scanner = [NSScanner scannerWithString:hex];
        (void)[scanner scanHexInt:&colorCode];
    }
    red = (unsigned char) (colorCode >> 16);
    green = (unsigned char) (colorCode >> 8);
    blue = (unsigned char) (colorCode);
    color = [NSColor colorWithCalibratedRed:(float)red / 0xff green:(float)green / 0xff blue:(float)blue / 0xff alpha:1.0];
    return color;
}

+ (NSColor *) colorFromIntRed:(NSInteger)redIntValue intGreen:(NSInteger)greenIntValue intBlue:(NSInteger)blueIntValue{
    if(!redIntValue)
        redIntValue=0;
    if(!greenIntValue)
        greenIntValue=0;
    if(!blueIntValue)
        blueIntValue=0;
    NSColor* color = nil;
    color = [NSColor colorWithCalibratedRed:(float)redIntValue / 0xff green:(float)greenIntValue / 0xff blue:(float)blueIntValue / 0xff alpha:1.0];
    return color;
}

- (NSString *)getColorValue:(int)tag{
    double redFloatValue, greenFloatValue, blueFloatValue;
    int redIntValue, greenIntValue, blueIntValue;
    NSString *redHexValue, *greenHexValue, *blueHexValue;
    
    NSColor *convertedColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    
    if(convertedColor) {
        [convertedColor getRed:&redFloatValue green:&greenFloatValue blue:&blueFloatValue alpha:NULL];
        
        redIntValue = redFloatValue*255.0f;
        greenIntValue = greenFloatValue*255.0f;
        blueIntValue = blueFloatValue*255.0f;
        
        redHexValue = [[NSString stringWithFormat:@"%02x", redIntValue] uppercaseString];
        greenHexValue = [[NSString stringWithFormat:@"%02x", greenIntValue] uppercaseString];
        blueHexValue = [[NSString stringWithFormat:@"%02x", blueIntValue] uppercaseString];
        switch (tag) {
            case 0:
                return [NSString stringWithFormat:@"%@%@%@", redHexValue , greenHexValue, blueHexValue];
                break;
            case 1:
                return [NSString stringWithFormat:@"%d", redIntValue];
                break;
            case 2:
                return [NSString stringWithFormat:@"%d", greenIntValue];
                break;
            case 3:
                return [NSString stringWithFormat:@"%d", blueIntValue];
                break;
            case 4:
                return [NSString stringWithFormat:@"%.3f", redFloatValue];
                break;
            case 5:
                return [NSString stringWithFormat:@"%.3f", greenFloatValue];
                break;
            case 6:
                return [NSString stringWithFormat:@"%.3f", blueFloatValue];
                break;
            default:
                return nil;
                break;
        }
        
    }
    
    return nil;
}
@end
