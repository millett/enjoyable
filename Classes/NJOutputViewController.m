//
//  NJOutputController.m
//  Enjoy
//
//  Created by Sam McCall on 5/05/09.
//

#import <Cocoa/Cocoa.h>
#import "NJOutputViewController.h"

#import "NJMapping.h"
#import "NJInput.h"
#import "NJEvents.h"
#import "NJInputController.h"
#import "NJKeyInputField.h"
#import "NJOutputMapping.h"
#import "NJOutputViewController.h"
#import "NJOutputKeyPress.h"
#import "NJOutputMouseButton.h"
#import "NJOutputMouseMove.h"
#import "NJOutputMouseScroll.h"
#import "NSView+FirstResponder.h"
#import "NSMenu+RepresentedObjectAccessors.h"

typedef NS_ENUM(NSUInteger, NJOutputRow) {
    NJOutputRowNone,
    NJOutputRowKey,
    NJOutputRowSwitch,
    NJOutputRowMove,
    NJOutputRowButton,
    NJOutputRowScroll,
};

@implementation NJOutputViewController {
    NJInput *_input;
}

- (id)init {
    if ((self = [super init])) {
        [NSNotificationCenter.defaultCenter
            addObserver:self
            selector:@selector(mappingListDidChange:)
            name:NJEventMappingListChanged
            object:nil];
    }
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)cleanUpInterface {
    NSInteger row = self.radioButtons.selectedRow;
    
    if (row != NJOutputRowKey) {
        self.keyInput.keyCode = NJKeyInputFieldEmpty;
        [self.keyInput resignIfFirstResponder];
    }
    
    if (row != NJOutputRowSwitch) {
        [self.mappingPopup selectItemAtIndex:-1];
        [self.mappingPopup resignIfFirstResponder];
        self.unknownMapping.hidden = YES;
    }
    
    if (row != NJOutputRowMove) {
        self.mouseDirSelect.selectedSegment = -1;
        self.mouseSpeedSlider.doubleValue = self.mouseSpeedSlider.minValue;
        self.setCheck.state = NSControlStateValueOff;
        [self.setCheck resignIfFirstResponder];
        [self.mouseDirSelect resignIfFirstResponder];
    } else {
        if (self.mouseDirSelect.selectedSegment == -1)
            self.mouseDirSelect.selectedSegment = 0;
        if (self.mouseSpeedSlider.floatValue == 0)
            self.mouseSpeedSlider.floatValue = 10;
    }
    
    if (row != NJOutputRowButton) {
        self.mouseBtnSelect.selectedSegment = -1;
        [self.mouseBtnSelect resignIfFirstResponder];
    } else if (self.mouseBtnSelect.selectedSegment == -1)
        self.mouseBtnSelect.selectedSegment = 0;
    
    if (row != NJOutputRowScroll) {
        self.scrollDirSelect.selectedSegment = -1;
        self.scrollSpeedSlider.doubleValue = self.scrollSpeedSlider.minValue;
        self.smoothCheck.state = NSControlStateValueOff;
        [self.scrollDirSelect resignIfFirstResponder];
        [self.scrollSpeedSlider resignIfFirstResponder];
        [self.smoothCheck resignIfFirstResponder];
    } else {
        if (self.scrollDirSelect.selectedSegment == -1)
            self.scrollDirSelect.selectedSegment = 0;
    }
        
}

- (IBAction)outputTypeChanged:(NSView *)sender {
    [sender.window makeFirstResponder:sender];
    if (self.radioButtons.selectedRow == 1)
        [self.keyInput.window makeFirstResponder:self.keyInput];
    [self commit];
}

- (void)keyInputField:(NJKeyInputField *)keyInput didChangeKey:(CGKeyCode)keyCode {
    [self.radioButtons selectCellAtRow:NJOutputRowKey column:0];
    [self.radioButtons.window makeFirstResponder:self.radioButtons];
    [self commit];
}

- (void)keyInputFieldDidClear:(NJKeyInputField *)keyInput {
    [self.radioButtons selectCellAtRow:NJOutputRowNone column:0];
    [self commit];
}

- (void)mappingChosen:(id)sender {
    [self.radioButtons selectCellAtRow:NJOutputRowSwitch column:0];
    [self.mappingPopup.window makeFirstResponder:self.mappingPopup];
    self.unknownMapping.hidden = YES;
    [self commit];
}

- (void)mouseDirectionChanged:(NSView *)sender {
    [self.radioButtons selectCellAtRow:NJOutputRowMove column:0];
    [sender.window makeFirstResponder:sender];
    [self commit];
}

- (void)mouseTypeChanged:(NSButton *)sender {
    [self.radioButtons selectCellAtRow:NJOutputRowMove column:0];
    [sender.window makeFirstResponder:sender];
    [self commit];
}

- (void)mouseSpeedChanged:(NSSlider *)sender {
    [self.radioButtons selectCellAtRow:NJOutputRowMove column:0];
    [sender.window makeFirstResponder:sender];
    [self commit];
}

- (void)mouseButtonChanged:(NSView *)sender {
    [self.radioButtons selectCellAtRow:NJOutputRowButton column:0];
    [sender.window makeFirstResponder:sender];
    [self commit];
}

- (void)scrollDirectionChanged:(NSView *)sender {
    [self.radioButtons selectCellAtRow:NJOutputRowScroll column:0];
    [sender.window makeFirstResponder:sender];
    [self commit];
}

- (void)scrollSpeedChanged:(NSSlider *)sender {
    [self.radioButtons selectCellAtRow:NJOutputRowScroll column:0];
    [sender.window makeFirstResponder:sender];
    [self commit];
}

- (IBAction)scrollTypeChanged:(NSButton *)sender {
    [self.radioButtons selectCellAtRow:NJOutputRowScroll column:0];
    [sender.window makeFirstResponder:sender];
    if (sender.state == NSControlStateValueOn) {
        self.scrollSpeedSlider.doubleValue =
            self.scrollSpeedSlider.minValue
            + (self.scrollSpeedSlider.maxValue - self.scrollSpeedSlider.minValue) / 2;
        self.scrollSpeedSlider.enabled = YES;
    } else {
        self.scrollSpeedSlider.doubleValue = self.scrollSpeedSlider.minValue;
        self.scrollSpeedSlider.enabled = NO;
    }
    [self commit];
}

- (NJOutput *)makeOutput {
    switch (self.radioButtons.selectedRow) {
        case NJOutputRowNone:
            return nil;
        case NJOutputRowKey:
            if (self.keyInput.hasKeyCode) {
                NJOutputKeyPress *k = [[NJOutputKeyPress alloc] init];
                k.keyCode = self.keyInput.keyCode;
                return k;
            } else {
                return nil;
            }
            break;
        case NJOutputRowSwitch: {
            NJOutputMapping *c = [[NJOutputMapping alloc] init];
            c.mapping = [self.delegate outputViewController:self
                                            mappingForIndex:self.mappingPopup.indexOfSelectedItem];
            return c;
        }
        case NJOutputRowMove: {
            NJOutputMouseMove *mm = [[NJOutputMouseMove alloc] init];
            mm.axis = (int)self.mouseDirSelect.selectedSegment;
            mm.speed = self.mouseSpeedSlider.floatValue;
            mm.set = self.setCheck.state == NSControlStateValueOn;
            return mm;
        }
        case NJOutputRowButton: {
            NJOutputMouseButton *mb = [[NJOutputMouseButton alloc] init];
            mb.button = (uint32_t)[self.mouseBtnSelect.cell tagForSegment:self.mouseBtnSelect.selectedSegment];
            return mb;
        }
        case NJOutputRowScroll: {
            NJOutputMouseScroll *ms = [[NJOutputMouseScroll alloc] init];
            ms.direction = (int)[self.scrollDirSelect.cell tagForSegment:self.scrollDirSelect.selectedSegment];
            ms.speed = self.scrollSpeedSlider.floatValue;
            ms.smooth = self.smoothCheck.state == NSControlStateValueOn;
            return ms;
        }
        default:
            return nil;
    }
}

- (void)commit {
    [self cleanUpInterface];
    [self.delegate outputViewController:self
                              setOutput:[self makeOutput]
                               forInput:_input];
}

- (BOOL)enabled {
    return self.radioButtons.isEnabled;
}

- (void)setEnabled:(BOOL)enabled {
    self.radioButtons.enabled = enabled;
    self.keyInput.enabled = enabled;
    self.mappingPopup.enabled = enabled;
    self.mouseDirSelect.enabled = enabled;
    self.mouseSpeedSlider.enabled = enabled;
    self.mouseBtnSelect.enabled = enabled;
    self.scrollDirSelect.enabled = enabled;
    self.smoothCheck.enabled = enabled;
    self.setCheck.enabled = enabled;
    self.scrollSpeedSlider.enabled = enabled && self.smoothCheck.state;
    if (!enabled)
        self.unknownMapping.hidden = YES;
}

- (void)loadOutput:(NJOutput *)output forInput:(NJInput *)input {
    _input = input;
    if (!input) {
        [self setEnabled:NO];
        self.title.stringValue = @"";
    } else {
        [self setEnabled:YES];
        NSString *inpFullName = input.name;
        for (NJInputPathElement *cur = input.parent; cur; cur = cur.parent) {
            inpFullName = [[NSString alloc] initWithFormat:@"%@ ▸ %@", cur.name, inpFullName];
        }
        self.title.stringValue = inpFullName;
		NSLog(@"load output for");
        NSLog(@"%@", inpFullName);
    }

    if ([output isKindOfClass:NJOutputKeyPress.class]) {
        [self.radioButtons selectCellAtRow:NJOutputRowKey column:0];
        self.keyInput.keyCode = [(NJOutputKeyPress*)output keyCode];
    } else if ([output isKindOfClass:NJOutputMapping.class]) {
        [self.radioButtons selectCellAtRow:NJOutputRowSwitch column:0];
        NSMenuItem *item = [self.mappingPopup itemWithIdenticalRepresentedObject:
                            [(NJOutputMapping *)output mapping]];
        [self.mappingPopup selectItem:item];
        self.unknownMapping.hidden = !!item;
        self.unknownMapping.title = [(NJOutputMapping *)output mappingName];
    }
    else if ([output isKindOfClass:NJOutputMouseMove.class]) {
        [self.radioButtons selectCellAtRow:NJOutputRowMove column:0];
        self.mouseDirSelect.selectedSegment = [(NJOutputMouseMove *)output axis];
        self.mouseSpeedSlider.floatValue = [(NJOutputMouseMove *)output speed];
        self.setCheck.state = [(NJOutputMouseMove *)output set] ? NSControlStateValueOn : NSControlStateValueOff;
    }
    else if ([output isKindOfClass:NJOutputMouseButton.class]) {
        [self.radioButtons selectCellAtRow:NJOutputRowButton column:0];
        [self.mouseBtnSelect selectSegmentWithTag:[(NJOutputMouseButton *)output button]];
    }
    else if ([output isKindOfClass:NJOutputMouseScroll.class]) {
        [self.radioButtons selectCellAtRow:NJOutputRowScroll column:0];
        int direction = [(NJOutputMouseScroll *)output direction];
        float speed = [(NJOutputMouseScroll *)output speed];
        BOOL smooth = [(NJOutputMouseScroll *)output smooth];
        [self.scrollDirSelect selectSegmentWithTag:direction];
        self.scrollSpeedSlider.floatValue = speed;
        self.smoothCheck.state = smooth ? NSControlStateValueOn : NSControlStateValueOff;
        self.scrollSpeedSlider.enabled = smooth;
    } else {
        [self.radioButtons selectCellAtRow:self.enabled ? 0 : -1 column:0];
    }
    [self cleanUpInterface];
}

- (void)focusKey {
    if (self.radioButtons.selectedRow <= 1)
        [self.keyInput.window makeFirstResponder:self.keyInput];
    else
        [self.keyInput resignIfFirstResponder];
}

- (void)mappingListDidChange:(NSNotification *)note {
    NSArray *mappings = note.userInfo[NJMappingListKey];
    NJMapping *current = self.mappingPopup.selectedItem.representedObject;
    [self.mappingPopup.menu removeAllItems];
    for (NJMapping *mapping in mappings) {
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:mapping.name
                                                      action:@selector(mappingChosen:)
                                               keyEquivalent:@""];
        item.target = self;
        item.representedObject = mapping;
        [self.mappingPopup.menu addItem:item];
    }
    [self.mappingPopup selectItemWithIdenticalRepresentedObject:current];
}

@end
