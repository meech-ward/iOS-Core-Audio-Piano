//
//  AudioInstrumentController.m
//  Piano
//
//  Created by Sam Meech Ward on 2015-02-26.
//  Copyright (c) 2015 Sam Meech-Ward. All rights reserved.
//

#import "AudioInstrumentController.h"

#import "AudioPlayerController.h"

// Instruments
#include "Instrmnt.h"
#include "PercFlut.h"
#include "Wurley.h"
#include "Rhodey.h"
#include "TubeBell.h"
#include <Sitar.h>

@interface AudioInstrumentController() <AudioPlayerControllerDataSource>

@property (strong, nonatomic) AudioPlayerController *audioController;

@end

@implementation AudioInstrumentController {
    stk::Instrmnt *currentInstrument;
}

#pragma mark - Setup

- (id)init {
    self = [self initWithInstrument:InstrumentRhodey];
    return self;
}

- (id)initWithInstrument:(Instrument)instrument {
    self = [super init];
    if (self) {
        // Set up stk
        stk::Stk::setRawwavePath([[[NSBundle mainBundle] pathForResource:@"rawwaves" ofType:@"bundle"] UTF8String]);
        
        // Setup the instrument
        [self setCurrentInstrument:instrument];
        
        // Setup the audio Controller
        self.audioController = [[AudioPlayerController alloc] init];
        self.audioController.dataSource = self;
    }
    return self;
}

- (void)setCurrentInstrument:(Instrument)instrument {
    // Release any instruments
    if (currentInstrument) {
        delete(currentInstrument);
    }
    
    // Initialize the instrument object to the correct type of instrument
    switch (instrument) {
        case InstrumentSitar:
            currentInstrument = new stk::Sitar();
            break;
        case InstrumentWurley:
            currentInstrument = new stk::Wurley();
            break;
        case InstrumentTubeBell:
            currentInstrument = new stk::TubeBell();
            break;
        case InstrumentRhodey:
            currentInstrument = new stk::Rhodey();
            break;
    }
}


#pragma mark - Actions

- (void)playFrequency:(double)frequency {
    currentInstrument->noteOn(frequency, 1);
}

#pragma mark - AudioPlayerController

- (Float32)audioControllerDataSourceNextFrame {
    return currentInstrument->tick(0);
}

@end
