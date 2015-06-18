//
//  GlobalConstants.h
//  DSFL
//
//  Created by Adam on 15/3/21.
//  Copyright (c) 2015年 Adam. All rights reserved.
//

#define VERSION         @"1.0.1"

#ifdef DEBUG
#    define DLog(...)     NSLog(__VA_ARGS__)
#else
#    define DLog(...)
#endif


#define PROJECT_DB_NAME             @"ProjectDB"

#define SUBMIT_URL_PATH             @"http://58.68.246.100/club/data_receiver.action?"


//0,不可以编辑; 1,可以编辑;
#define ADMIN_CAN_EDIT_FLAG         @"0"

// 项目部分
#if CarShowType == 20
// 区域车展
#define SURVEY_HTML_NAME            @"questionnaire"
#define PROJECT_CODE                @"2015BCautoshow"
#define UMENG_ANALYS_APP_KEY        @"55110705fd98c5a6b50001a5"

#elif CarShowType == 21
// 上海车展
#define SURVEY_HTML_NAME            @"shas"
#define PROJECT_CODE                @"2015ShanghaiAutoShow"
#define UMENG_ANALYS_APP_KEY        @"551928c2fd98c5547e000aab"

#elif CarShowType == 22
// A级车展
#define SURVEY_HTML_NAME            @"questionnaire"
#define PROJECT_CODE                @"2015Aautoshow"
#define UMENG_ANALYS_APP_KEY        @"554ad63867e58e3745002aea"

#endif

@interface GlobalConstants : NSObject {
    
}

@end
