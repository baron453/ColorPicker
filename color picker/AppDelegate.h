//
//  AppDelegate.h
//  color picker
//
//  Created by tran nam on 5/19/15.
//  Copyright (c) 2015 Tran Nam. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StatusResponder.h"

@class WindowController;
@class PreferenceController;
@interface AppDelegate : NSObject <NSApplicationDelegate,NSWindowDelegate>


@property WindowController *windowController;
@property PreferenceController *preferenceController;
@property NSMutableArray *categoriesArray;
@property NSMutableArray *swatchesMenuArray;
@property NSInteger cateCurrent;
@property (weak) IBOutlet StatusResponder *statusView;
@property (weak) IBOutlet NSMenuItem *toggleMagnifier;
@property (weak) IBOutlet NSMenuItem *swatches;
@property (weak) IBOutlet NSMenuItem *recentlySaveColorItem;
@property (weak) IBOutlet NSMenuItem *recentlyCopiedColorItem;
@property (weak) IBOutlet NSMenuItem *separatorSaveColorItem;
@property (weak) IBOutlet NSMenuItem *separatorCopiedColorItem;

@property NSStatusItem *statusItem;
@property (weak) IBOutlet NSMenu *statusMenu;

- (void)updateStatusMenu;
- (void)updateFormatCopiedStatusMenu;
- (IBAction)showPreference:(id)sender;
- (IBAction)quitApp:(id)sender;
- (IBAction)copiedNSClolor:(id)sender;
- (IBAction)copiedUIColor:(id)sender;
- (IBAction)copiedRGBColor:(id)sender;
- (IBAction)copiedHexColor:(id)sender;
- (IBAction)showToggleMagnifier:(id)sender;
- (IBAction)showSwatches:(id)sender;
- (IBAction)saveCurrentColor:(id)sender;


@end

