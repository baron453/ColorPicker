//
//  AppDelegate.m
//  color picker
//
//  Created by tran nam on 5/19/15.
//  Copyright (c) 2015 Tran Nam. All rights reserved.
//

#import "AppDelegate.h"
#import "WindowController.h"
#import "PreferenceController.h"
#import "swatchObject.h"
#import "CateMainObject.h"
#import "NSColor+hex.h"
#import "Shortcut.h"
static NSString *const MASCustomShortcutKeyColorPicker = @"customShortcutColorPicker";
static NSString *const MASCustomShortcutKeyMagnifier = @"customShortcutMagnifier";
@interface AppDelegate ()
@end

@implementation AppDelegate
    CateMainObject * mainObject;
    NSMutableArray *colorCopiedArray;
@synthesize windowController = _windowController;
-(void)awakeFromNib{
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CategoriesColor"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SwatchesItemSelected"];
    self.cateCurrent =[[NSUserDefaults standardUserDefaults] integerForKey:@"SwatchesItemSelected"];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"CategoriesColor"];
    mainObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if(!mainObject){
        mainObject = [[CateMainObject alloc]init];
    }
    
    self.categoriesArray = [mainObject cateArray];
    if(self.categoriesArray.count<=0){
        self.categoriesArray = [NSMutableArray array];
        swatchObject *newSwatch = [[swatchObject alloc] init];
        [newSwatch setTitle:@"Swatches"];
        [newSwatch setCategoriesColor:[NSMutableArray array]];
        [self.categoriesArray addObject:newSwatch];
        self.cateCurrent=0;
    }
    //NSLog(@"%lu",(unsigned long)self.categoriesArray.count);
    self.preferenceController = [[PreferenceController alloc] initWithWindowNibName:@"PreferenceController"];
    self.windowController = [[WindowController alloc] initWithWindowNibName:@"WindowController"];
    colorCopiedArray = [NSMutableArray arrayWithObjects:nil];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadShowWindow)
                                                 name:@"LeftClickButtonStatusItem"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showMenuItem)
                                                 name:@"RightClickButtonStatusItem"
                                               object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(loadShowAppIcon)
                                                name:@"showAppIcon"
                                              object:nil];
    [self updateStatusMenu];
    [self loadShowAppIcon];
    [self setShortcut];
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    //swatchObject *Ob = [self.categoriesArray objectAtIndex:0];
    //NSLog(@"%lu",(unsigned long)[Ob categoriesColor].count);
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CategoriesColor"];
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SwatchesItemSelected"];
    
    [mainObject setCateArray:self.categoriesArray];
    //NSLog(@"MainObject %lu",(unsigned long)[mainObject cateArray].count);
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:mainObject];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"CategoriesColor"];
    [[NSUserDefaults standardUserDefaults] setInteger:self.cateCurrent forKey:@"SwatchesItemSelected"];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
    [self.windowController showWindow:self];
    [NSApp activateIgnoringOtherApps:YES];
    return YES;
}
- (IBAction)showPreference:(id)sender {
    [self.preferenceController showWindow:self];
    [NSApp activateIgnoringOtherApps:YES];

}

- (void)updateStatusMenu{
    BOOL isHexDisplayFormat = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DisplayedFormat"] integerValue];
    swatchObject *swatchOb = [_categoriesArray objectAtIndex:_cateCurrent];
    NSInteger posSaveColor = [_statusMenu indexOfItem:_recentlySaveColorItem];
    NSInteger posSeparatorSaveColor = [_statusMenu indexOfItem:_separatorSaveColorItem];
    for(NSInteger i=posSaveColor+1;i<posSeparatorSaveColor;i++){
        [_statusMenu removeItemAtIndex:posSaveColor+1];
    }
    
    for(NSInteger i=[swatchOb categoriesColor].count-1;i>=0;i--){
        NSInteger count = [swatchOb categoriesColor].count-1-i;
        //NSLog(@"%ld",(long)count);
        if(count>=5) break;
        NSColor *color = [NSColor colorFromHexadecimalValue:[[swatchOb categoriesColor] objectAtIndex:i]];
        if (isHexDisplayFormat) {
            NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:[color hexadecimalValue]
                                                          action:@selector(setCurrencyColor:) keyEquivalent:@""];
            [item setRepresentedObject:color];
            [_statusMenu insertItem:item atIndex:posSaveColor+[swatchOb categoriesColor].count-i];
        }else{
            NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"%@, %@, %@",
                                                                  [color redValue],
                                                                  [color greenValue],
                                                                  [color blueValue]]
                                                          action:@selector(setCurrencyColor:) keyEquivalent:@""];
            [item setRepresentedObject:color];
            [_statusMenu insertItem:item atIndex:posSaveColor+[swatchOb categoriesColor].count-i];
        }
    }
    
    if([swatchOb categoriesColor].count==0)
        [_recentlySaveColorItem setHidden:YES];
    else
        [_recentlySaveColorItem setHidden:NO];

}
- (void)updateCopiedStatusMenu{
    BOOL isHexDisplayFormat = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DisplayedFormat"] integerValue];
    NSInteger colorCopiedArrayCount = colorCopiedArray.count;
    NSInteger posSeparatorCopiedColor = [_statusMenu indexOfItem:_separatorCopiedColorItem];
    for(NSInteger i=1;i<posSeparatorCopiedColor;i++){
        [_statusMenu removeItemAtIndex:1];
    }
    NSColor *color = [NSColor colorFromHexadecimalValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentColor"]];
    for(NSInteger i=0;i<colorCopiedArray.count;i++){
        if([[[colorCopiedArray objectAtIndex:i] hexadecimalValue] isEqualToString:[color hexadecimalValue]]){
            [colorCopiedArray removeObjectAtIndex:i];
            break;
        }
    }
    [colorCopiedArray addObject:color];
    if (colorCopiedArrayCount>5) {
        [colorCopiedArray removeObjectAtIndex:0];
    }
    for(NSInteger i=0;i<colorCopiedArray.count;i++){
        NSColor *colors =[colorCopiedArray objectAtIndex:i];
        if (isHexDisplayFormat) {
            NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:[colors hexadecimalValue]
                                                          action:@selector(setCurrencyColor:) keyEquivalent:@""];
            [item setTag:isHexDisplayFormat];
            [item setRepresentedObject:colors];
            [_statusMenu insertItem:item atIndex:1];

        }else{
            NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"%@, %@, %@",
                                                                  [colors redValue],
                                                                  [colors greenValue],
                                                                  [colors blueValue]]
                                                          action:@selector(setCurrencyColor:) keyEquivalent:@""];
            [item setTag:isHexDisplayFormat];
            [item setRepresentedObject:colors];
            [_statusMenu insertItem:item atIndex:1];

        }
    }
    
    if(colorCopiedArray.count<=0)
        [_recentlyCopiedColorItem setHidden:YES];
    else
        [_recentlyCopiedColorItem setHidden:NO];
    
}

- (void)updateFormatCopiedStatusMenu{
    BOOL isHexDisplayFormat = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DisplayedFormat"] integerValue];
    NSInteger colorCopiedArrayCount = colorCopiedArray.count;
    NSInteger posSeparatorCopiedColor = [_statusMenu indexOfItem:_separatorSaveColorItem];
    for(NSInteger i=1;i<posSeparatorCopiedColor;i++){
        [_statusMenu removeItemAtIndex:1];
    }
    for(NSInteger i=0;i<colorCopiedArrayCount;i++){
        NSColor *colors =[colorCopiedArray objectAtIndex:i];
        if (isHexDisplayFormat) {
            NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:[colors hexadecimalValue]
                                                          action:@selector(setCurrencyColor:) keyEquivalent:@""];
            [item setTag:isHexDisplayFormat];
            [item setRepresentedObject:colors];
            [_statusMenu insertItem:item atIndex:1];
            
        }else{
            NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"%@, %@, %@",
                                                                  [colors redValue],
                                                                  [colors greenValue],
                                                                  [colors blueValue]]
                                                          action:@selector(setCurrencyColor:) keyEquivalent:@""];
            [item setTag:isHexDisplayFormat];
            [item setRepresentedObject:colors];
            [_statusMenu insertItem:item atIndex:1];
            
        }
    }
    
}


- (IBAction)quitApp:(id)sender {
    [NSApp terminate: nil];
}

- (IBAction)setCurrencyColor:(id)sender{
    NSColor *color = [sender representedObject];
    [[NSUserDefaults standardUserDefaults] setValue:[color hexadecimalValue] forKey:@"CurrentColor"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadCurrentColor" object:nil];
    [self loadShowWindow];
}

- (IBAction)copiedNSClolor:(id)sender {
    [self updateCopiedStatusMenu];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CopyNSColor" object:nil];
}

- (IBAction)copiedUIColor:(id)sender {
    [self updateCopiedStatusMenu];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CopyUIColor" object:nil];
}

- (IBAction)copiedRGBColor:(id)sender {
    [self updateCopiedStatusMenu];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CopyRGBColor" object:nil];
}

- (IBAction)copiedHexColor:(id)sender {
    [self updateCopiedStatusMenu];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CopyHexColor" object:nil];
}

- (IBAction)showToggleMagnifier:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowToggleMagnifier" object:nil];
}

- (IBAction)showSwatches:(id)sender {
    [self loadShowWindow];
}

- (IBAction)saveCurrentColor:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddCurrentColor" object:nil];
}

- (void)loadShowWindow{
    [_windowController showWindow:self];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)loadShowAppIcon{
    //--show icon dock
    NSString *iconDock = [[NSUserDefaults  standardUserDefaults] objectForKey:@"ShowAppIcon"];
    switch ([iconDock integerValue]){
        case 0:
            if(_statusItem) _statusItem=nil;
            [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
            if(![_windowController.window isVisible]){
                [self loadShowWindow];
            }
            
            break;
        case 1:
            if(!_statusItem){
                _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
                [_statusItem setView:_statusView];
                [_statusItem setHighlightMode:YES];
                [_statusItem setMenu:_statusMenu];
            }
            [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
            if(![_windowController.window isVisible]){
                [self loadShowWindow];
            }
            break;
        case 2:
            if(!_statusItem){
                _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
                [_statusItem setView:_statusView];
                [_statusItem setHighlightMode:YES];
                [_statusItem setMenu:_statusMenu];
            }
            [NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];
            if([_windowController.window isVisible]){
                [_windowController close];
            }else{
                [_windowController showWindow:self];
                [_windowController close];
            }
            break;
        default:
            break;
    }
}
- (void)showMenuItem{
    [_statusItem popUpStatusItemMenu:_statusMenu];
}

- (void)setShortcut{
    [[MASShortcutBinder sharedBinder] bindShortcutWithDefaultsKey:MASCustomShortcutKeyColorPicker toAction:^{
        [self loadShowWindow];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SetAcceptPickerWindow" object:nil];
    }];
    [[MASShortcutBinder sharedBinder] bindShortcutWithDefaultsKey:MASCustomShortcutKeyMagnifier toAction:^{
        [self showToggleMagnifier:self];
    }];
}
@end
