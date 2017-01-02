//
//  optionsViewController.m
//  AppPractice_1
//
//  Created by cdu on 2016-08-02.
//  Copyright © 2016 Michael Dziuba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "optionsViewController.h"
#import "ViewController.h"

extern CGRect screenSize;
extern float screenWidth;
extern float screenHeight;

extern int contrastCode;
extern int sortCode;
extern bool isFromOptionsViewController;

@interface optionsViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navBarHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionsViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionsViewHeight;

@property (weak, nonatomic) IBOutlet UISegmentedControl *contrastSegmentedControl;

@property (weak, nonatomic) IBOutlet UISegmentedControl *sortSegmentedControl;


@end



@implementation optionsViewController


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
    
    _optionsViewWidth.constant = screenWidth;
    
    if(screenHeight < 400.0){
        _optionsViewHeight.constant = screenHeight + (400.0 - screenHeight);
    }else{
        _optionsViewHeight.constant = screenHeight;
    }
    
    [_contrastSegmentedControl setSelectedSegmentIndex:contrastCode];
    [_sortSegmentedControl setSelectedSegmentIndex:sortCode];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    _optionsViewWidth.constant = screenWidth;
    if(screenHeight < 600.0){
        _optionsViewHeight.constant = screenHeight + (600.0 - screenHeight);
    }else{
        _optionsViewHeight.constant = screenHeight;
    }
}



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ViewController *mainViewController = (ViewController *) segue.destinationViewController;
    mainViewController->contrastCode = contrastCode;
    mainViewController->sortCode = sortCode;
    mainViewController->isFromOptionsViewController = true;
}





-(BOOL) shouldAutorotate{
    if((screenWidth < 768.0 || screenHeight < 768.0) && screenHeight > screenWidth) {
        return NO;
    }else{
        return YES;
    }
}


- (IBAction)minimumContrastSegmentedControl:(UISegmentedControl *)sender {
    contrastCode = (int)sender.selectedSegmentIndex;
}




- (IBAction)sortBySegmentedControl:(UISegmentedControl *)sender {
    sortCode = (int)sender.selectedSegmentIndex;
}





@end