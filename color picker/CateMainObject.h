//
//  CateMainObject.h
//  color picker
//
//  Created by tran nam on 5/27/15.
//  Copyright (c) 2015 Tran Nam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CateMainObject : NSObject <NSCoding>
@property (nonatomic, strong) NSMutableArray *cateArray;

- (void)setCategoriesArray:(NSMutableArray *)cateArray;
- (NSMutableArray *)categoriesArray;
@end
