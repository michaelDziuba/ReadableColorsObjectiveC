//
//  ContrastFunctions.h
//  AppPractice_1
//
//  Created by cdu on 2016-07-29.
//  Copyright © 2016 Michael Dziuba. All rights reserved.
//

#ifndef ContrastFunctions_h
#define ContrastFunctions_h

#define RGB_THRESHOLD 0.03928
#define RGB_NUMERATOR_1 12.92
#define RGB_OFFSET 0.055
#define RGB_NUMERATOR_2 1.055
#define RGB_EXPONENT 2.4
#define R_FACTOR 0.2126
#define G_FACTOR 0.7152
#define B_FACTOR 0.0722
#define RGB_MAX 255.0



@interface ContrastFunctions: NSObject {
    
}



+(float) luminance: (float) valueR : (float) valueG : (float) valueB;

+(float) contrastRatio: (float) textR : (float) textG : (float) textB : (float) backgroundR : (float) backgroundG : (float) backgroundB;



@end

#endif /* ContrastFunctions_h */
