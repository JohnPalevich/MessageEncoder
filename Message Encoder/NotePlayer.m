//
//  NotePlayer.m
//  Message Encoder
//
//  Created by Jack Palevich on 1/8/17.
//  Copyright © 2017 Jack Palevich. All rights reserved.
//


#import "NotePlayer.h"
#import <AudioToolbox/AudioToolbox.h>
static const NSUInteger kFramesPerNote = 2048*4;
static const NSUInteger kAttackFrames = 128;
static const NSUInteger kDecayFrames = 128;
static const NSUInteger kDecayStartFrames = kFramesPerNote - kDecayFrames;
static const NSString * kStart = @"h";
static const NSString * kStop = @"i";

@implementation NotePlayer

{
    AudioUnit outputUnit;
    double renderPhase;
    NSString * _notes;
    NSUInteger _currentNote;
    NSUInteger _framesRemaining;
    double _phaseStep;
}

- (void)play:(NSString *) notes
{
    [self stopSound];
    _notes = [NSString stringWithFormat:@"%@%@%@%@",kStop,kStart,notes,kStop];
    [self startNote:0];
    
    
    //  First, we need to establish which Audio Unit we want.
    
    //  We start with its description, which is:
    AudioComponentDescription outputUnitDescription = {
        .componentType         = kAudioUnitType_Output,
        .componentSubType      = kAudioUnitSubType_RemoteIO,
        .componentManufacturer = kAudioUnitManufacturer_Apple
    };
    
    //  Next, we get the first (and only) component corresponding to that description
    AudioComponent outputComponent = AudioComponentFindNext(NULL, &outputUnitDescription);
    
    //  Now we can create an instance of that component, which will create an
    //  instance of the Audio Unit we're looking for (the default output)
    AudioComponentInstanceNew(outputComponent, &outputUnit);
    AudioUnitInitialize(outputUnit);
    
    //  Next we'll tell the output unit what format our generated audio will
    //  be in. Generally speaking, you'll want to stick to sane formats, since
    //  the output unit won't accept every single possible stream format.
    //  Here, we're specifying floating point samples with a sample rate of
    //  44100 Hz in mono (i.e. 1 channel)
    AudioStreamBasicDescription ASBD = {
        .mSampleRate       = 44100,
        .mFormatID         = kAudioFormatLinearPCM,
        .mFormatFlags      = kAudioFormatFlagsNativeFloatPacked,
        .mChannelsPerFrame = 1,
        .mFramesPerPacket  = 1,
        .mBitsPerChannel   = sizeof(Float32) * 8,
        .mBytesPerPacket   = sizeof(Float32),
        .mBytesPerFrame    = sizeof(Float32)
    };
    
    AudioUnitSetProperty(outputUnit,
                         kAudioUnitProperty_StreamFormat,
                         kAudioUnitScope_Input,
                         0,
                         &ASBD,
                         sizeof(ASBD));
    
    //  Next step is to tell our output unit which function we'd like it
    //  to call to get audio samples. We'll also pass in a context pointer,
    //  which can be a pointer to anything you need to maintain state between
    //  render callbacks. We only need to point to a double which represents
    //  the current phase of the sine wave we're creating.
    AURenderCallbackStruct callbackInfo = {
        .inputProc       = SineWaveRenderCallback,
        .inputProcRefCon = (__bridge void *)self
    };
    
    AudioUnitSetProperty(outputUnit,
                         kAudioUnitProperty_SetRenderCallback,
                         kAudioUnitScope_Global,
                         0,
                         &callbackInfo,
                         sizeof(callbackInfo));
    
    //  Here we're telling the output unit to start requesting audio samples
    //  from our render callback. This is the line of code that starts actually
    //  sending audio to your speakers.
    AudioOutputUnitStart(outputUnit);
}

// This is our render callback. It will be called very frequently for short
// buffers of audio (512 samples per call on my machine).
OSStatus SineWaveRenderCallback(void * inRefCon,
                                AudioUnitRenderActionFlags * ioActionFlags,
                                const AudioTimeStamp * inTimeStamp,
                                UInt32 inBusNumber,
                                UInt32 inNumberFrames,
                                AudioBufferList * ioData)
{
    __unsafe_unretained NotePlayer * THIS = (__bridge NotePlayer *)inRefCon;
    // inRefCon is the context pointer we passed in earlier when setting the render callback
    double currentPhase = THIS->renderPhase;
    // ioData is where we're supposed to put the audio samples we've created
    Float32 * outputBuffer = (Float32 *)ioData->mBuffers[0].mData;
    memset(outputBuffer, 0, ioData->mBuffers[0].mDataByteSize);
    NSUInteger framesToMix = inNumberFrames;
    int j = 0;
    for(;;){
        if(THIS->_phaseStep == 0)
        {
            break;
        }
        NSUInteger framesMixed = MIN(framesToMix, THIS->_framesRemaining);
        
        NSUInteger baseFrame = kFramesPerNote - THIS -> _framesRemaining;
        for(int i = 0; i < framesMixed; i++) {
            outputBuffer[j] = sin(fmod(currentPhase, M_PI * 2))*0.5;
            currentPhase += THIS->_phaseStep;
            NSUInteger currentFrame = baseFrame + i;
            
            if(currentFrame <= kAttackFrames)
            {
                float scaleFactor = (float) currentFrame / kAttackFrames;
                outputBuffer [j] *= scaleFactor;
            }
            else if(currentFrame >= kDecayStartFrames)
            {
                
                NSUInteger decayFrame = kFramesPerNote - currentFrame - 1;
                float scaleFactor = (float) decayFrame / kDecayFrames;
                outputBuffer [j] *= scaleFactor;
            }
            // NSLog(@"%u %d %g" , currentFrame, j, outputBuffer[j]);
            j ++;
        }
        THIS->_framesRemaining -= framesMixed;
        framesToMix -= framesMixed;
        if(THIS->_framesRemaining ==0)
        {
            [THIS startNote:THIS -> _currentNote + 1];
        }
        else
        {
            break;
        }
    }
    // writing the current phase back to inRefCon so we can use it on the next call
    THIS->renderPhase = currentPhase;
    return noErr;
}

- (void)stopSound
{
    if (outputUnit) {
        AudioOutputUnitStop(outputUnit);
        AudioUnitUninitialize(outputUnit);
        AudioComponentInstanceDispose(outputUnit);
        outputUnit = nil;
    }
}

- (void)startNote:(NSUInteger) placeInString
{
    _framesRemaining = kFramesPerNote;
    _currentNote = placeInString;
    if(_currentNote >= _notes.length)
    {
        _phaseStep = 0;
        _framesRemaining = 0;
        return;
    }
    char note = [_notes characterAtIndex:_currentNote];
    static const double noteFrequencies [] = {
        440.00, 493.88, 261.63, 293.66, 329.63, 349.23, 392.00, 880.0, 987.76
    };
    double frequency;
    if(note == ' ')
    {
        frequency  = 783.99;
    }
    else
    {
        frequency = noteFrequencies[note-'a'];
    }
    frequency *= 2;//raise everything 1 octave
    _phaseStep = (frequency / 44100.) * (M_PI * 2.)* 4;
}

@end
