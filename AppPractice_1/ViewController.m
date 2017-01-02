//
//  ViewController.m
//  AppPractice_1
//
//  Created by cdu on 2016-07-29.
//  Copyright © 2016 Michael Dziuba. All rights reserved.
//

#import "ViewController.h"
#import "ContrastFunctions.h"
#import "optionsViewController.h"
#import "ReadableColors.h"



CGRect screenSize;
float screenWidth;
float screenHeight;
UIApplication *statusBar;

CGFloat labelTextSize;
CGFloat colorLabelHeight;
CGFloat labelHeight;

static float HSVs[3];
static float RGBs[3];
static float arrayHSVColors[7400][4];
float contrastRatioNumber;

static float minContrastRatioNumber;  // valid values are 3.0, 4.5, and 7.0

int contrastCode;
int sortCode;

static float progressScaleFactor;
static int currentProgress;

float textR;
float textG;
float textB;

int sortCode1;
int sortCode2;
int sortCode3;
int sortCode4;

bool isFromOptionsViewController = false;

ReadableColors *readableColors;

NSData *dataToStore;

NSData *retrievedData;


@interface ViewController ()



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainNavHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewHeight;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorLabelsHeight;

@property (weak, nonatomic) IBOutlet UISlider *colorScanSlider;

@property (weak, nonatomic) IBOutlet UISegmentedControl *colorInfoSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *textColorSegmentedControl;

@end


@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    readableColors = [[ReadableColors alloc] init];
    
    retrievedData = [[NSUserDefaults standardUserDefaults] objectForKey:@"readableColors"];
    
    if(retrievedData == nil){
        readableColors.textColorCode = 1;
        readableColors.infoColorCode = 2;
        readableColors.contrastCode = 1;
        readableColors.sortCode = 1;
        readableColors.seekBarPosition = 0.0;
        readableColors.progress = 0;
        [self saveReadableColors];
      
    }else{
        readableColors = [self loadReadableColors];
    }
    
    if(isFromOptionsViewController){
        readableColors.contrastCode = (int)contrastCode;
        readableColors.sortCode = (int)sortCode;
    }else{
        contrastCode = readableColors.contrastCode;
        sortCode = readableColors.sortCode;
    }
    
    
    statusBar = [[[UIApplication sharedApplication] valueForKey: @"statusBarWindow"] valueForKey: @"statusBar"];
    ((UIView *) statusBar).backgroundColor = [UIColor colorWithRed:(float)240/255 green:(float)250/255 blue:(float)240/255 alpha:1.0];
    
    screenSize = [UIScreen mainScreen].bounds;
    screenWidth = screenSize.size.width;
    screenHeight = screenSize.size.height;
    
    if(screenWidth < screenHeight || screenWidth > 667.0) {
        _mainNavHeight.constant = 44;
    }else{
        _mainNavHeight.constant = 34;
    }
    
    if(screenHeight >= 667.0 && screenHeight < 736.0){
        _colorLabelsHeight.constant = (CGFloat)(screenHeight * 0.03);
        labelHeight = (CGFloat)(screenHeight * 0.03);
    }else if(screenHeight >= 736.0 && screenHeight < 1024.0){
        _colorLabelsHeight.constant = (CGFloat)(screenHeight * 0.031);
        labelHeight = (CGFloat)(screenHeight * 0.031);
    }else if(screenHeight >= 1024.0 && screenHeight < 1366.0){
        _colorLabelsHeight.constant = (CGFloat)(screenHeight * 0.035);
        labelHeight = (CGFloat)(screenHeight * 0.035);
    }else if(screenHeight >= 1366.0){
        _colorLabelsHeight.constant = (CGFloat)(screenHeight * 0.04);
        labelHeight = (CGFloat)(screenHeight * 0.04);
    }
    
    labelTextSize = labelHeight * 0.69;
    labelTextSize = labelTextSize > 11.5 ? labelTextSize : 11.5;
    [self formatColorLabels];
    
     _mainViewWidth.constant = screenWidth;
    if(screenHeight < 600.0){
        _mainViewHeight.constant = screenHeight + (600.0 - screenHeight);
    }else{
        _mainViewHeight.constant = screenHeight;
    }
    

    
    switch (readableColors.textColorCode) {
        case 0: textR = 255.0; textG = 255.0; textB = 255.0; break;
        case 1: textR = 0.0; textG = 0.0; textB = 0.0; break;
        default: break;
    }
    
    switch (readableColors.contrastCode) {
        case 0: minContrastRatioNumber = 3.0; break;
        case 1: minContrastRatioNumber = 4.5; break;
        case 2: minContrastRatioNumber = 7.0; break;
        default: break;
    }
    
    [_colorInfoSegmentedControl setSelectedSegmentIndex: readableColors.infoColorCode];
    [_textColorSegmentedControl setSelectedSegmentIndex: readableColors.textColorCode];
    
    
    
    [self recreateAllForNewSettings];
    
}



- (IBAction)colorScanSliderHandler:(UISlider *)sender {
    
    readableColors.progress = (int)round([sender value] * 100);
    readableColors.seekBarPosition = [sender value];
    [self saveReadableColors];
    currentProgress = (int)((float)readableColors.progress * progressScaleFactor);
    [self makeBackgroundColor: currentProgress];
    [self showInfoColor];
}


- (IBAction)colorInfoSegmentedControlHandler:(UISegmentedControl *)sender {
    readableColors.infoColorCode = (int)[sender selectedSegmentIndex];
    [self saveReadableColors];
    [self recreateAllForNewSettings];
}


- (IBAction)textColorSegmentedControlHandler:(UISegmentedControl *)sender {
    readableColors.textColorCode = (int)[sender selectedSegmentIndex];
    [self saveReadableColors];
    switch (readableColors.textColorCode) {
        case 0: textR = 255.0; textG = 255.0; textB = 255.0; break;
        case 1: textR = 0.0; textG = 0.0; textB = 0.0; break;
        default: break;
    }
    [self recreateAllForNewSettings];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL) prefersStatusBarHidden {
    return NO;
}



- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    screenWidth = size.width;
    screenHeight = size.height;
    
    if(screenWidth < screenHeight || screenWidth > 667.0) {
        _mainNavHeight.constant = 44;
    }else{
        _mainNavHeight.constant = 34;
    }
    
    _mainViewWidth.constant = screenWidth;
    if(screenHeight < 600.0){
        _mainViewHeight.constant = screenHeight + (600.0 - screenHeight);
    }else{
        _mainViewHeight.constant = screenHeight;
    }
    
    if(screenHeight >= 667.0 && screenHeight < 736.0){
        _colorLabelsHeight.constant = (CGFloat)(screenHeight * 0.03);
        labelHeight = (CGFloat)(screenHeight * 0.03);
    }else if(screenHeight >= 736.0 && screenHeight < 1024.0){
        _colorLabelsHeight.constant = (CGFloat)(screenHeight * 0.031);
        labelHeight = (CGFloat)(screenHeight * 0.031);
    }else if(screenHeight >= 1024.0 && screenHeight < 1366.0){
        _colorLabelsHeight.constant = (CGFloat)(screenHeight * 0.035);
        labelHeight = (CGFloat)(screenHeight * 0.035);
    }else if(screenHeight >= 1366.0){
        _colorLabelsHeight.constant = (CGFloat)(screenHeight * 0.04);
        labelHeight = (CGFloat)(screenHeight * 0.04);
    }
    
    labelTextSize = labelHeight * 0.65;
    labelTextSize = labelTextSize < 14 ? labelTextSize : 14;

    [self formatColorLabels];
    
}





- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier  isEqual: @"optionsViewController"]){
        optionsViewController *optViewController = (optionsViewController *) segue.destinationViewController;
        optViewController->contrastCode = (int) readableColors.contrastCode;
        optViewController->sortCode = (int) readableColors.sortCode;
    }
}



-(BOOL) shouldAutorotate{
    if((screenWidth < 768.0 || screenHeight < 768.0) && screenHeight > screenWidth) {
        return NO;
    }else{
        return YES;
    }
}



- (void) formatColorLabels {
    for (int i = 0; i < COLORS_DISPLAY; i++) {
        //((UILabel *) _labels[i]).layer.borderWidth = 1.0;
        //((UILabel *) _labels[i]).layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:(float)204/255 green:(float)204/255 blue:(float)204/255 alpha:1.0]);
        [((UILabel *)_labels[i]) setFont:[UIFont systemFontOfSize: labelTextSize]];
    }
}


- (void) makeBackgroundColor: (int) progress {
    for(int i = 0; i < COLORS_DISPLAY; i++ ){
        
        float h = arrayHSVColors[progress * COLORS_DISPLAY + i][0];
        float s = arrayHSVColors[progress * COLORS_DISPLAY + i][1];
        float v = arrayHSVColors[progress * COLORS_DISPLAY + i][2];
        
        [self hsvToRGB: (float) h : (float) s : (float) v];
        
        UIColor *color = [UIColor colorWithRed:RGBs[0]/255.0f
                         green:RGBs[1]/255.0f
                         blue:RGBs[2]/255.0f
                         alpha:1.0f];
        
        [_labels[i] setBackgroundColor: color];
    }
}



- (void) makeTextColor: (float) textR : (float) textG : (float) textB {
    for(int i = 0; i < COLORS_DISPLAY; i++ ){
        UIColor *color = [UIColor colorWithRed: textR / 255.0f
                                          green: textG / 255.0f
                                          blue: textB / 255.0f
                                          alpha:1.0f];
        
        [_labels[i] setTextColor: color];
    }
}




- (void) makeHexCode: (int) progress {
    NSString *hexNumber1;
    NSString *hexNumber2;
    NSString *hexNumber3;
    
    for(int i = 0; i < COLORS_DISPLAY; i++){
        float h = arrayHSVColors[progress * COLORS_DISPLAY + i][0];
        float s = arrayHSVColors[progress * COLORS_DISPLAY + i][1];
        float v = arrayHSVColors[progress * COLORS_DISPLAY + i][2];
        
        [self hsvToRGB: (float) h : (float) s : (float) v];
        
        hexNumber1 = [NSString stringWithFormat:@"%X", (int)RGBs[0]];
        hexNumber1 = [@"#" stringByAppendingString: ([hexNumber1 length] == 1 ? [NSString stringWithFormat: @"0%@", hexNumber1] : hexNumber1)];
        hexNumber2 = [NSString stringWithFormat:@"%X", (int)RGBs[1]];
        hexNumber2 = [hexNumber2 length] == 1 ? [NSString stringWithFormat: @"0%@", hexNumber2] : hexNumber2;
        hexNumber3 = [NSString stringWithFormat:@"%X", (int)RGBs[2]];
        hexNumber3 = [hexNumber3 length] == 1 ? [NSString stringWithFormat: @"0%@", hexNumber3] : hexNumber3;

        hexNumber1 = [NSString stringWithFormat:@"%@%@%@", hexNumber1, hexNumber2, hexNumber3];

        ((UILabel *)_labels[i]).text = hexNumber1;
    }
}


- (void) makeRGBCode: (int) progress {
    for(int i = 0; i < COLORS_DISPLAY; i++){
        float h = arrayHSVColors[progress * COLORS_DISPLAY + i][0];
        float s = arrayHSVColors[progress * COLORS_DISPLAY + i][1];
        float v = arrayHSVColors[progress * COLORS_DISPLAY + i][2];
        
        [self hsvToRGB: (float) h : (float) s : (float) v];
        
        NSString *rgbString = [NSString stringWithFormat:@"%d,%d,%d", (int)RGBs[0], (int)RGBs[1], (int)RGBs[2]];
        
        ((UILabel *)_labels[i]).text = rgbString;
    }
}


- (void) makeContrastRatio: (int) progress {
    
    for(int i = 0; i < COLORS_DISPLAY; i++){
        
        float h = arrayHSVColors[progress * COLORS_DISPLAY + i][0];
        float s = arrayHSVColors[progress * COLORS_DISPLAY + i][1];
        float v = arrayHSVColors[progress * COLORS_DISPLAY + i][2];
        
        [self hsvToRGB: (float) h : (float) s : (float) v];
    
        contrastRatioNumber = [ContrastFunctions contrastRatio:textR : textG : textB : RGBs[0] : RGBs[1] : RGBs[2]];
        
        ((UILabel *)_labels[i]).text = [NSString stringWithFormat:@"%.2f", contrastRatioNumber];
    }
}



- (void) showInfoColor {
    switch (readableColors.infoColorCode) {
        case 0: [self makeHexCode:currentProgress]; break;
        case 1: [self makeRGBCode:currentProgress]; break;
        case 2: [self makeContrastRatio:currentProgress]; break;
        default: break;
    }
}



- (void) setProgressScaleFactor {
    if(readableColors.textColorCode == 0 && minContrastRatioNumber == 3.0){
        progressScaleFactor = 0.70;
    }else if(readableColors.textColorCode == 1 && minContrastRatioNumber == 3.0){
        progressScaleFactor = 1.0;
    }else if(readableColors.textColorCode == 0 && minContrastRatioNumber == 4.5){
        progressScaleFactor = 0.44;
    }else if(readableColors.textColorCode == 1 && minContrastRatioNumber == 4.5){
        progressScaleFactor = 0.80;
    }else if(readableColors.textColorCode == 0 && minContrastRatioNumber == 7.0){
        progressScaleFactor = 0.23;
    }else if(readableColors.textColorCode == 1 && minContrastRatioNumber == 7.0){
        progressScaleFactor = 0.535;
    }else{
        progressScaleFactor = 1.0;
    }
    

}




- (void) recreateAllForNewSettings {
    [self makeColorArray];
    [self sortArray];
    [self setProgressScaleFactor];
    currentProgress = (int) ((float) readableColors.progress * progressScaleFactor);
    [_colorScanSlider setValue: readableColors.seekBarPosition animated: false];
    [self makeBackgroundColor: currentProgress];
    [self makeTextColor: textR :textG :textB];
    [self showInfoColor];
}



-(void) rgbToHSV:(int)r :(int)g :(int)b{
    
    float rFloat = (float)r / 255;
    float gFloat = (float)g / 255;
    float bFloat = (float)b / 255;
    
    float maximum = MAX(MAX(rFloat, gFloat), bFloat);
    float minimum = MIN(MIN(rFloat, gFloat), bFloat);
    //var h, s, v = max;
    
    float d = maximum - minimum;
    float h = 0;
    float s = (maximum == 0) ? 0 : d / maximum;
    float v = maximum;
    
    if(maximum == minimum){
        h = 0; // achromatic
    }else{
        
        if(maximum == rFloat){
            h = (gFloat - bFloat) / d + (gFloat < bFloat ? 6 : 0);
        }else if(maximum == gFloat){
            h = (bFloat - rFloat) / d + 2;
        }else if(maximum == bFloat){
            h = (rFloat - gFloat) / d + 4;
        }else{
            NSLog(@"Error in rgbToHSV");
        }

        h /= 6;
    }
    
    h *= 360;  // converts from % to degrees

    HSVs[0] = h;
    HSVs[1] = s;
    HSVs[2] = v;
}





-(void) hsvToRGB:(float)h :(float)s :(float)v{
    
    float hFloat = h / 360; //converts from degrees to %
    
    float r = 0;
    float g = 0;
    float b = 0;
    
    int i = floor(hFloat * 6);
    float f = hFloat * 6 - i;
    float p = v * (1 - s);
    float q = v * (1 - f * s);
    float t = v * (1 - (1 - f) * s);
    
    switch(i % 6){
        case 0: r = v; g = t; b = p; break;
        case 1: r = q; g = v; b = p; break;
        case 2: r = p; g = v; b = t; break;
        case 3: r = p; g = q; b = v; break;
        case 4: r = t; g = p; b = v; break;
        case 5: r = v; g = p; b = q; break;
        default: break;
    }
    
    
    RGBs[0] = roundf(r * 255);
    RGBs[1] = roundf(g * 255);
    RGBs[2] = roundf(b * 255);
}





-(void) makeColorArray{
    for(int i = 0; i < 7400; i++){
        for(int j = 0; j < 4; j++){
            arrayHSVColors[i][j] = 0.0;
        }
    }
    
   register int count = 0;
    
    for (int i = 0; i <= 255; i += 15){
        for (int j = 0; j <= 255; j += 5){
            for (int k = 0; k <= 255; k += 30){
        
                contrastRatioNumber = [ContrastFunctions contrastRatio: textR : textG : textB : (float)i : (float)j : (float)k];
                if(contrastRatioNumber >= minContrastRatioNumber){
                    
                    [self rgbToHSV: i : j : k];
                    arrayHSVColors[count][0] = HSVs[0];
                    arrayHSVColors[count][1] = HSVs[1];
                    arrayHSVColors[count][2] = HSVs[2];
                    arrayHSVColors[count][3] = contrastRatioNumber;
                    count += 1;
                }
            }
        }
    }
}



-(void) sortArray{
    switch (readableColors.sortCode) {
        case 0: sortCode1 = 0; sortCode2 = 2; sortCode3 = 1; sortCode4 = 3; break;
        case 1: sortCode1 = 1; sortCode2 = 2; sortCode3 = 0; sortCode4 = 3; break;
        case 2: sortCode1 = 2; sortCode2 = 1; sortCode3 = 0; sortCode4 = 3; break;
        case 3: sortCode1 = 3; sortCode2 = 1; sortCode3 = 2; sortCode4 = 0; break;
        default: break;
    }
    qsort(arrayHSVColors, 7400, (sizeof arrayHSVColors[0]), compare);
}



int compare (const void *a, const void *b) {
    
     if(((const float *)a)[sortCode1] < ((const float *)b)[sortCode1]){
         return 1;
     }else if(((const float *)a)[sortCode1] > ((const float *)b)[sortCode1]){
         return -1;
     }else if(((const float *)a)[sortCode2] < ((const float *)b)[sortCode2]){
         return 1;
     }else if(((const float *)a)[sortCode2] > ((const float *)b)[sortCode2]){
         return -1;
     }else if(((const float *)a)[sortCode3] < ((const float *)b)[sortCode3]){
         return 1;
     }else if(((const float *)a)[sortCode3] > ((const float *)b)[sortCode3]){
         return -1;
     }else if(((const float *)a)[sortCode4] < ((const float *)b)[sortCode4]){
         return 1;
     }else if(((const float *)a)[sortCode4] > ((const float *)b)[sortCode4]){
         return -1;
     }
    return 0;
}




- (void) saveReadableColors {
    dataToStore = [NSKeyedArchiver archivedDataWithRootObject: readableColors];
    [[NSUserDefaults standardUserDefaults] setObject:dataToStore forKey:@"readableColors"];
}


- (id) loadReadableColors {
    //retrievedData = [[NSUserDefaults standardUserDefaults] objectForKey:@"readableColors"];
    ReadableColors *readableColors = (ReadableColors *)[NSKeyedUnarchiver unarchiveObjectWithData: retrievedData];
    return readableColors;
}




@end





























