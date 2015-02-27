//
//  AudioInstrumentController.h
//  Piano
//
//  Created by Sam Meech Ward on 2015-02-26.
//  Copyright (c) 2015 Sam Meech-Ward. All rights reserved.
//

#import <Foundation/Foundation.h>

// Enum for the different types of instruments that can be played
typedef NS_ENUM(NSUInteger, Instrument) {
    InstrumentWurley,
    InstrumentRhodey,
    InstrumentSitar,
    InstrumentTubeBell,
};

@interface AudioInstrumentController : NSObject

- (id)initWithInstrument:(Instrument)instrument;
- (void)setCurrentInstrument:(Instrument)instrument;
- (void)playFrequency:(double)frequency;

@end
