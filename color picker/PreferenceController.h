//
//  PreferenceController.h
//  color picker
//
//  Created by tran nam on 5/21/15.
//  Copyright (c) 2015 Tran Nam. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface PreferenceController : NSWindowController<NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, strong) NSMutableArray *swatchesArray;
@property (strong) IBOutlet NSView *generalView;
@property (strong) IBOutlet NSView *swatchesView;
@property (strong) IBOutlet NSView *formatView;
@property (strong) IBOutlet NSView *avancedView;
@property (weak) IBOutlet NSView *windowView;
@property (weak) IBOutlet NSTableView *tableSwatches;
@property (weak) IBOutlet NSPopUpButton *showAppIconPopUp;
@property (weak) IBOutlet NSButton *removeSwatchesButton;
@property (weak) IBOutlet NSButton *addSwatchesButton;

@property (weak) IBOutlet NSPopUpButton *sourceCodePopup;
@property (weak) IBOutlet NSButton *appendsemiCheckbox;
@property (weak) IBOutlet NSButton *zeroSuppresCheckbox;
@property (weak) IBOutlet NSPopUpButton *displayFormatPopUp;
@property (weak) IBOutlet NSButton *hideWindowCheckbox;
@property (weak) IBOutlet NSButton *showWindowCheckbox;

- (IBAction)toolbarGeneral:(id)sender;
- (IBAction)toolbarAdvance:(id)sender;
- (IBAction)toolbarFormat:(id)sender;
- (IBAction)toolbarSwatches:(id)sender;

- (IBAction)showAppIcon:(id)sender;

- (IBAction)hideWindowOnMagnifier:(id)sender;
- (IBAction)showWindowAfterMagnifier:(id)sender;

- (IBAction)addSwatches:(id)sender;
- (IBAction)removeSwatches:(id)sender;

- (IBAction)showSourceCode:(id)sender;
- (IBAction)showDisplayedFormat:(id)sender;
- (IBAction)enableZeroSupperssion:(id)sender;
- (IBAction)appendSemiColon:(id)sender;


@end
