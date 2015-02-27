//
//  ViewController.h
//  Piano
//
//  Created by Sam Meech-Ward on 2014-12-08.
//  Copyright (c) 2014 Sam Meech-Ward. All rights reserved.
//

// Piano
#import "PianoView.h"

// Audio
#import "AudioInstrumentController.h"

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <PianoViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet PianoView *pianoView;

@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (strong, nonatomic) AudioInstrumentController *instrumentController;

- (IBAction)sliderValueChanged:(id)sender;

@end

