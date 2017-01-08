//
//  ViewController.m
//  Message Encoder
//
//  Created by Jack Palevich on 1/7/17.
//  Copyright © 2017 Jack Palevich. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
    NSLog(@"The Message Is %@", message);
}

@end
