//
//  SurveyViewController.h
//  Car Show
//
//  Created by 5adian on 15/3/9.
//  Copyright (c) 2015年 Adam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagedFlowView.h"
#import "RootViewController.h"

@interface SurveyViewController : RootViewController

@property (weak, nonatomic) IBOutlet UIImageView *homeBGView;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIImageView *carPromptImg;

@property (weak, nonatomic) IBOutlet UIView *carBGView;

@property (weak, nonatomic) IBOutlet UIScrollView *carTypeScrollView;

@property (weak, nonatomic) IBOutlet UIScrollView *carTypeMenuScrollView;

// history
@property (weak, nonatomic) IBOutlet UIView *historyBGView;

@property (weak, nonatomic) IBOutlet UIImageView *fordCompanyImg;
@property (weak, nonatomic) IBOutlet UIView *fordHistoryView;

@property (nonatomic, retain) IBOutlet PagedFlowView *historyFlowView;
@property (nonatomic, retain) IBOutlet UIPageControl *historyPageControl;
@property (weak, nonatomic) IBOutlet UILabel *historyTitle;
@property (weak, nonatomic) IBOutlet UILabel *historyDesc;

@property (weak, nonatomic) IBOutlet UIButton *historyType1;
@property (weak, nonatomic) IBOutlet UIButton *historyType2;


@property (weak, nonatomic) IBOutlet UIButton *btnSurvey;
@property (weak, nonatomic) IBOutlet UIButton *btnCarType;
@property (weak, nonatomic) IBOutlet UIButton *btnHistory;

- (IBAction)pageControlValueDidChange:(id)sender;

@end

