//
//  ViewController.m
//  Message Encoder
//
//  Created by Jack Palevich on 1/7/17.
//  Copyright © 2017 Jack Palevich. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"
#import "Encoder.h"
#import "NotePlayer.h"
#import "mo_audio.h"



@interface ViewController ()

@end

@implementation ViewController {
    Encoder * _encoder;
    NotePlayer * _notePlayer;
}

- (void)viewDidLoad {
    [AVAudioSession sharedInstance];
    BOOL activated = [[AVAudioSession sharedInstance] setActive:YES error:NULL];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:NULL];
    // [self initMomuAudio];
    [super viewDidLoad];
    _encoder = [[Encoder alloc] init];
    _notePlayer = [[NotePlayer alloc] init];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)messageEditingDidEnd:(UITextField *)sender {
    [self sendMessage:_messageTextField.text];
}

- (IBAction)buttonWasPressed:(UIButton *)sender {
    [self sendMessage:_messageTextField.text];
}

- (void)sendMessage:(NSString *)message {
    NSString * encodedMessage = [_encoder encodeMessage:message];
    NSLog(@"The Message Is %@", message);
    NSLog(@"The Encoded Message Is %@", encodedMessage);
    [_notePlayer play:encodedMessage];
}

-(void) initMomuAudio {
    const int SAMPLE_RATE = 44100;  //22050 //44100
    const int FRAMESIZE = 512;
    const int NUMCHANNELS = 2;
    bool result = false;
    result = MoAudio::init( SAMPLE_RATE, FRAMESIZE, NUMCHANNELS, false);
    if (!result) { NSLog(@" MoAudio init ERROR"); }
    result = MoAudio::start( NULL, NULL );
    if (!result) { NSLog(@" MoAudio start ERROR"); }
}


@end
