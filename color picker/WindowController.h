//
//  WindowController.h
//  color picker
//
//  Created by tran nam on 5/22/15.
//  Copyright (c) 2015 Tran Nam. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ScreenPickerWindow.h"
#import "RadiusTextField.h"
#import "RadiusHexaTextField.h"
#import "CustomView.h"

@interface WindowController : NSWindowController <NSWindowDelegate, ScreenPickerWindowDelegate> {
    ScreenPickerWindow *screenPickerWindow;
    IBOutlet NSColorWell *_colorWell;
}
@property (weak) IBOutlet NSView *colorWellView;
@property (weak) IBOutlet RadiusHexaTextField *hexaColor;
@property (weak) IBOutlet RadiusTextField *redColor;
@property (weak) IBOutlet RadiusTextField *greenColor;
@property (weak) IBOutlet RadiusTextField *blueColor;

@property (weak) IBOutlet RadiusTextField *nsColorString;
@property (weak) IBOutlet RadiusTextField *nsColorStringCopied;
@property (weak) IBOutlet RadiusTextField *uiColorString;
@property (weak) IBOutlet RadiusTextField *uiColorStringCopied;

@property (weak) IBOutlet NSScrollView *categoriesColor;
@property (weak) IBOutlet NSButton *addButton;
@property (weak) IBOutlet NSMenu *swatchesMenu;
@property (strong) IBOutlet NSMenu *colorMenu;
@property (weak) IBOutlet NSMenuItem *moveColorMenu;
@property (weak) IBOutlet NSMenuItem *removeColorMenu;
@property (weak) IBOutlet NSMenu *moveColorSubMenu;
@property (weak) IBOutlet NSMenu *subMenu;
@property (strong) IBOutlet NSPopUpButton *popUpSwatches;



- (IBAction)pickButtonCliked:(id)sender;
- (IBAction)deleteButtonClicked:(id)sender;
- (IBAction)colorchange:(id)sender;
- (IBAction)addToCollection:(id)sender;
- (IBAction)copyCodeString:(id)sender;
- (IBAction)removeColorFromCollection:(id)sender;
- (IBAction)popUpSwatchesSeclected:(id)sender;
//- (IBAction)moveColorToAnotherColledction:(id)sender;

@end
