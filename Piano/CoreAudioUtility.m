//
//  CoreAudioUtility.m
//  Piano
//
//  Created by Sam Meech Ward on 2015-02-26.
//  Copyright (c) 2015 Sam Meech-Ward. All rights reserved.
//

#import "CoreAudioUtility.h"

@implementation CoreAudioUtility

void CheckError (OSStatus error, const char *operation) {
    //if there is no error, do nothing and return
    if (error == noErr) { return; }
    
    char errorString[20];
    // See if the error apears to be a 4-char-code
    *(UInt32 *)(errorString + 1) = CFSwapInt32HostToBig(error);
    if (isprint(errorString[1]) && isprint(errorString[2]) && isprint(errorString[3]) && isprint(errorString[4])) {
        errorString[0] = errorString[5] = '\'';
        // '\0' is the ASCII NUL null character (ASCII code zero).
        errorString[6] = '\0';
    } else {
        // No, format it as an integer
        sprintf(errorString, "%d", (int)error);
    }
    
    // Print the error and exit
    fprintf(stderr, "Error: %s (%s)\n", operation, errorString);
    exit(1);
}

@end
