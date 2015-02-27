//
//  AudioPlayerController.m
//  Piano
//
//  Created by Sam Meech Ward on 2015-02-26.
//  Copyright (c) 2015 Sam Meech-Ward. All rights reserved.
//

#import "AudioPlayerController.h"

#import "CoreAudioUtility.h"

@implementation AudioPlayerController {
    AudioUnit outputUnit;
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
    CheckError(AudioComponentInstanceNew(comp, &outputUnit), "Couldn't open componenet for outputUnit");
    
    // Setup the callback function for the audio
    AURenderCallbackStruct input;
    input.inputProc = AudioCallbackFunction;
    input.inputProcRefCon = (__bridge void *)self; // Any data that needs to be passed to the function
    CheckError(AudioUnitSetProperty(outputUnit, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, 0, &input, sizeof(input)), "AudioUnitSetProperty failed");
    
    // Setup the audio unit stream format
    setupAdioUnitStreamFormat(&outputUnit);
    
    // Initialize the audio unit
    CheckError(AudioUnitInitialize(outputUnit), "AudioUnitInitialize failed");
    
    // Start playing
    CheckError(AudioOutputUnitStart(outputUnit), "Couldn't start output unit");
}

#pragma mark - Callback Function

OSStatus AudioCallbackFunction(void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrame, AudioBufferList * ioData) {
    
    // Get the passed in audio data
    AudioPlayerController *controller = (__bridge AudioPlayerController*)inRefCon;
    
    // Loop through the frames
    for (int frame = 0; frame < inNumberFrame; ++frame) {
        // Play the data source audio
        ((Float32 *)ioData->mBuffers[0].mData)[frame] =
        [controller.dataSource audioControllerDataSourceNextFrame];
    }
    return noErr;
}

#pragma mark - Utility Functions

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
    AudioOutputUnitStop(outputUnit);
    AudioUnitUninitialize(outputUnit);
    AudioComponentInstanceDispose(outputUnit);
}

@end
