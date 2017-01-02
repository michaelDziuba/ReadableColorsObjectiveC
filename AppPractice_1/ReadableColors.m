//
//  ReadableColors.m
//  AppPractice_1
//
//  Created by cdu on 2016-08-03.
//  Copyright © 2016 Michael Dziuba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadableColors.h"

@implementation ReadableColors: NSObject

@synthesize textColorCode;
@synthesize infoColorCode;
@synthesize contrastCode;
@synthesize sortCode;
@synthesize seekBarPosition;
@synthesize progress;



- (id) init {
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInteger:textColorCode forKey:@"textColorCode"];
    [encoder encodeInteger:infoColorCode forKey:@"infoColorCode"];
    [encoder encodeInteger:contrastCode forKey:@"contrastCode"];
    [encoder encodeInteger:sortCode forKey:@"sortCode"];
    [encoder encodeFloat:seekBarPosition forKey:@"seekBarPosition"];
    [encoder encodeInteger:progress forKey:@"progress"];
}


- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [self init]) {
        self.textColorCode = (int)[decoder decodeIntegerForKey:@"textColorCode"];
        self.infoColorCode = (int)[decoder decodeIntegerForKey:@"infoColorCode"];
        self.contrastCode = (int)[decoder decodeIntegerForKey:@"contrastCode"];
        self.sortCode = (int)[decoder decodeIntegerForKey:@"sortCode"];
        self.seekBarPosition = (float) [decoder decodeFloatForKey:@"seekBarPosition"];
        self.progress = (float) [decoder decodeIntegerForKey:@"progress"];
    }
    return self;
}


@end