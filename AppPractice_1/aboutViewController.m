//
//  aboutViewController.m
//  AppPractice_1
//
//  Created by cdu on 2016-08-02.
//  Copyright © 2016 Michael Dziuba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "aboutViewController.h"

extern CGRect screenSize;
extern float screenWidth;
extern float screenHeight;
extern float labelTextSize;

@interface aboutViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navBarHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aboutViewWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aboutViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *aboutTextLabel;



@end



@implementation aboutViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    screenSize = [UIScreen mainScreen].bounds;
    screenWidth = screenSize.size.width;
    screenHeight = screenSize.size.height;
    
    if(screenWidth < screenHeight || screenWidth > 667.0) {
        _navBarHeight.constant = 44;
    }else{
        _navBarHeight.constant = 34;
    }
    
    _aboutViewWidth.constant = screenWidth;
    
    if(screenHeight < 600.0){
        _aboutViewHeight.constant = screenHeight + (600.0 - screenHeight);
    }else{
        _aboutViewHeight.constant = screenHeight;
    }
    labelTextSize = screenHeight * 0.02;
    labelTextSize = labelTextSize > 14.0 ? labelTextSize : 14.0;
    
    [_aboutTextLabel setFont:[UIFont boldSystemFontOfSize: labelTextSize]];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)webLink1:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:@"https://www.w3.org/TR/2008/REC-WCAG20-20081211/#visual-audio-contrast" ];
    if(url){
        [[UIApplication sharedApplication] openURL:url];
    }
}


- (IBAction)webLink2:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:@"https://www.w3.org/TR/WCAG20-TECHS/G17.html" ];
    if(url){
        [[UIApplication sharedApplication] openURL:url];
    }
}






- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    screenWidth = size.width;
    screenHeight = size.height;
    
    if(screenWidth < screenHeight || screenWidth > 667.0) {
        _navBarHeight.constant = 44;
    }else{
        _navBarHeight.constant = 34;
    }
    
    _aboutViewWidth.constant = screenWidth;
    if(screenHeight < 600.0){
        _aboutViewHeight.constant = screenHeight + (600.0 - screenHeight);
    }else{
        _aboutViewHeight.constant = screenHeight;
    }
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}

-(BOOL) shouldAutorotate{
    if((screenWidth < 768.0 || screenHeight < 768.0) && screenHeight > screenWidth) {
        return NO;
    }else{
        return YES;
    }
}


@end
