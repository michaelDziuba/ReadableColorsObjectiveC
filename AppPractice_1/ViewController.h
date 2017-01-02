//
//  ViewController.h
//  AppPractice_1
//
//  Created by cdu on 2016-07-29.
//  Copyright © 2016 Michael Dziuba. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COLORS_DISPLAY 68


@interface ViewController : UIViewController{
    @public long contrastCode;
    @public long sortCode;
    @public bool isFromOptionsViewController;
    
    
}


-(void) rgbToHSV: (int) r : (int) g : (int) b;

-(void) hsvToRGB: (float) h : (float) s : (float) v;
-(void) makeColorArray;

int compare (const void *a, const void *b);


-(void) sortArray;

- (void) makeBackgroundColor: (int) progress;
- (void) makeHexCode: (int) progress;
- (void) makeRGBCode: (int) progress;
- (void) makeContrastRatio: (int) progress;
- (void) makeTextColor: (float) textR : (float) textG : (float) textB;
- (void) showInfoColor;
- (void) setProgressScaleFactor;
- (void) recreateAllForNewSettings;

- (void) formatColorLabels;

- (void) saveReadableColors;
- (id) loadReadableColors;

@end

