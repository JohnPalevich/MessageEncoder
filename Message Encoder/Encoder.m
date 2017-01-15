//
//  Encoder.m
//  Message Encoder
//
//  Created by Jack Palevich on 1/7/17.
//  Copyright © 2017 Jack Palevich. All rights reserved.
//

#import "Encoder.h"

@implementation Encoder {
    NSDictionary *_charMap;
}

- (id) init
{
    self=[super init];
    if (self) {
        _charMap = @{@"A":@"ab",
                     @"B":@"ac",
                     @"C":@"ad",
                     @"D":@"ae",
                     @"E":@"af",
                     @"F":@"ag",
                     @"G":@"ba",
                     @"H":@"bc",
                     @"I":@"bd",
                     @"J":@"be",
                     @"K":@"bf",
                     @"L":@"bg",
                     @"M":@"ca",
                     @"N":@"cb",
                     @"O":@"cd",
                     @"P":@"ce",
                     @"Q":@"cf",
                     @"R":@"cg",
                     @"S":@"da",
                     @"T":@"db",
                     @"U":@"dc",
                     @"V":@"de",
                     @"W":@"df",
                     @"X":@"dg",
                     @"Y":@"ea",
                     @"Z":@"eb",
                     @" ":@"ec",
                     @".":@"ed",
                     @",":@"ef",
                     @"!":@"eg",
                     @"?":@"fa",
                     @"*":@"fb",
                     };
    }
    return self;
}

- (NSString *)encodeMessage:(NSString *)message
{
    NSMutableString * encodedMessage = [[NSMutableString alloc] init];
    
    NSUInteger messageLength = message.length;
    for(NSUInteger i = 0; i < messageLength; i++)
    {
        NSString * letter = [message substringWithRange: NSMakeRange(i, 1)];
        NSString * uppercasedLetter = [letter uppercaseString];
        NSString * encodedLetter = _charMap [uppercasedLetter];
        if(!encodedLetter)
        {
            encodedLetter = _charMap[@"*"];
        }
        [encodedMessage appendString:@" "];
        [encodedMessage appendString:encodedLetter];
    }
    return  encodedMessage;
}


@end
