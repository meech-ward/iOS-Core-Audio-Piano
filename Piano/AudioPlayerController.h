//
//  AudioPlayerController.h
//  Piano
//
//  Created by Sam Meech Ward on 2015-02-26.
//  Copyright (c) 2015 Sam Meech-Ward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@protocol AudioPlayerControllerDataSource;

@interface AudioPlayerController : NSObject

@property (weak, nonatomic) id <AudioPlayerControllerDataSource> dataSource;

@end

@protocol AudioPlayerControllerDataSource <NSObject>

- (Float32)audioControllerDataSourceNextFrame;

@end
