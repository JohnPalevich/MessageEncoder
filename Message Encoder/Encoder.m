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
        _charMap = @{@"A":@"aa",
                     @"B":@"ab",
                     @"C":@"ac",
                     @"D":@"ad",
                     @"E":@"ae",
                     @"F":@"af",
                     @"G":@"ag",
                     @"H":@"ba",
                     @"I":@"bb",
                     @"J":@"bc",
                     @"K":@"bd",
                     @"L":@"be",
                     @"M":@"bf",
                     @"N":@"bg",
                     @"O":@"ca",
                     @"P":@"cb",
                     @"Q":@"cc",
                     @"R":@"cd",
                     @"S":@"ce",
                     @"T":@"cf",
                     @"U":@"cg",
                     @"V":@"da",
                     @"W":@"db",
                     @"X":@"dc",
                     @"Y":@"dd",
                     @"Z":@"de",
                     @"1":@"df",
                     @"2":@"dg",
                     @"3":@"ea",
                     @"4":@"eb",
                     @"5":@"ec",
                     @"6":@"ed",
                     @"7":@"ee",
                     @"8":@"ef",
                     @"9":@"eg",
                     @"0":@"fa",
                     @" ":@"fb",
                     @".":@"fc",
                     @",":@"fd",
                     @"!":@"fe",
                     @"?":@"ff",
                     @"*":@"fg",
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
        [encodedMessage appendString:encodedLetter];
    }
    return encodedMessage;
}


@end
