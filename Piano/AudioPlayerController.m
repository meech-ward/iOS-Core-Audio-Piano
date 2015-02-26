//
//  AudioPlayerController.m
//  Piano
//
//  Created by Sam Meech Ward on 2015-02-26.
//  Copyright (c) 2015 Sam Meech-Ward. All rights reserved.
//

#import "AudioPlayerController.h"

#import "CoreAudioUtility.h"

//
typedef struct _audioPlayerData {
    AudioUnit outputUnit; // Default ouput audio unit
    double startingFrameCount; // Counter that represnts the current offsetin the audio wave
    double frequency; // The frequency at which the audio should play
} AudioPlayerData;


@implementation AudioPlayerController {
    AudioPlayerData *audioPlayerData;
}

#pragma mark - Setup

- (id)init {
    self = [super init];
    if (self) {
        // Setup the audio player data
        [self setupAudioPlayer];
    }
    return self;
}

- (void)setupAudioPlayer {
    // Initialize the audio player
    audioPlayerData = calloc(1, sizeof(AudioPlayerData));
    
    // Create an Audio Componenet Description that matches the device speakers as output
    AudioComponentDescription outputcd = {0};
    outputcd.componentType = kAudioUnitType_Output;
    outputcd.componentSubType = kAudioUnitSubType_RemoteIO;
    outputcd.componentManufacturer = kAudioUnitManufacturer_Apple;
    
    // Get the audio unit that matches the description
    AudioComponent comp = AudioComponentFindNext(NULL, &outputcd);
    if (comp == NULL) {
        NSLog(@"Failed to get output unit, exiting...");
        exit(-1);
    }
    CheckError(AudioComponentInstanceNew(comp, &audioPlayerData->outputUnit), "Couldn't open componenet for outputUnit");
    
    // Setup the callback function for the audio
    AURenderCallbackStruct input;
    input.inputProc = AudioCallbackFunction;
    input.inputProcRefCon = audioPlayerData; // Any data that needs to be passed to the function
    CheckError(AudioUnitSetProperty(audioPlayerData->outputUnit, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, 0, &input, sizeof(input)), "AudioUnitSetProperty failed");
    
    // Setup the audio unit stream format
    setupAdioUnitStreamFormat(&audioPlayerData->outputUnit);
    
    // Initialize the audio unit
    CheckError(AudioUnitInitialize(audioPlayerData->outputUnit), "AudioUnitInitialize failed");
    
    // Start playing
    CheckError(AudioOutputUnitStart(audioPlayerData->outputUnit), "Couldn't start output unit");
}

#pragma mark - Actions

- (void)playFrequency:(double)frequency {
    // Play the sine wave at the passed in frequency for 0.5 second
    audioPlayerData->frequency = frequency;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopPlaying) object:nil];
    [self performSelector:@selector(stopPlaying) withObject:nil afterDelay:0.5];
}
-(void)stopPlaying {
    audioPlayerData->frequency = 0;
}


#pragma mark - Callback Function

OSStatus AudioCallbackFunction(void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrame, AudioBufferList * ioData) {
    
    // Get the passed in audio data
    AudioPlayerData *player = (AudioPlayerData*)inRefCon;
    
    // Setup loop variables
    double j = player->startingFrameCount;
    double cycleLength = 44100.0 / player->frequency;
    
    // Loop through the frames and play the sine wave
    for (int frame = 0; frame < inNumberFrame; ++frame) {
        // Play the sine wave for the current frame
        Float32 *data = (Float32*)ioData->mBuffers[0].mData;
        (data)[frame] = (Float32)sin (2 * M_PI * (j / cycleLength));
        
        // Update loop variables
        j += 1.0;
        if (j > cycleLength)
            j -= cycleLength;
    }
    
    // Adjust the starting frame
    player->startingFrameCount = j;
    return noErr;
}

#pragma mark - Utility Functions
// Insert Listing 4.2 here

void setupAdioUnitStreamFormat(AudioUnit *outputUnit) {
    
    const int bytesPerFrame = 4; // 32 bit
    const int bitsPerByte = 8;
    const int sampleRate = 44100; // 44.1 kHz, the same as with CD audio
    
    AudioStreamBasicDescription streamFormat;
    memset(&streamFormat, 0, sizeof(streamFormat));
    streamFormat.mSampleRate = sampleRate;
    streamFormat.mFormatID = kAudioFormatLinearPCM;
    streamFormat.mFormatFlags = kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved;
    streamFormat.mBytesPerPacket = bytesPerFrame;
    streamFormat.mFramesPerPacket = 1;
    streamFormat.mBytesPerFrame = bytesPerFrame;
    streamFormat.mChannelsPerFrame = 1;
    streamFormat.mBitsPerChannel = bytesPerFrame * bitsPerByte; // 32 bit
    CheckError(AudioUnitSetProperty (*outputUnit,
                                     kAudioUnitProperty_StreamFormat,
                                     kAudioUnitScope_Input,
                                     0,
                                     &streamFormat,
                                     sizeof(AudioStreamBasicDescription)), "Big Error");
}


- (void)dealloc {
    // Remove the audio player
    AudioOutputUnitStop(audioPlayerData->outputUnit);
    AudioUnitUninitialize(audioPlayerData->outputUnit);
    AudioComponentInstanceDispose(audioPlayerData->outputUnit);
    free(audioPlayerData);
}

@end
