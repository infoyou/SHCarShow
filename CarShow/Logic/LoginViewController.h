//
//  LoginViewController.m
//  Car Show
//
//  Created by Adam on 15/3/11.
//  Copyright (c) 2015年 Adam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface LoginViewController : RootViewController

@property (weak, nonatomic) IBOutlet UIView *pickerBG;
@property (weak, nonatomic) IBOutlet UIPickerView *activityPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *cityPicker;

@property (weak, nonatomic) IBOutlet UITextField *nameTxt;
@property (weak, nonatomic) IBOutlet UITextField *pswdTxt;

@property (weak, nonatomic) IBOutlet UITextField *activityTxt;
@property (weak, nonatomic) IBOutlet UITextField *cityTxt;

@end

