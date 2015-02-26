//
//  PianoView.h
//  BurpAndFartPiano
//
//  Created by Sam Meech-Ward on 2014-08-01.
//  Copyright (c) 2014 Sam Meech-Ward. All rights reserved.
//

// This is currently an 88 key piano, with 52 white keys and 36 black keys\
This could easily be changed to create a piano with any number of keys in any number of orders

// Constants
#define TOTAL_WHITE_KEYS ((UInt8)52)
#define TOTAL_BLACK_KEYS ((UInt8)36)

// Frameworks
#import <UIKit/UIKit.h>

// Piano Key
#import "PianoKey.h"

// Declare a piano view delegate
@protocol PianoViewDelegate;

@interface PianoView : UIView <PianoKeyDelegate>

@property (nonatomic) IBOutlet id <PianoViewDelegate> delegate;

@end

// Setup the piano view delegate methods
@protocol PianoViewDelegate

@optional
-(void)pianoView:(PianoView *)piano keyDown:(int)key;
-(void)pianoView:(PianoView *)piano keyUp:(int)key;

@end