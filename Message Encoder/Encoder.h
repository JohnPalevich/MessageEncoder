//
//  Encoder.h
//  Message Encoder
//
//  Created by Jack Palevich on 1/7/17.
//  Copyright © 2017 Jack Palevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Encoder : NSObject
- (NSString *)encodeMessage:(NSString *)message;
- (NSString *)decodeMessage:(NSString *)message;

@end
