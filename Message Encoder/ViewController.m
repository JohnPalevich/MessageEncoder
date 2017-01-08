//
//  ViewController.m
//  Message Encoder
//
//  Created by Jack Palevich on 1/7/17.
//  Copyright © 2017 Jack Palevich. All rights reserved.
//

#import "ViewController.h"
#import "Encoder.h"
#import "NotePlayer.h"

@interface ViewController ()

@end

@implementation ViewController {
    Encoder * _encoder;
    NotePlayer * _notePlayer;
}

- (void)viewDidLoad {
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


@end
