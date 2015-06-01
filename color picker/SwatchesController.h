//
//  SwatchesController.h
//  color picker
//
//  Created by tran nam on 5/27/15.
//  Copyright (c) 2015 Tran Nam. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"
@interface SwatchesController : NSObject <NSTableViewDataSource, NSTableViewDelegate>
@property AppDelegate *delegate;
@property (nonatomic, strong) NSMutableArray *swatchesArray;
@property (weak) IBOutlet NSButton *removeSwatchesButton;
@property (weak) IBOutlet NSButton *addSwatchesButton;

@end
