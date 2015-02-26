//
//  PianoKey.h
//  BurpAndFartPiano
//
//  Created by Sam Meech-Ward on 2014-08-01.
//  Copyright (c) 2014 Sam Meech-Ward. All rights reserved.
//
// Frameworks
@import UIKit;
@import QuartzCore;

// Declare a piano key delegate
@protocol PianoKeyDelegate;

@interface PianoKey : CALayer

+(id)newKey;
+(id)newKeyWithFrame:(CGRect)frame;

-(void)setup;
-(void)down;
-(void)up;

@property (nonatomic) int keyNumber;
@property (nonatomic, readonly) BOOL isUp;
@property (nonatomic, readonly) BOOL isHighlighted;

@property (nonatomic, weak) id<PianoKeyDelegate>pianoDelegate;

@end

// Setup the piano key delegate methods
@protocol PianoKeyDelegate

-(void)pianoKeyDown:(PianoKey *)key;
-(void)pianoKeyUp:(PianoKey *)key;

@end