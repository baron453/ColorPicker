//
//  PreferenceController.m
//  color picker
//
//  Created by tran nam on 5/21/15.
//  Copyright (c) 2015 Tran Nam. All rights reserved.
//

#import "PreferenceController.h"
#import "swatchObject.h"
#import "AppDelegate.h"
#import "Shortcut.h"
static NSString *const MASCustomShortcutKeyColorPicker = @"customShortcutColorPicker";
static NSString *const MASCustomShortcutKeyMagnifier = @"customShortcutMagnifier";

static void *MASObservingContext = &MASObservingContext;

@import AppKit;
@interface PreferenceController ()
@property(strong) IBOutlet MASShortcutView *shortcutShowColorPicker;
@property(strong) IBOutlet MASShortcutView *shortcutShowMagnifier;
@end

@implementation PreferenceController{
    CGFloat originYPreference;
    CGFloat originXPreference;
    AppDelegate *delegate;
}

- (void)windowDidLoad {
    
    [super windowDidLoad];
    delegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    [self.window.toolbar setSelectedItemIdentifier:@"General"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ShowRenameAlert)
                                                 name:@"ShowRenameAlert"
                                               object:nil];
    [self toolbarGeneral:self];
    [self loadGeneral];
    [self loadSwatches];
    [self loadFormat];
    [self loadAdvanced];
    [self createShortcut];
}


- (IBAction)toolbarGeneral:(id)sender {
    [self setTargetPointToShow];
    //NSLog(@"width %f , height %f",_generalView.frame.size.width, _generalView.frame.size.height);
    [self resizeWindowWithContentSize:CGSizeMake(376,194) animated:YES];
    [self.window setContentView:_generalView];
}

- (IBAction)toolbarAdvance:(id)sender {
    [self setTargetPointToShow];
    //NSLog(@"width %f , height %f",_avancedView.frame.size.width, _avancedView.frame.size.height);
    [self resizeWindowWithContentSize:CGSizeMake(376,100) animated:YES];
    [self.window setContentView:_avancedView];
}

- (IBAction)toolbarFormat:(id)sender {
    [self setTargetPointToShow];
    //NSLog(@"width %f , height %f",_formatView.frame.size.width, _formatView.frame.size.height);
    [self resizeWindowWithContentSize:CGSizeMake(376,250) animated:YES];
    [self.window setContentView:_formatView];
}

- (IBAction)toolbarSwatches:(id)sender {
    [self setTargetPointToShow];
    //NSLog(@"width %f , height %f",_swatchesView.frame.size.width, _swatchesView.frame.size.height);
    [self resizeWindowWithContentSize:CGSizeMake(376,200) animated:YES];
    [self.window setContentView:_swatchesView];
    
}

- (void) resizeWindowWithContentSize:(NSSize)contentSize animated:(BOOL)animated {
    //NSLog(@"width %f , height %f",_swatchesView.frame.size.width, _swatchesView.frame.size.height);
    CGFloat titleBarHeight = self.window.frame.size.height - ((NSView*)self.window.contentView).frame.size.height;
    CGSize windowSize = CGSizeMake(contentSize.width, contentSize.height + titleBarHeight);
    
//    // Optional: keep it centered
//    float originX ;
    float originY;
//    
    float halfy = originYPreference + 394;
    float halfy2 = halfy - windowSize.height/2;
//    originX = originXPreference + 376/2 - windowSize.width/ 2;
    originY = halfy2;
    
    NSRect windowFrame = CGRectMake(self.window.frame.origin.x, originY, windowSize.width, windowSize.height);
    [self.window setFrame:windowFrame display:YES animate:animated];
}


-(void) setTargetPointToShow {
    if (originYPreference <= 0){
        originYPreference =  [NSWindow contentRectForFrameRect:self.window.frame styleMask: self.window.styleMask].origin.y;
        originXPreference =  [NSWindow contentRectForFrameRect:self.window.frame styleMask: self.window.styleMask].origin.x;
    }
}

- (void)loadGeneral{
    NSString *general = [[NSUserDefaults standardUserDefaults] objectForKey:@"ShowAppIcon"];
    [_showAppIconPopUp selectItemAtIndex:[general integerValue]];
}

- (void)loadSwatches{
    //_swatchesArray = delegate.categoriesArray;
}

- (void)updateSwatchesMenu{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateSwatchesMenu" object:nil];
}

- (void)loadFormat{
    NSString *sourceCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"SourceCode"];
    [_sourceCodePopup selectItemAtIndex:[sourceCode integerValue]];
    if([sourceCode integerValue]==1){
       [_appendsemiCheckbox setEnabled:NO];
        
    }else{
        NSString *appendSemiColon = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppendSemicolon"];
        [_appendsemiCheckbox setState:[appendSemiColon integerValue]];
    }
    NSString *zeroSuppression = [[NSUserDefaults standardUserDefaults] objectForKey:@"ZeroSupppression"];
    [_zeroSuppresCheckbox setState:[zeroSuppression integerValue]];
    NSString *displayFormat = [[NSUserDefaults standardUserDefaults] objectForKey:@"DisplayedFormat"];
    [_displayFormatPopUp selectItemAtIndex:[displayFormat integerValue]];
}

- (void)loadAdvanced{
    NSString *hideWindow = [[NSUserDefaults standardUserDefaults] objectForKey:@"HideWindowWhileUsingMagnifier"];
    [_hideWindowCheckbox setState:[hideWindow integerValue]];
    NSString *showWindow = [[NSUserDefaults standardUserDefaults] objectForKey:@"ShowWindowAfterSelectedColor"];
    [_showWindowCheckbox setState:[showWindow integerValue]];
}
- (IBAction)showAppIcon:(id)sender {
    NSPopUpButton *button = (NSPopUpButton *) sender;
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",button.indexOfSelectedItem] forKey:@"ShowAppIcon"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showAppIcon" object:nil];
}

- (IBAction)hideWindowOnMagnifier:(id)sender {
    NSPopUpButton *button = (NSPopUpButton *) sender;
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",button.state] forKey:@"HideWindowWhileUsingMagnifier"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePreference" object:nil];
}

- (IBAction)showWindowAfterMagnifier:(id)sender {
    NSPopUpButton *button = (NSPopUpButton *) sender;
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",button.state] forKey:@"ShowWindowAfterSelectedColor"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePreference" object:nil];
}

- (IBAction)addSwatches:(id)sender {
    [self.tableSwatches beginUpdates];
    swatchObject *newSwatches = [[swatchObject alloc] init];
    [newSwatches setTitleSwatch:@"New Swatches"];
    [newSwatches setCategoriesColor:[NSMutableArray arrayWithObjects:nil]];
    [delegate.categoriesArray addObject:newSwatches];
    NSInteger newRowIndex = delegate.categoriesArray.count-1;
    //NSLog(@"%ld",newRowIndex);
    [self.tableSwatches insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:newRowIndex] withAnimation:NSTableViewAnimationEffectGap];
    [self.tableSwatches endUpdates];
    [self.tableSwatches selectRowIndexes:[NSIndexSet indexSetWithIndex:newRowIndex] byExtendingSelection:NO];
    [self.tableSwatches scrollRowToVisible:newRowIndex];
    [self updateSwatchesMenu];
}

- (IBAction)removeSwatches:(id)sender {
    NSAlert *alert = [[NSAlert alloc] init];
    
    [alert addButtonWithTitle:@"Remove"];
    [alert addButtonWithTitle:@"Cancel"];
    swatchObject *swatchOb = [self selectedSwatchDoc];
    [alert setMessageText:[NSString stringWithFormat:@"Are you sure you want to remove \"%@\"?",[swatchOb title]]];
    [alert setInformativeText:@"You will not be able to undo this action."];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert beginSheetModalForWindow:[self window] completionHandler:^(NSInteger returnCode){
        if (returnCode == NSAlertFirstButtonReturn) {
            swatchObject *selectedSwatches = [self selectedSwatchDoc];
            if(selectedSwatches){
                
                [self.tableSwatches beginUpdates];
                [delegate.categoriesArray removeObject:selectedSwatches];
                [self.tableSwatches removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:self.tableSwatches.selectedRow] withAnimation:NSTableViewAnimationSlideRight];
                [self.tableSwatches endUpdates];
            }
            [self updateSwatchesMenu];
        }

    }];
}

- (swatchObject *)selectedSwatchDoc{
    NSInteger selectedRow = [self.tableSwatches selectedRow];
    if(selectedRow >=0 && delegate.categoriesArray.count > selectedRow){
        swatchObject *selectedSwatch = [delegate.categoriesArray objectAtIndex:selectedRow];
        return selectedSwatch;
    }
    return nil;
}

#pragma mark - Table View Delegate

- (IBAction)showSourceCode:(id)sender {
    NSPopUpButton *button = (NSPopUpButton *) sender;
    if(button.indexOfSelectedItem==1)
       [_appendsemiCheckbox setEnabled:NO];
    else
        [_appendsemiCheckbox setEnabled:YES];
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",button.indexOfSelectedItem] forKey:@"SourceCode"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePreference" object:nil];
}

- (IBAction)showDisplayedFormat:(id)sender {
    NSPopUpButton *button = (NSPopUpButton *) sender;
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",button.indexOfSelectedItem] forKey:@"DisplayedFormat"];
    [delegate updateStatusMenu];
    [delegate updateFormatCopiedStatusMenu];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePreference" object:nil];
}

- (IBAction)enableZeroSupperssion:(id)sender {
    NSPopUpButton *button = (NSPopUpButton *) sender;
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",button.state] forKey:@"ZeroSupppression"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePreference" object:nil];
}

- (IBAction)appendSemiColon:(id)sender {
    NSPopUpButton *button = (NSPopUpButton *) sender;
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",button.state] forKey:@"AppendSemicolon"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePreference" object:nil];
}

//- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
//    // Get a new ViewCell
//    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
//    
//    // Since this is a single-column table view, this would not be necessary.
//    // But it's a good practice to do it in order by remember it when a table is multicolumn.
//    if( [tableColumn.identifier isEqualToString:@"SwatchesColumn"] )
//    {
//        swatchObject *swatchesDoc = [delegate.categoriesArray objectAtIndex:row];
//        cellView.textField.stringValue = [swatchesDoc title];
//        return cellView;
//    }
//    return cellView;
//}
//
//- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
//    return [delegate.categoriesArray count];
//}

- (void)createShortcut{
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   
    [_shortcutShowColorPicker setAssociatedUserDefaultsKey:MASCustomShortcutKeyColorPicker];
    
    [_shortcutShowMagnifier setAssociatedUserDefaultsKey:MASCustomShortcutKeyMagnifier];
    //[_shortcutShowColorPicker bind:@"enabled" toObject:defaults withKeyPath:MASCustomShortcutEnabledKey options:nil];
    
//    [defaults addObserver:self forKeyPath:MASCustomShortcutEnabledKey
//                  options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew
//                  context:MASObservingContext];
//    [defaults addObserver:self forKeyPath:MASHardcodedShortcutEnabledKey
//                  options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew
//                  context:MASObservingContext];
    
    
}

- (void)ShowRenameAlert{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:@"You cannot rename the Swatch defaults."];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert beginSheetModalForWindow:[self window] completionHandler:nil];
}

@end
