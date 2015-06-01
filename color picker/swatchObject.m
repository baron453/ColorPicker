//
//  swatchObject.m
//  color picker
//
//  Created by tran nam on 5/26/15.
//  Copyright (c) 2015 Tran Nam. All rights reserved.
//

#import "swatchObject.h"

@implementation swatchObject

- (id)init{
    self = [super init];
    if (!self) {
        return nil;
    }
    return self;
}

- (NSString *)titleObject{
    NSString *string = @"";
    string = [_title stringByAppendingString:[NSString stringWithFormat:@" (%ld)",
                                              self.colorArray.count]];
    return string;
}

- (NSMutableArray *)categoriesColor{
    return self.colorArray;
}

- (void)setCategoriesColor:(NSMutableArray *)colorArray{
    self.colorArray = colorArray;
}

- (void)setTitleSwatch:(NSString *)title{
    self.title = title;
}
@end
