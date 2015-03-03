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
#include "Sitar.h"

@interface AudioInstrumentController() <AudioPlayerControllerDataSource>

@property (strong, nonatomic) AudioPlayerController *audioController;

@end

@implementation AudioInstrumentController {
    // Stk Instuments
    stk::TubeBell *tubeBell;
    stk::Wurley *wurley;
    stk::Sitar *sitar;
    stk::Rhodey *rhodey;
}

#pragma mark - Setup

- (id)init {
    self = [self initWithInstrument:InstrumentTypeRhodey];
    return self;
}

- (id)initWithInstrument:(InstrumentType)instrument {
    self = [super init];
    if (self) {
        // Set up audio
        stk::Stk::setRawwavePath([[[NSBundle mainBundle] pathForResource:@"rawwaves" ofType:@"bundle"] UTF8String]);
        
        // Setup the instruments
        [self setupInstruments];
        
        // Set the current instrument
        [self setCurrentInstrument:instrument];
        
        // Setup the audio Controller
        self.audioController = [[AudioPlayerController alloc] init];
        self.audioController.dataSource = self;
    }
    return self;
}

- (void)setupInstruments {
    // Initialize the instruments
    sitar = new stk::Sitar();
    wurley = new stk::Wurley();
    tubeBell = new stk::TubeBell();
    rhodey = new stk::Rhodey();
}


#pragma mark - Actions

- (void)playFrequency:(double)frequency {
    // Start a note with the given frequency and an amplitude of 1.
    switch (_currentInstrument) {
        case InstrumentTypeSitar:
            sitar->noteOn(frequency, 1);
            break;
        case InstrumentTypeWurley:
            wurley->noteOn(frequency, 1);
            break;
        case InstrumentTypeTubeBell:
            tubeBell->noteOn(frequency, 1);
            break;
        case InstrumentTypeRhodey:
            rhodey->noteOn(frequency, 1);
            break;
    }
}

#pragma mark - AudioPlayerController

- (Float32)audioControllerDataSourceNextFrame {
    // Return one output sample of the current instrument to channel 0
    switch (_currentInstrument) {
        case InstrumentTypeSitar:
            return sitar->tick(0);
        case InstrumentTypeWurley:
            return wurley->tick(0);
        case InstrumentTypeTubeBell:
            return tubeBell->tick(0);
        case InstrumentTypeRhodey:
            return rhodey->tick(0);
    }
    return 0;
}

@end
