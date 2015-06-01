//
//  HomeWindow.h
//  duplicateFiles
//
//  Created by tran nam on 5/12/15.
//  Copyright (c) 2015 Tran Nam. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DragScrollView : NSScrollView <NSDraggingDestination> {
}

@property (nonatomic, strong) NSMutableArray *arrayURL;
@property NSString *lblName;
@end
