//
//  ViewController.h
//  Message Encoder
//
//  Created by Jack Palevich on 1/7/17.
//  Copyright © 2017 Jack Palevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;

- (IBAction)messageEditingDidEnd:(UITextField *)sender;
- (IBAction)buttonWasPressed:(UIButton *)sender;


@end

