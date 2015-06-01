//
//  swatchObject.h
//  color picker
//
//  Created by tran nam on 5/26/15.
//  Copyright (c) 2015 Tran Nam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface swatchObject : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableArray *colorArray;

- (NSString *)titleObject;
- (NSMutableArray *)categoriesColor;
- (void)setCategoriesColor:(NSMutableArray *)colorArray;
- (void)setTitleSwatch:(NSString *)title;
@end
