//
//  ContrastFunctions.m
//  AppPractice_1
//
//  Created by cdu on 2016-07-29.
//  Copyright © 2016 Michael Dziuba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContrastFunctions.h"




@implementation ContrastFunctions



+(float) luminance:(float)valueR :(float)valueG :(float)valueB{
    
    float sRBG_R  = valueR / RGB_MAX;
    float sRGB_R_base = (sRBG_R  + RGB_OFFSET) / RGB_NUMERATOR_2;
    float sRBG_G = valueG / RGB_MAX;
    float sRGB_G_base = (sRBG_G + RGB_OFFSET) / RGB_NUMERATOR_2;
    float sRBG_B = valueB / RGB_MAX;
    float sRGB_B_base = (sRBG_B + RGB_OFFSET) / RGB_NUMERATOR_2;
    
    float R = sRBG_R <= RGB_THRESHOLD ? sRBG_R / RGB_NUMERATOR_1 : pow(sRGB_R_base, RGB_EXPONENT);
    float G = sRBG_G <= RGB_THRESHOLD ? sRBG_G / RGB_NUMERATOR_1 : pow(sRGB_G_base, RGB_EXPONENT);
    float B = sRBG_B <= RGB_THRESHOLD ? sRBG_B / RGB_NUMERATOR_1 : pow(sRGB_B_base, RGB_EXPONENT);
    
    float luminance = R_FACTOR * R + G_FACTOR * G + B_FACTOR * B;
    
    return luminance;
}



+(float) contrastRatio:(float)textR :(float)textG :(float)textB :(float)backgroundR :(float)backgroundG :(float)backgroundB{

    float valueR = backgroundR;
    float valueG = backgroundG;
    float valueB = backgroundB;
    
    float contrastRatio = ([ContrastFunctions luminance: textR : textG : textB] + 0.05) / ( [ContrastFunctions luminance: valueR : valueG : valueB] + 0.05);
    
    contrastRatio = contrastRatio < 1 ? 1 / contrastRatio : contrastRatio;

    return contrastRatio;
}



@end


















