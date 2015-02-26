//
//  CoreAudioUtility.h
//  Piano
//
//  Created by Sam Meech Ward on 2015-02-26.
//  Copyright (c) 2015 Sam Meech-Ward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreAudioUtility : NSObject

void CheckError (OSStatus error, const char *operation);

@end
