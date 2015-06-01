//
//  CateMainObject.m
//  color picker
//
//  Created by tran nam on 5/27/15.
//  Copyright (c) 2015 Tran Nam. All rights reserved.
//

#import "CateMainObject.h"

@implementation CateMainObject
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.cateArray = [decoder decodeObjectForKey:@"cateArray"];
    return self;
}

- (NSMutableArray *)categoriesArray{
    return self.cateArray;
}

- (void)setCategoriesArray:(NSMutableArray *)cateArray{
    self.cateArray = cateArray;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.cateArray forKey:@"cateArray"];
}
@end
