//
//  HomeWindow.m
//  duplicateFiles
//
//  Created by tran nam on 5/12/15.
//  Copyright (c) 2015 Tran Nam. All rights reserved.
//

#import "DragScrollView.h"

@implementation DragScrollView

- (void)awakeFromNib{
    _arrayURL = [[NSMutableArray alloc] init];
    [self.window makeFirstResponder:self];
    [self.window acceptsMouseMovedEvents];
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSColorPboardType, nil]];
}
- (BOOL)mouseDownCanMoveWindow
{
    return YES;
}

-(NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
    
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
    
    if ( [[pboard types] containsObject:NSColorPboardType] ) {
        if (sourceDragMask & NSDragOperationGeneric) {
            [[self window] makeFirstResponder:self];
            return NSDragOperationGeneric;
        }
    }
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
        if (sourceDragMask & NSDragOperationLink) {
            return NSDragOperationLink;
        } else if (sourceDragMask & NSDragOperationCopy) {
            return NSDragOperationCopy;
        }
    }
    return NSDragOperationNone;
}
-(void)draggingExited:(id<NSDraggingInfo>)sender{
    //isDraw=NO;
    //[self animation];
    [[self window] makeFirstResponder:nil];
    [[NSCursor arrowCursor] push];
}
-(void)draggingEnded:(id<NSDraggingInfo>)sender{
    [[self window] makeFirstResponder:nil];
    [[NSCursor arrowCursor] push];
}
-(BOOL)performDragOperation:(id<NSDraggingInfo>)sender{
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
    
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
    
    if ( [[pboard types] containsObject:NSColorPboardType] ) {
        // Only a copy operation allowed so just copy the data
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddCurrentColor" object:nil];
    }
    return YES;
}

//- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
//    NSPasteboard *pboard = [sender draggingPasteboard];
//    if ([[pboard types] containsObject:NSURLPboardType]) {
//        NSArray *urls = [pboard readObjectsForClasses:@[[NSURL class]] options:nil];
//        NSLog(@"URLs are: %@", urls);
//    }
//    return YES;
//}
@end
