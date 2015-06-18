//
//  SurveyViewController.m
//  Car Show
//
//  Created by 5adian on 15/3/9.
//  Copyright (c) 2015年 Adam. All rights reserved.
//

#import "SurveyViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppManager.h"

@interface SurveyViewController () <UIWebViewDelegate, PagedFlowViewDelegate, PagedFlowViewDataSource>
{
    
    // car
    NSArray *carTypeArray;
    NSInteger menuTypeNum;
    
    // history
    NSArray *historyImageArray;
    NSArray *historyNameArray;
    NSArray *historyTitleArray;
    NSArray *historyDescArray;
    
}

@end

@implementation SurveyViewController
{
    BOOL isFirstTapCarMenu;
}

@synthesize homeBGView;

// survey
@synthesize webView;

// car
@synthesize carBGView;
@synthesize carPromptImg;
@synthesize carTypeScrollView;
@synthesize carTypeMenuScrollView;

// history
@synthesize historyBGView;
@synthesize fordCompanyImg;
@synthesize fordHistoryView;
@synthesize historyType1;
@synthesize historyType2;
@synthesize historyTitle;
@synthesize historyDesc;
@synthesize historyFlowView;
@synthesize historyPageControl;

@synthesize btnSurvey;
@synthesize btnCarType;
@synthesize btnHistory;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isFirstTapCarMenu = NO;
    
    homeBGView.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view, typically from a nib.
    // load Survey
    NSString *urlAddress = [[NSBundle mainBundle] pathForResource:SURVEY_HTML_NAME ofType:@"html"];
    
    NSURL *url = [NSURL fileURLWithPath:urlAddress];
    NSURLRequest *requestObjc = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObjc];
//    webView.frame = CGRectMake(23, 78, 978, 600);
    
    // load
    [self loadCarType];
    
    [self loadHistory];
    
    [self goSurvey:nil];
}


#pragma mark - Common Method
- (UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

#pragma mark - Home
- (IBAction)goSurvey:(id)sender
{
    // 主背景
    homeBGView.image = [UIImage imageNamed:@"body_bg9.png"];
    
    // 修改按钮状态
    UIImage *btnImageSel = [UIImage imageNamed:@"itemBtnSel.png"];
    [btnSurvey setBackgroundImage:btnImageSel forState:UIControlStateNormal];
    
    UIImage *btnImage = [UIImage imageNamed:@"itemBtn.png"];
    [btnCarType setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btnHistory setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    webView.hidden = NO;
    carBGView.hidden = YES;
    historyBGView.hidden = YES;
}

- (IBAction)goCarType:(id)sender
{
    // 主背景
    homeBGView.image = [UIImage imageNamed:@"car_bg.png"];
    
    // 加载资源
//    [self loadCarType];
    
    // 修改按钮状态
    UIImage *btnImageSel = [UIImage imageNamed:@"itemBtnSel.png"];
    [btnCarType setBackgroundImage:btnImageSel forState:UIControlStateNormal];
    
    UIImage *btnImage = [UIImage imageNamed:@"itemBtn.png"];
    [btnSurvey setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btnHistory setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    if (!isFirstTapCarMenu) {
    
        carPromptImg.hidden = NO;
        isFirstTapCarMenu = YES;
    }
    
    carBGView.hidden = NO;
    historyBGView.hidden = YES;
    webView.hidden = YES;
    
}

- (IBAction)goHistory:(id)sender
{
    // 主背景
    homeBGView.image = [UIImage imageNamed:@"company_bg.png"];
    
    // 加载资源
//    [self loadHistory];
    
    // 修改按钮状态
    UIImage *btnImageSel = [UIImage imageNamed:@"itemBtnSel.png"];
    [btnHistory setBackgroundImage:btnImageSel forState:UIControlStateNormal];
    
    UIImage *btnImage = [UIImage imageNamed:@"itemBtn.png"];
    [btnCarType setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btnSurvey setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    historyBGView.hidden = NO;
    webView.hidden = YES;
    carBGView.hidden = YES;
}

#pragma mark
#pragma mark - Car Type

- (void)loadCarType
{
    // @"福特麦柯斯S-MAX", @"福特锐界",
    carTypeArray = @[@"福特嘉年华", @"福特经典福克斯", @"福特福睿斯", @"福特新福克斯", @"福特致胜",
                     @"福特翼搏", @"福特翼虎", @"福特新蒙迪欧", @"福特探险者", @"福特福克斯ST", @"福特嘉年华ST"];
    
    menuTypeNum = [carTypeArray count];
    carTypeMenuScrollView.pagingEnabled = NO;
    carTypeMenuScrollView.scrollEnabled = YES;
    carTypeMenuScrollView.showsHorizontalScrollIndicator = YES;
    carTypeMenuScrollView.showsVerticalScrollIndicator = NO;
    carTypeMenuScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    carTypeMenuScrollView.contentSize = CGSizeMake(114 * [carTypeArray count], 44);
    
    for (int i=0; i<menuTypeNum; i++) {
        
        UIButton *btnMenu = [UIButton buttonWithType:UIButtonTypeCustom];
        btnMenu.frame = CGRectMake(114*i, 0, 114, 44);
        [btnMenu setTitle:carTypeArray[i] forState:UIControlStateNormal];
        [btnMenu setTintColor:[self colorWithHexString:@"868686"]];
        
        [btnMenu.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        
        UIImage *btnImage = [UIImage imageNamed:@"typeBtn.png"];
        [btnMenu setBackgroundImage:btnImage forState:UIControlStateNormal];
        
        btnMenu.tag = 2000 + i*10;
        [btnMenu addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        
        [carTypeMenuScrollView addSubview:btnMenu];
    }
    
}

- (void)buttonPress:(id)sender
{
    UIButton *btnSelMenu = (UIButton *)sender;
    NSInteger tag = (btnSelMenu.tag - 2000)/10;
    
    for (int i=0; i<menuTypeNum; i++) {
        
        if (i != tag) {
            
            UIButton *btnMenu = (UIButton *)[carTypeMenuScrollView viewWithTag:(2000 + i*10)];
            UIImage *btnImage = [UIImage imageNamed:@"typeBtn.png"];
            [btnMenu setBackgroundImage:btnImage forState:UIControlStateNormal];
        }
    }
    
    UIImage *btnImageSel = [UIImage imageNamed:@"typeBtnSel.png"];
    [btnSelMenu setBackgroundImage:btnImageSel forState:UIControlStateNormal];
    
    NSLog(@"tag = %ld", tag);
    
    carPromptImg.hidden = YES;
    // 清除
    NSArray *viewsToRemove = [carTypeScrollView subviews];
    for (UIView *v in viewsToRemove)
        [v removeFromSuperview];
    
    if (tag == 0 || tag == 1 || tag == 3) {
        
        [self showCarType:2 offsetVal:(2000 + tag*10)];
    } else {
        [self showCarType:1 offsetVal:(2000 + tag*10)];
    }
}

- (void)showCarType:(NSInteger)carTypeNum offsetVal:(NSInteger)offsetVal
{
    
    // car type
    carTypeScrollView.pagingEnabled = NO;
    carTypeScrollView.scrollEnabled = YES;
    carTypeScrollView.showsHorizontalScrollIndicator = YES;
    carTypeScrollView.showsVerticalScrollIndicator = NO;
    carTypeScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    carTypeScrollView.contentSize = CGSizeMake(978 * carTypeNum, 552);
    [carTypeScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    for (int i = 0; i < carTypeNum; i ++) {
        
        UIImageView *carTypeView = [[UIImageView alloc] init];
        carTypeView.frame = CGRectMake(978*i, 0, 978, 552);
        
        carTypeView.backgroundColor = [UIColor whiteColor];
        NSString *imgName = [NSString stringWithFormat:@"%ld.png", offsetVal+i];
        carTypeView.image = [UIImage imageNamed:imgName];
        carTypeView.alpha = 0.8;
        
        [carTypeScrollView addSubview:carTypeView];
    }

}

#pragma mark
#pragma mark - History

- (void)loadHistory
{
    historyImageArray = [[NSArray alloc] initWithObjects:@"hc_01.png", @"hc_02.png", @"hc_03.png", @"hc_04.png", @"hc_05.png", @"hc_06.png", @"hc_07.png", @"hc_08.png", @"hc_09.png", @"hc_10.png", @"hc_11.png", @"hc_12.png", @"hc_13.png", @"hc_14.png", @"hc_15.png", @"hc_16.png", nil];
    
    historyFlowView.delegate = self;
    historyFlowView.dataSource = self;
    historyFlowView.pageControl = historyPageControl;
    historyFlowView.minimumPageAlpha = 0.3;
    historyFlowView.minimumPageScale = 0.9;
    
    historyPageControl.currentPageIndicatorTintColor = [self colorWithHexString:@"fd912c"];
    historyPageControl.pageIndicatorTintColor = [self colorWithHexString:@"dedede"];
    
    historyNameArray = @[ @"FORD", @"福特", @"1914", @"1928", @"1941",
                          @"1948", @"1950", @"1955", @"1961", @"1964",
                          @"1964", @"1970", @"1990", @"1994", @"1995-2011", @"了解Ghia",];
    historyTitleArray = @[@"标志设计来历", @"旗下四大品牌", @"年 福特T型车", @"年 福特A型车",
                          @"年 林肯大陆", @"年 F系列卡车", @"年 水星(Mercury)", @"年 雷鸟(Thunderbird)",
                          @"年 捷豹(Jaguar) E型车", @"年沃尔沃(Volvo) 1800S", @"年 福特野马(Ford Mustang)", @"年 揽胜(Range Rover)",
                          @"年 马自达(Mazda) 三代目", @"年 阿斯顿.马丁(Aston Martin)", @"年 福特在中国", @""];
    historyDescArray = @[@"1913年，福特将大约250辆T型车销到中国，成为第一家在中国开拓业务的美国汽车制造商。",
                         @"目前，它拥有世界著名的四大汽车品牌: 福特(Ford), 林肯(Lincoln), 水星(Mercury), 马自达(Mazda)。",
                         @"一款改变了世界的汽车，1908年，亨利.福特推出了改变世界的T型车，它很快成为全美最畅销的汽车。亨利.福特也被尊称为“为世界装上轮子的人”",
                         @"A型车在不负众望中，使福特从雪弗莱手中重新夺回了汽车销售量的头把交椅。",
                         @"林肯是福特汽车公司拥有的第二个品牌，自1939年美国的富兰克林罗斯福总统以来，它一直被选为总统用车",
                         @"1917年 亨利.福特退出了T型卡车底盘，这是第一种专门为卡车设计的底盘",
                         @"1949年至1951年间的水星深受当时年轻汽车发烧友的青睐。其时尚又俏皮的风格吸引力众多追求个性的顾客",
                         @"雷鸟是福特公司第一款私人豪华轿车，1955年首次投入商业化生产。雷鸟很快就成为年轻人的新宠。",
                         @"新款E型车捷豹于1960年3月在日内瓦(瑞士)汽车展上首次亮相，它轰动了整个汽车界",
                         @"它留给我们的印象是它可以始终以几近极速的速度行驶。该款车也由于频繁出现在英国电视系列剧《The Saint》中而销售量大增。",
                         @"福特将野马首次亮相的舞台选在了1964年的纽约世界博览会。历经几十年的锤炼，野马成就了一种偶像式的地位。",
                         @"1970年，Rover推出一款新式的功能更强并且更加现代化的车型--揽胜。这款汽车以其V-8的功率以及灵巧的悬架设计开创了新型豪华车实用型跑车的新市场。",
                         @"三代目将很多优点集于一身，是以前跑车爱好者们根本想象不到的，它一经推出，立即风靡一时。",
                         @"阿斯顿.马丁以生产敞篷旅行车，赛车和限量生产的跑车而闻名世界。",
                         @"福特在中国",
                         @"很多时候，在福特系列汽车上您能看到Ghia的标志，这代表着它是那个系列车型中的最豪华配置"];
    
    // 多种颜色字体的NSString
    historyTitle.textColor = [self colorWithHexString:@"ff6b01"];
    historyTitle.font = [UIFont boldSystemFontOfSize:20.f];
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", historyNameArray[0], historyTitleArray[0]]];
    
    NSInteger nameLen = [historyNameArray[0] length];
    NSInteger sloganLen = [historyTitleArray[0] length];
    
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:15.f]
                          range:NSMakeRange(nameLen+1, sloganLen)];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[self colorWithHexString:@"65696a"]
                          range:NSMakeRange(nameLen+1, sloganLen)];
    
    historyTitle.attributedText = attributedStr;
    
    // 单一字体
    historyDesc.text = historyDescArray[0];
    [historyDesc sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView;{
    return CGSizeMake(326, 423);
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(PagedFlowView *)flowView {
    NSLog(@"Scrolled to page # %ld", pageNumber);
    
    historyTitle.textColor = [self colorWithHexString:@"ff6b01"];
    historyTitle.font = [UIFont boldSystemFontOfSize:20.f];
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", historyNameArray[pageNumber], historyTitleArray[pageNumber]]];
    
    NSUInteger nameLen = [historyNameArray[pageNumber] length];
    NSUInteger sloganLen = [historyTitleArray[pageNumber] length];
    
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:15.f]
                          range:NSMakeRange(nameLen+1, sloganLen)];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[self colorWithHexString:@"65696a"]
                          range:NSMakeRange(nameLen+1, sloganLen)];
    
    historyTitle.attributedText = attributedStr;
    
    historyDesc.text = historyDescArray[pageNumber];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PagedFlowView Datasource
//返回显示View的个数
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView {
    
    return [historyImageArray count];
}

//返回给某列使用的View
- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index {
    
    UIImageView *imageView = (UIImageView *)[flowView dequeueReusableCell];
    if (!imageView) {
        imageView = [[UIImageView alloc] init];
        imageView.layer.cornerRadius = 6;
        imageView.layer.masksToBounds = YES;
    }
    
    imageView.image = [UIImage imageNamed:[historyImageArray objectAtIndex:index]];
    //    imageView.frame = CGRectMake(45, 30, 233, 328);
    //    imageView.contentMode =  UIViewContentModeScaleAspectFit;
    //    [imageView sizeToFit];
    return imageView;
}

- (IBAction)pageControlValueDidChange:(id)sender {
    
    UIPageControl *pageControl = sender;
    [historyFlowView scrollToPage:pageControl.currentPage];
}

- (IBAction)goFuteCompany:(id)sender
{
    
    UIImage *btnImageSel = [UIImage imageNamed:@"typeBtnSel.png"];
    [historyType1 setBackgroundImage:btnImageSel forState:UIControlStateNormal];
    
    UIImage *btnImage = [UIImage imageNamed:@"typeBtn.png"];
    [historyType2 setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    fordCompanyImg.hidden = NO;
    fordHistoryView.hidden = YES;
}

- (IBAction)goBainianFute:(id)sender
{
    UIImage *btnImageSel = [UIImage imageNamed:@"typeBtnSel.png"];
    [historyType2 setBackgroundImage:btnImageSel forState:UIControlStateNormal];
    
    UIImage *btnImage = [UIImage imageNamed:@"typeBtn.png"];
    [historyType1 setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    fordCompanyImg.hidden = YES;
    fordHistoryView.hidden = NO;
}

- (IBAction)doBack:(id)sender
{
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"确定要返回首页?"
                                          cancelButtonTitle:@"否"
                                          otherButtonTitles:@"是", nil];
    [alert setHandler:^(UIAlertView* alert, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self dismissViewControllerAnimated:YES completion:^{}];
        }
    } forButtonAtIndex:[alert firstOtherButtonIndex]];
    [alert show];
}

#pragma mark - UIWebViewDelegate method
- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    
    // 处理JavaScript和Objective-C交互
    
    if([[[url scheme] lowercaseString] isEqualToString:@"uploadmethod"]) {
        // 得到html5的问卷结果
        if([[url host] isEqualToString:@"data"])
        {
            NSString *showString = [[url resourceSpecifier] substringFromIndex:7];
            NSString *str = [showString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSString *parmString = [NSString stringWithFormat:@"%@&qpg=%@&qeventname=%@&qcity=%@&projectcode=%@", str, [AppManager instance].qpg, [AppManager instance].qeventname, [AppManager instance].qcity, PROJECT_CODE];
            
            if (![self isConnectionAvailable:NO]) {
                // 本地保存
                [self saveToDB:parmString];
            } else {
                // 上传
                [self sendHTTPGet:parmString];
            }
        }
        
        return NO;
    } else if([[[url scheme] lowercaseString] isEqualToString:@"showalert"]) {
        // 处理js的alert
        if([[url host] isEqualToString:@"data"])
        {
            NSArray *tempArray = [[url resourceSpecifier] componentsSeparatedByString:@"img="];
            NSString *imageName = [NSString stringWithFormat:@"BC%@.png", tempArray[1]];
            
            // 主背景
            homeBGView.image = [UIImage imageNamed:imageName];
        }
        
        return NO;
    }  else if([[[url scheme] lowercaseString] isEqualToString:@"validetext"]) {
        // 处理js的alert
        if([[url host] isEqualToString:@"data"])
        {
            NSString *showString = [[url resourceSpecifier] substringFromIndex:13];
            
            NSString *promptMsg = [showString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [[[UIAlertView alloc] initWithTitle:promptMsg
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil
              ] show];
        }
        
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    NSLog(@"webViewDidFinishLoad");
    
    // 禁用用户选择
    [aWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    // 禁用长按弹出框
    [aWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    // 防止拖动后产生白屏
    self.webView.backgroundColor = [UIColor clearColor];
    [(UIScrollView *)[[self.webView subviews] objectAtIndex:0] setBounces:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
}

- (void)saveToDB:(NSString *)parmString
{
    // save result
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *dataId = [NSString stringWithFormat:@"%.0f", a];
    
    // 解析参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *param in [parmString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
    }
    
    // 存数据库
    SurveyObject *surveyObject = [[SurveyObject alloc] init];
    surveyObject.surveyId = dataId;
    surveyObject.projectcode = PROJECT_CODE;
    surveyObject.phone = [params objectForKey:@"qmobile"];
    surveyObject.user = [params objectForKey:@"qpg"];
    surveyObject.city = [params objectForKey:@"qcity"];
    surveyObject.remark = parmString;
    surveyObject.status = @(0);
    [[FMDBConnection instance] insertSurveyObjectDB:surveyObject];
    
    // 提示
    NSString *promptStr = @"";
    
    [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@\n数据保存本地.", promptStr]
                                message:@""
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil
      ] show];
    
    // 主背景
    homeBGView.image = [UIImage imageNamed:@"BC1.png"];
}

- (void) sendHTTPGet:(NSString *)parmString
{
    
    NSString *requestedURL = [NSString stringWithFormat:@"http://58.68.246.100/club/data_receiver.action?%@", parmString];
    NSURL *url = [NSURL URLWithString:[requestedURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSString* newStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"newStr = %@", newStr);
    
    NSData *jsonData = [newStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:&e];
    
    
    NSString *result = [dict objectForKey:@"message"];
    
    // save result
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *dataId = [NSString stringWithFormat:@"%.0f", a];

    // 解析参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *param in [parmString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
    }
    
    int resultVal = [result intValue];
    if (resultVal == 1) {
        
        // 存数据库
        SurveyObject *surveyObject = [[SurveyObject alloc] init];
        surveyObject.surveyId = dataId;
        surveyObject.projectcode = PROJECT_CODE;
        surveyObject.phone = [params objectForKey:@"qmobile"];
        surveyObject.user = [params objectForKey:@"qpg"];
        surveyObject.city = [params objectForKey:@"qcity"];
        surveyObject.remark = parmString;
        surveyObject.status = @(1);
        [[FMDBConnection instance] insertSurveyObjectDB:surveyObject];
        
        // 提示
        [[[UIAlertView alloc] initWithTitle:@"数据提交成功."
                                    message:@""
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil
          ] show];
        
        // 判断是否有重复
        [[FMDBConnection instance] updateRepeatSurveyObjectDB:surveyObject];
    
    } else {
        
        // 存数据库
        SurveyObject *surveyObject = [[SurveyObject alloc] init];
        surveyObject.surveyId = dataId;
        surveyObject.projectcode = PROJECT_CODE;
        surveyObject.phone = [params objectForKey:@"qmobile"];
        surveyObject.user = [params objectForKey:@"qpg"];
        surveyObject.city = [params objectForKey:@"qcity"];
        surveyObject.remark = parmString;
        surveyObject.status = @(0);
        [[FMDBConnection instance] insertSurveyObjectDB:surveyObject];
        
        // 提示
        NSString *promptStr = @"";
        if (result != nil && result.length > 0) {
            if ([result isEqualToString:@"7"]) {
                promptStr = @"活动的录入和手机号已存在，请勿重复录入！";
            }
        }
        
        [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@\n数据保存本地.", promptStr]
                                    message:@""
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil
          ] show];
        
        // 主背景
        homeBGView.image = [UIImage imageNamed:@"BC1.png"];
        
        // 判断是否有重复
//        [[FMDBConnection instance] updateRepeatSurveyObjectDB:surveyObject];
    }
}

#pragma mark
#pragma mark - Fixed bug:UIPopoverPresentationController (<UIPopoverPresentationController: 0x14eeec960>) should have a non-nil sourceView or barButtonItem set before the presentation occurs

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_USEC), dispatch_get_main_queue(),
                   ^{
                       [super presentViewController:viewControllerToPresent animated:flag completion:completion];
                   });
}

@end
