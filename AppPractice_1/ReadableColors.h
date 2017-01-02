//
//  ReadableColors.h
//  AppPractice_1
//
//  Created by cdu on 2016-08-03.
//  Copyright © 2016 Michael Dziuba. All rights reserved.
//

#ifndef ReadableColors_h
#define ReadableColors_h


#endif /* ReadableColors_h */

@interface ReadableColors : NSObject <NSCoding> {
    int textColorCode;
    int infoColorCode;
    int contrastCode;
    int sortCode;
    float seekBarPosition;
    int progress;
}

@property int textColorCode;
@property int infoColorCode;
@property int contrastCode;
@property int sortCode;
@property float seekBarPosition;
@property int progress;

- (id) init;
- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;

@end