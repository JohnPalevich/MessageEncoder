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
        _charMap = @{@"A":@"cd",
                     @"B":@"ce",
                     @"C":@"cf",
                     @"D":@"cg",
                     @"E":@"ca",
                     @"F":@"cb",
                     @"G":@"dc",
                     @"H":@"de",
                     @"I":@"df",
                     @"J":@"dg",
                     @"K":@"da",
                     @"L":@"db",
                     @"M":@"ec",
                     @"N":@"ed",
                     @"O":@"ef",
                     @"P":@"eg",
                     @"Q":@"ea",
                     @"R":@"eb",
                     @"S":@"fc",
                     @"T":@"fd",
                     @"U":@"fe",
                     @"V":@"fg",
                     @"W":@"fa",
                     @"X":@"fb",
                     @"Y":@"gc",
                     @"Z":@"gd",
                     @" ":@"ge",
                     @".":@"gf",
                     @",":@"ga",
                     @"!":@"gb",
                     @"?":@"ac",
                     @"*":@"ad",
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
        [encodedMessage appendString:@" "];
    }
    return  encodedMessage;
}


@end
