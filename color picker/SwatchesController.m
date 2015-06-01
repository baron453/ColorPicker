//
//  SwatchesController.m
//  color picker
//
//  Created by tran nam on 5/27/15.
//  Copyright (c) 2015 Tran Nam. All rights reserved.
//

#import "SwatchesController.h"
#import "AppDelegate.h"
#import "swatchObject.h"
@implementation SwatchesController

- (NSMutableArray *)swatchesArray {
    //if(!_swatchesArray){
        _delegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
     //   _swatchesArray = delegate.categoriesArray;
    //}
    return _delegate.categoriesArray;
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    // how many rows do we have here?
    return self.swatchesArray.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    // populate each row of our table view with data
    // display a different value depending on each column (as identified in XIB)
    
    //if ([tableColumn.identifier isEqualToString:@"SwatchesColumn"]) {
        // first colum (numbers)
        swatchObject * swatchObject =[self.swatchesArray objectAtIndex:row];
        NSString *tittle = [swatchObject titleObject];
        NSLog(@"%@",tittle);
        return tittle;
    //}
//return nil;
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    if(rowIndex==0){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ShowRenameAlert" object:nil];
    }else{
        // The column identifier string is the easiest way to identify a table column.
        NSString *columnIdentifer = [aTableColumn identifier];
        if ([columnIdentifer isEqualToString:@"SwatchesColumn"]) {
            swatchObject * swatchObject =[self.swatchesArray objectAtIndex:rowIndex];
            [swatchObject setTitle:anObject];
            [_delegate.categoriesArray replaceObjectAtIndex:rowIndex withObject:swatchObject];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateSwatchesMenu" object:nil];
        }
    }
    
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    
    NSTableView *tableView = notification.object;
    if (tableView.selectedRow==0){
        [_removeSwatchesButton setEnabled:NO];
    }else{
        [_removeSwatchesButton setEnabled:YES];
    }
}

@end
