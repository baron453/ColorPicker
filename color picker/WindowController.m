////
////  WindowController.m
////  color picker
////
////  Created by tran nam on 5/22/15.
////  Copyright (c) 2015 Tran Nam. All rights reserved.
////
//
#import "WindowController.h"
#import "ScreenPickerWindow.h"
#import "NSColor+hex.h"
#import "CustomView.h"
#import <QuartzCore/QuartzCore.h>
#import "ColorCustomView.h"
#import "INAppStoreWindow.h"
#import "swatchObject.h"
#import "AppDelegate.h"
#import "ButtonColorObject.h"
@interface WindowController ()
@property (strong) NSMutableArray *titles;
@end

@implementation WindowController
    NSMutableArray *viewObjectArray;
    NSMutableArray *categoriesObjectArray;
    NSInteger redColor, greenColor,blueColor;
    NSString * hexColor;
    NSCollectionView * subviews;
    CustomView *clipView;
    NSView * subviewss;
    NSInteger x,y;
    NSInteger j;
    NSPopUpButton *swatchesPopUpButton;
    NSInteger sourceCode;
    AppDelegate *delegate;
    NSPopUpButton *popUpSwatches;
    CABasicAnimation *FadeOut;
    CABasicAnimation *Vibrate;
    BOOL isAppendSemicolon,isZeroSupppression,isHideWhileUsing,isShowAfterSelected,isHexDisplayFormat;
- (void)windowDidLoad {
    [super windowDidLoad];
    delegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    viewObjectArray = [NSMutableArray arrayWithArray:nil];
    [_colorWellView setWantsLayer:YES];
    _colorWellView.layer.cornerRadius = 5.0f;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(windowDidBecomeKey:)
                                                 name:NSWindowDidBecomeKeyNotification
                                               object:screenPickerWindow];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(windowDidResignKey:)
                                                 name:NSWindowDidResignKeyNotification
                                               object:screenPickerWindow];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onChangeTextFields:)
                                                 name:NSControlTextDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(copyNSColor)
                                                 name:@"CopyNSColor"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(copyUIColor)
                                                 name:@"CopyUIColor"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(copyRGBColor)
                                                 name:@"CopyRGBColor"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(copyHexColor)
                                                 name:@"CopyHexColor"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pickButtonCliked:)
                                                 name:@"ShowToggleMagnifier"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadPreferenced)
                                                 name:@"UpdatePreference"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addToCollection:)
                                                 name:@"AddCurrentColor"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadSwatchesMenu)
                                                 name:@"UpdateSwatchesMenu"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadCurrentColor)
                                                 name:@"LoadCurrentColor"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setAcceptsMousePickerWindow)
                                                 name:@"SetAcceptPickerWindow"
                                               object:nil];
    //AddCurrentColor
    [self loadSwatchesMenu];
    [self loadTitleBar];
    [self loadPreferenced];
    [self loadCurrentColor];
    [self AddDeleteAnimation];
    [self AddVibrateAnimation];
    //[self loadCategoriesColor];
}


- (IBAction)pickButtonCliked:(id)sender {
    if([screenPickerWindow isVisible]){
        [screenPickerWindow setAcceptsMouseMovedEvents:NO];
        [screenPickerWindow orderOut:self];
        [NSCursor unhide];
    }else{
        [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
        screenPickerWindow = [[ScreenPickerWindow alloc] initWithContentRect:NSMakeRect(0, 0, 130, 130) styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:YES];
        screenPickerWindow.delegate = self;
        [screenPickerWindow makeKeyAndOrderFront:self];
        [screenPickerWindow setOrderedIndex:0];
    }
}

- (void) setAcceptsMousePickerWindow{
    if([screenPickerWindow isVisible]){
        //[screenPickerWindow makeKeyAndOrderFront:self];
        [screenPickerWindow setOrderedIndex:0];
        [screenPickerWindow setAcceptsMouseMovedEvents:YES];
        [NSCursor hide];
    }
}

- (IBAction)deleteButtonClicked:(id)sender {
    if (categoriesObjectArray.count!=0){
        NSAlert *alert = [[NSAlert alloc] init];
        
        [alert addButtonWithTitle:@"Delete"];
        [alert addButtonWithTitle:@"Dismiss"];
        [alert setMessageText:@"Are you sure you want to remove all your colors?"];
        [alert setInformativeText:@""];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert beginSheetModalForWindow:[self window] completionHandler:^(NSInteger returnCode){
            if (returnCode == NSAlertFirstButtonReturn) {
                [self deleteAllColor];
            }
        }];
    }
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    if (returnCode == NSAlertFirstButtonReturn) {
        [self deleteAllColor];

    }
}

- (void)deleteAllColor{
    for(NSView *view in viewObjectArray){
        [view setWantsLayer:YES];
        [view.layer addAnimation:FadeOut forKey:@"FadeOutAnimation"];
    }
    [categoriesObjectArray removeAllObjects];
    [viewObjectArray removeAllObjects];
    swatchObject *swatchObject = [delegate.categoriesArray objectAtIndex:delegate.cateCurrent];
    [swatchObject setCategoriesColor:categoriesObjectArray];
    [delegate.categoriesArray replaceObjectAtIndex:delegate.cateCurrent withObject:swatchObject];
    [delegate updateStatusMenu];
    [self performSelector:@selector(loadCategoriesColor) withObject:nil afterDelay:0.5];
}

- (IBAction)colorchange:(id)sender {
    [self getMouseWithColor:[sender color]];
}

- (IBAction)addToCollection:(id)sender {
    NSString *hexColor =[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentColor"];
    for(NSInteger i=0;i<categoriesObjectArray.count;i++){
        if([[categoriesObjectArray objectAtIndex:i] isEqualToString:hexColor]){
            ColorCustomView *view = [viewObjectArray objectAtIndex:i];
            [view setWantsLayer:YES];
            //[view setFrameOrigin:NSMakePoint(20, 20)];
            //view.layer.anchorPoint=CGPointMake(0.5, 0.5);
            [view.layer addAnimation:Vibrate forKey:@"VibrateAnimation"];
            NSBeep();
            return;
        }
    }
    [categoriesObjectArray addObject:hexColor];
    swatchObject *swatchObject = [delegate.categoriesArray objectAtIndex:delegate.cateCurrent];
    [swatchObject setCategoriesColor:categoriesObjectArray];
    //NSLog(@"%lu",[swatchObject categoriesColor].count);
    [delegate.categoriesArray replaceObjectAtIndex:delegate.cateCurrent withObject:swatchObject];
    [delegate updateStatusMenu];
    [self addCollection:[NSColor colorFromHexadecimalValue:hexColor] tag:categoriesObjectArray.count-1];
}

- (IBAction)copyCodeString:(id)sender {
    NSInteger tag = [sender tag];
    switch (tag) {
        case 1:
            {
                [[NSPasteboard generalPasteboard] clearContents];
                [[NSPasteboard generalPasteboard] setString:_nsColorString.stringValue  forType:NSStringPboardType];
                [_nsColorStringCopied setHidden:NO];
                [_nsColorString setAlphaValue:0];
                [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                    context.duration = 0.5f;
                    _nsColorStringCopied.animator.alphaValue = 1;
                } completionHandler:^{
                    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                        context.duration = 1.5f;
                        _nsColorStringCopied.animator.alphaValue = 0;
                        _nsColorString.animator.alphaValue = 1;
                    } completionHandler:nil];
                }];
            }
            break;
        case 2:
            {
                [[NSPasteboard generalPasteboard] clearContents];
                [[NSPasteboard generalPasteboard] setString:_uiColorString.stringValue  forType:NSStringPboardType];
                [_uiColorStringCopied setHidden:NO];
                [_uiColorString setAlphaValue:0];
                [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                    context.duration = 0.5f;
                    _uiColorStringCopied.animator.alphaValue = 1;
                } completionHandler:^{
                    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                        context.duration = 1.5f;
                        _uiColorStringCopied.animator.alphaValue = 0;
                        _uiColorString.animator.alphaValue = 1;
                    } completionHandler:nil];
                }];
            }
            break;
        default:
            break;
    }
}

- (IBAction)removeColorFromCollection:(id)sender {
    NSMenuItem* mi = (NSMenuItem*)sender;
    NSView *view = [viewObjectArray objectAtIndex:[mi tag]];
    NSLog(@"%@",view);
//    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
//        context.duration = 0.5f;
//        view.animator.alphaValue = 0;
//    } completionHandler:^{
//        [self loadCategoriesColor];
//    }];
    [view setWantsLayer:YES];
    [view.layer addAnimation:FadeOut forKey:@"FadeOutAnimation"];
    [view setAlphaValue:0.0f];
    [self performSelector:@selector(loadCategoriesColor) withObject:nil afterDelay:0.5];
    [categoriesObjectArray removeObjectAtIndex:[mi tag]];
    swatchObject *swatchObject = [delegate.categoriesArray objectAtIndex:delegate.cateCurrent];
    [swatchObject setCategoriesColor:categoriesObjectArray];
    [delegate.categoriesArray replaceObjectAtIndex:delegate.cateCurrent withObject:swatchObject];
    [delegate updateStatusMenu];
}

- (IBAction)moveColorToAnotherColledction:(id)sender {
    NSMenuItem *menu = (NSMenuItem *)sender;
    ButtonColorObject *button = [menu representedObject];
    if([menu tag]!=delegate.cateCurrent){
        NSView *view = [viewObjectArray objectAtIndex:[button tag]];
        [view setWantsLayer:YES];
        [view.layer addAnimation:FadeOut forKey:@"FadeOutAnimation"];
        [view setAlphaValue:0.0f];
        [self performSelector:@selector(loadCategoriesColor) withObject:nil afterDelay:0.5];
        [categoriesObjectArray removeObjectAtIndex:[button tag]];
        swatchObject *swatchObject = [delegate.categoriesArray objectAtIndex:delegate.cateCurrent];
        [swatchObject setCategoriesColor:categoriesObjectArray];
        [delegate.categoriesArray replaceObjectAtIndex:delegate.cateCurrent withObject:swatchObject];
        [delegate updateStatusMenu];
        swatchObject = [delegate.categoriesArray objectAtIndex:[menu tag]];
        NSMutableArray *array = [swatchObject categoriesColor];
        CGFloat isShow=NO;
        for(NSInteger i=0;i<array.count;i++){
            if([[array objectAtIndex:i] isEqualToString:[button HexColor]]){
                isShow=YES;
                break;
            }
        }
        if(!isShow){
            [array addObject:[button HexColor]];
            //NSLog(@"%ld",array.count);
            [swatchObject setCategoriesColor:array];
            [delegate.categoriesArray replaceObjectAtIndex:[menu tag] withObject:swatchObject];
        }
    }
    //NSLog(@"co ne %lu",[button tag]);
    //NSLog(@"co ne %lu",[menu tag]);
}


- (void)copyNSColor{
    [[NSPasteboard generalPasteboard] clearContents];
    [[NSPasteboard generalPasteboard] setString:_nsColorString.stringValue  forType:NSStringPboardType];
    [_nsColorStringCopied setHidden:NO];
    [_nsColorString setAlphaValue:0];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.5f;
        _nsColorStringCopied.animator.alphaValue = 1;
    } completionHandler:^{
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = 1.5f;
            _nsColorStringCopied.animator.alphaValue = 0;
            _nsColorString.animator.alphaValue = 1;
        } completionHandler:nil];
    }];
}

- (void)copyUIColor{
    [[NSPasteboard generalPasteboard] clearContents];
    [[NSPasteboard generalPasteboard] setString:_uiColorString.stringValue  forType:NSStringPboardType];
    [_uiColorStringCopied setHidden:NO];
    [_uiColorString setAlphaValue:0];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.5f;
        _uiColorStringCopied.animator.alphaValue = 1;
    } completionHandler:^{
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = 1.5f;
            _uiColorStringCopied.animator.alphaValue = 0;
            _uiColorString.animator.alphaValue = 1;
        } completionHandler:nil];
    }];

}

-(void)copyRGBColor{
    [[NSPasteboard generalPasteboard] clearContents];
    [[NSPasteboard generalPasteboard] setString:[NSString stringWithFormat:@"rgb(%@,%@,%@);",
                                                 _redColor.stringValue,
                                                 _greenColor.stringValue,
                                                 _blueColor.stringValue]
                                        forType:NSStringPboardType];
}

- (void)copyHexColor{
    [[NSPasteboard generalPasteboard] clearContents];
    [[NSPasteboard generalPasteboard] setString:[NSString stringWithFormat:@"#%@",
                                                 _hexaColor.stringValue]
                                        forType:NSStringPboardType];
}
- (void)onChangeTextFields:(NSNotification *) notification
{
    NSTextField *value = (NSTextField *) notification.object;
    if(value.tag==1){
        NSCharacterSet* nonHex = [[NSCharacterSet
                                   characterSetWithCharactersInString: @"0123456789ABCDEFabcdef"]
                                  invertedSet];
        NSRange nonHexRange = [[value stringValue] rangeOfCharacterFromSet: nonHex];
        BOOL isHex = (nonHexRange.location == NSNotFound);
        if (isHex) {
            NSInteger leng = [value stringValue].length;
            if(leng < 6){
                //NSLog(@"%@",[value stringValue]);
                for(int i=0;i<6-leng;i++){
                    hexColor = [hexColor stringByAppendingString:@"0"];
                }
                hexColor = [hexColor stringByAppendingString:[value stringValue]];
                [value setStringValue:[hexColor uppercaseString]];
                [self getMouseWithColor:[NSColor colorFromHexadecimalValue:hexColor]];
            }
            else if(leng > 6){
                NSString *hexColor = @"";
                hexColor = [[value stringValue] substringFromIndex:(leng-6)];
                [value setStringValue:[hexColor uppercaseString]];
                [self getMouseWithColor:[NSColor colorFromHexadecimalValue:hexColor]];
            }
        }else{
            [value setStringValue:[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentColor"] uppercaseString]];
            NSBeep();
        }
        
    }else if(value.tag>1 && value.tag<=4){
        //NSLog(@"%ld",(long)[[value stringValue] integerValue]);
        if([value stringValue].length > 4 || [[value stringValue] integerValue] > 255){
            NSBeep();
            [value setStringValue:@"255"];
        }
        [self getMouseWithColor:[NSColor colorFromIntRed:[_redColor.stringValue integerValue]
                                                 intGreen:[_greenColor.stringValue integerValue]
                                                  intBlue:[_blueColor.stringValue integerValue]]];
    }
}
- (void)windowDidBecomeKey:(NSNotification *)notification {
    if ([notification object] == screenPickerWindow) {
        NSLog(@"windowDidBecomeKey");
        [screenPickerWindow setAcceptsMouseMovedEvents:YES];
        [NSCursor hide];
        if (isHideWhileUsing){
            if ([self.window isVisible]){
                [self.window orderOut:self];
                //[self.window close];
            }
        }
    }
}

- (void)windowDidResignKey:(NSNotification *)notification {
    if ([notification object] == screenPickerWindow) {
        //NSLog(@"windowDidResignKey");
        [screenPickerWindow setAcceptsMouseMovedEvents:NO];
        //screenPickerWindow = nil;
        [NSCursor unhide];
        if(isShowAfterSelected){
            if (![self.window isVisible]){
                [self.window makeKeyAndOrderFront:nil];
            }
        }
    }
}

#pragma mark -
#pragma mark ScreenPickerWindowDelegate

- (void)getMouseWithColor:(NSColor *)color {
    //    NSLog(@"color well set color");
    [_colorWell setColor:color];
    [_hexaColor setStringValue:[color hexadecimalValue]];
    [_redColor setStringValue:[color redValue]];
    [_greenColor setStringValue:[color greenValue]];
    [_blueColor setStringValue:[color blueValue]];
    [self setStringSourceCode:color];
    [[NSUserDefaults standardUserDefaults] setValue:[color hexadecimalValue] forKey:@"CurrentColor"];
}

- (void)setStringSourceCode:(NSColor *)color{
    if (sourceCode==0) {
        NSString *nsColor;
        NSString *uiColor;
        if (isZeroSupppression) {
            NSString *redValue = [[[color redFloatValue] substringFromIndex:2] isEqualToString:@"000"]?[[color redFloatValue] substringToIndex:1]:[color redFloatValue];
            NSString *greenValue = [[[color greenFloatValue] substringFromIndex:2] isEqualToString:@"000"]?[[color greenFloatValue] substringToIndex:1]:[color greenFloatValue];
            NSString *blueValue = [[[color blueFloatValue] substringFromIndex:2] isEqualToString:@"000"]?[[color blueFloatValue] substringToIndex:1]:[color blueFloatValue];
            nsColor = [NSString stringWithFormat:@"[NSColor colorWithCalibratedRed:%@ green:%@ blue:%@ alpha:1]",redValue,greenValue,blueValue];
            uiColor = [NSString stringWithFormat:@"[UIColor colorWithRed:%@ green:%@ blue:%@ alpha:1]",redValue,greenValue,blueValue];
        }else{
            nsColor = [NSString stringWithFormat:@"[NSColor colorWithCalibratedRed:%@f green:%@f blue:%@f alpha:1.00f]",[color redFloatValue],[color greenFloatValue],[color blueFloatValue]];
            uiColor = [NSString stringWithFormat:@"[UIColor colorWithRed:%@f green:%@f blue:%@f alpha:1.00f]",[color redFloatValue],[color greenFloatValue],[color blueFloatValue]];
        }
        if (isAppendSemicolon){
            nsColor = [nsColor stringByAppendingString:@";"];
            uiColor = [uiColor stringByAppendingString:@";"];
        }
        [_nsColorString setStringValue:nsColor];
        [_uiColorString setStringValue:uiColor];
    }
    else{
        NSString *nsColor;
        NSString *uiColor;
        if (isZeroSupppression) {
            NSString *redValue = [[[color redFloatValue] substringFromIndex:1] isEqualToString:@"000"]?[[color redFloatValue] substringToIndex:0]:[color redFloatValue];
            NSString *greenValue = [[[color greenFloatValue] substringFromIndex:1] isEqualToString:@"000"]?[[color greenFloatValue] substringToIndex:0]:[color greenFloatValue];
            NSString *blueValue = [[[color blueFloatValue] substringFromIndex:1] isEqualToString:@"000"]?[[color blueFloatValue] substringToIndex:0]:[color blueFloatValue];
            nsColor = [NSString stringWithFormat:@"NSColor(calibratedRed: %@, green: %@, blue: %@, alpha: 1)",redValue,greenValue,blueValue];
            uiColor = [NSString stringWithFormat:@"UIColor(red: %@, green: %@, blue: %@, alpha:1)",redValue,greenValue,blueValue];
        }else{
            nsColor = [NSString stringWithFormat:@"NSColor(calibratedRed: %@, green: %@, blue: %@, alpha: 1.00)",[color redFloatValue],[color greenFloatValue],[color blueFloatValue]];
            uiColor = [NSString stringWithFormat:@"UIColor(red: %@, green: %@, blue: %@, alpha:1.00)",[color redFloatValue],[color greenFloatValue],[color blueFloatValue]];
        }
        
        [_nsColorString setStringValue:nsColor];
        [_uiColorString setStringValue:uiColor];
    }

}

- (void)addCollection:(NSColor *)color tag:(NSInteger)tag{
    NSInteger width = 40, height = 40,padding =6;
    if(j%4==0){
        j=1;
        x = 10;
        y += padding + height;
    }
    ColorCustomView *viewObject = [[ColorCustomView alloc] initWithFrame:NSMakeRect(x,y, width,height)];
    NSView *viewChildObject = [[NSView alloc] initWithFrame:NSMakeRect(padding/2, padding/2, width- padding, height - padding)];
        [viewChildObject setWantsLayer:YES];
        viewChildObject.layer.backgroundColor = color.CGColor;
        viewChildObject.layer.borderColor= [NSColor whiteColor].CGColor;
    viewChildObject.layer.cornerRadius = 5.0f;
        viewChildObject.layer.borderWidth=2.0f;
    NSButton *button = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, width - padding, height - padding)];
    [button setAlphaValue:0.0f];
    [button setTitle:@""];
    [button setTag:tag];
    [button setAction:@selector(getCurrentColor:)];
    ButtonColorObject *btnObject = [[ButtonColorObject alloc]initWithHexColor:[color hexadecimalValue] tag:tag];
    for(int i=0;i<delegate.categoriesArray.count;i++){
        if(i<=0){
            [[_subMenu itemAtIndex:i] setRepresentedObject:btnObject];
        }else{
            [[_subMenu itemAtIndex:i+1] setRepresentedObject:btnObject];
        }
    }
    [_removeColorMenu setTag:tag];
    NSMenu *colorMenu = [_colorMenu copy];
    [viewObject setMenu:colorMenu];
    //NSLog(@"sad %@",colorMenu.supermenu);
    [viewChildObject addSubview:button];
    [viewObject addSubview:viewChildObject];
    [clipView addSubview:viewObject];
    [viewObjectArray addObject:viewObject];
    j++;
    x+= padding + width;
    NSRect newFrame = clipView.frame;
    newFrame.size.width = 170;
    newFrame.size.height = y +padding + height;
    [clipView setFrame:newFrame];
}

- (void)loadCategoriesColor{
    x = 10;
    y = 10;
    j=1;
    [viewObjectArray removeAllObjects];
    swatchObject *swatchCurrentObject = [delegate.categoriesArray objectAtIndex:delegate.cateCurrent];
    categoriesObjectArray = [swatchCurrentObject categoriesColor];
    //NSLog(@"categoriesObjectArray %ld,%ld",delegate.cateCurrent,categoriesObjectArray.count);
    clipView = [[CustomView alloc] initWithFrame:_categoriesColor.frame];
    for(NSInteger i=0;i<categoriesObjectArray.count;i++){
        NSString *hexColor = [categoriesObjectArray objectAtIndex:i];
        [self addCollection:[NSColor colorFromHexadecimalValue:
                    [NSString stringWithFormat:@"%@",hexColor]] tag:i];
    }
    //    [categoriesArray removeAllObjects];
    [_categoriesColor setDocumentView:clipView];
    
}

- (void)getCurrentColor:(id)sender{
    NSInteger tag = [sender tag];
    NSString *hexColor = [categoriesObjectArray objectAtIndex:tag];
    NSColor *color = [NSColor colorFromHexadecimalValue:hexColor];
    [self getMouseWithColor:color];
}

- (void)loadCurrentColor{
    NSColor *color = [NSColor colorFromHexadecimalValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentColor"]];
    [self getMouseWithColor:color];
}

- (void)loadSwatchesMenu{
    [_swatchesMenu removeAllItems];
    [_subMenu removeAllItems];
    for(int i=0;i<delegate.categoriesArray.count;i++){
        swatchObject *swatchDoc = [delegate.categoriesArray objectAtIndex:i];
        NSMenuItem *item = [[NSMenuItem alloc]init];
        [item setTitle:[NSString stringWithFormat:@"%@",[swatchDoc title]]];
        NSMenuItem *items = [[NSMenuItem alloc]init];
        [items setTitle:[NSString stringWithFormat:@"%@",[swatchDoc title]]];
        if(i<=0){
            [_swatchesMenu addItem:item];
            [_swatchesMenu addItem:[NSMenuItem separatorItem]];
            [_subMenu addItem:items];
            [[_subMenu itemAtIndex:i] setTag:i];
            [[_subMenu itemAtIndex:i] setAction:@selector(moveColorToAnotherColledction:)];
            if(delegate.cateCurrent==i)
                [[_subMenu itemAtIndex:i] setEnabled:NO];
            [_subMenu addItem:[NSMenuItem separatorItem]];
        }else{
            [_swatchesMenu addItem:item];
            [_subMenu addItem:items];
            [[_subMenu itemAtIndex:i+1] setTag:i];
            [[_subMenu itemAtIndex:i+1] setAction:@selector(moveColorToAnotherColledction:)];
            if(delegate.cateCurrent==i)
                [[_subMenu itemAtIndex:i+1] setEnabled:NO];
        }
    }
    if (delegate.cateCurrent > delegate.categoriesArray.count-1)
        delegate.cateCurrent = delegate.categoriesArray.count-1;
    if(_popUpSwatches){
        [_popUpSwatches setMenu:_swatchesMenu];
        if(delegate.cateCurrent>0)
            [_popUpSwatches selectItemAtIndex:delegate.cateCurrent+1];
        else
            [_popUpSwatches selectItemAtIndex:delegate.cateCurrent];
    }
    [self loadCategoriesColor];
}


- (IBAction)popUpSwatchesSeclected:(id)sender{
    NSPopUpButton *popUp = (NSPopUpButton *) sender;
    if(popUp.indexOfSelectedItem>1)
        delegate.cateCurrent = popUp.indexOfSelectedItem-1;
    else
        delegate.cateCurrent = popUp.indexOfSelectedItem;
    //NSLog(@"%ld",delegate.cateCurrent);
    [viewObjectArray removeAllObjects];
    [delegate updateStatusMenu];
    [self loadCategoriesColor];
}
- (void)loadPreferenced{
    NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
    sourceCode = [[userDefaults objectForKey:@"SourceCode"] integerValue];
    isAppendSemicolon = [[userDefaults objectForKey:@"AppendSemicolon"] integerValue];
    isZeroSupppression = [[userDefaults objectForKey:@"ZeroSupppression"] integerValue];
    isHideWhileUsing = [[userDefaults objectForKey:@"HideWindowWhileUsingMagnifier"] integerValue];
    isShowAfterSelected = [[userDefaults objectForKey:@"ShowWindowAfterSelectedColor"] integerValue];
    isHexDisplayFormat = [[userDefaults objectForKey:@"DisplayedFormat"] integerValue];
}


- (void)loadTitleBar{
    INAppStoreWindow *aWindow = (INAppStoreWindow *) [self window];
    aWindow.titleBarHeight = 40.0;
    //bar title
    NSView *titleBarView = aWindow.titleBarView;
    //btnSetting
    NSRect r = NSMakeRect(330, 7, 150, 26);
    NSView *popupView =[[NSView alloc] initWithFrame:r];
    [popupView addSubview:_popUpSwatches];
    [titleBarView addSubview:popupView];
    if(delegate.cateCurrent>0)
        [popUpSwatches selectItemAtIndex:delegate.cateCurrent+1];
    else
        [popUpSwatches selectItemAtIndex:delegate.cateCurrent];
    //lblTitle
    r = NSMakeRect(370/2-100, 3, 200  , 26);
    NSTextField *lblTitle=[[NSTextField alloc] initWithFrame:r];
    [lblTitle setBezeled:NO];
    [lblTitle setDrawsBackground:NO];
    [lblTitle setEditable:NO];
    [lblTitle setSelectable:NO];
    [lblTitle setStringValue:@"Color Picker"];
    [lblTitle setAlignment:NSCenterTextAlignment];
    [lblTitle setFont:[NSFont systemFontOfSize:14]];
    [titleBarView addSubview:lblTitle];
}
- (void)AddVibrateAnimation{
    Vibrate = [CABasicAnimation animationWithKeyPath:@"position.x"];
    Vibrate.duration = 0.05;
    Vibrate.byValue = @(3);
    Vibrate.autoreverses = YES;
    Vibrate.repeatCount = 3;
    
    
//    Vibrate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    Vibrate.fromValue = [NSNumber numberWithFloat:0.1];
//    Vibrate.toValue = [NSNumber numberWithFloat:-3.14*0.125];
//    Vibrate.duration = 0.05;        // 1 second
//    Vibrate.autoreverses = YES;    // Back
//    Vibrate.repeatCount = 3;       // Or whatever
}
- (void)AddDeleteAnimation{
    FadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    FadeOut.fromValue = [NSNumber numberWithFloat:1.0];
    FadeOut.toValue = [NSNumber numberWithFloat:0.0];
    FadeOut.duration = 0.5;        // 1 second
    //flash.autoreverses = YES;    // Back
    //flash.repeatCount = 3;       // Or whatever
}
@end
