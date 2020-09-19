//
//  HUTManager.m
//  HUT
//
//  Created by Lingyu on 16/1/26.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import "HUTManager.h"
#import "UserModel.h"
#import "TimeTable.h"
#import "StudentGradeItem.h"
#import "TimeLineModel.h"
#import "TFHpple.h"
#import "RegexKitLite.h"
#import "TimeTable.h"
#import "TimeTableItem.h"
#import "XMPPFramework.h"


const NSInteger HUTLifeConnectError = -1;//网络连接异常
const NSInteger HUTLifePasswordError =  -2;//密码错误

NSString * const HUTManagerDidFriendListChangedNotificationName = @"HUTManagerDidFriendListChanged";
NSString * const HUTManagerDidReceivePresenceSubscriptionRequestNotificationName = @"HUTManagerDidReceivePresenceSubscriptionRequest";
NSString * const HUTManagerDidReceiveMessageNotificationName = @"HUTManagerDidReceiveMessageNotification";
@interface HUTManager ()<XMPPStreamDelegate,NSFetchedResultsControllerDelegate,XMPPRosterDelegate>

@end

@implementation HUTManager
{
    NSString *_cookie;
    NSString* _userAccount;
    NSString* _userPassword;
    UserModel* _user;
    TimeTable *_userTimeTable;
    
    
    LoginSuccess loginSuccessBlock;
    LoginFailure loginFailureBlock;
    
    RegisterSuccess registerSuccessBlock;
    RegisterFailure registerFailureBlock;
    
    
    UserVCardUpdateSuccess hutUservCardUpdateSucessBlock;
    UserVCardUpdateFailure hutUsercCardUpdateFailureBlock;
    
    BOOL isRegister;
    
    XMPPStream *_hutXMPPStream;
    XMPPReconnect *_hutXMPPReconnectModule;
    
    //花名册
    XMPPRoster *_hutXMPPRosterModule;
    XMPPRosterCoreDataStorage *_hutXMPPRosterStorage;
    NSFetchedResultsController *_hutXMPPRosterController;
    
    //电子名片
    XMPPvCardTempModule *_hutXMPPvCardTempModule;
    XMPPvCardCoreDataStorage *_hutXMPPvCardStorage;
    
    //个人头像
    XMPPvCardAvatarModule *_hutXMPPvCardAvatarModule;
    
    //消息模块
    XMPPMessageArchiving *_hutXMPPMessageModule;
    XMPPMessageArchivingCoreDataStorage *_hutXMPPMessageStorage;
    
    //订阅请求
    NSMutableArray<XMPPPresence*> *_presenceSubscriptionRequestArray;
}
/**
 *单例对象
 */
static HUTManager *singleManager;

/**
 *登录页面URL
 */
static NSString *checkCodeURL;
static NSString *loginPageURL;
static NSString *loginDomain;
static NSString *userIdentity;
/*
 *教务管理系统首页
 */
static NSString *homePageURL;
/**
 *gb212编码
 */
static NSStringEncoding gb2312Encoding;

/**
 *HUTLife服务器
 */
static NSString *hutLifeServer;

+(void)initialize
{
    checkCodeURL = @"http://218.75.197.124:83/CheckCode.aspx";
    loginPageURL  = @"http://218.75.197.124:83/default2.aspx";
    loginDomain = @"218.75.197.124";
    userIdentity = @"%D1%A7%C9%FA";//代表学生   教师：@"%BD%CC%CA%A6" 部门: @"%B2%BF%C3%C5 访客: @"%B7%C3%BF%CD"
    gb2312Encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    homePageURL = @"http://218.75.197.124:83/xs_main.aspx";
    hutLifeServer = @"www.liuhuiit.com";
}


+(instancetype)sharedHUTManager
{
    if (singleManager != nil) {
        return singleManager;
    }
    
    singleManager = [HUTManager new];
    
    return singleManager;
}

+(void)cleanData
{
    singleManager = nil;
}

-(XMPPStream*)hutXMPPStream
{
    if (self->_hutXMPPStream) {
        return self->_hutXMPPStream;
    }
    
    self->_hutXMPPStream = [[XMPPStream alloc] init];
    //称为hutXMPPStream的代理，并且设置为主线程调用:当在主线程中调用Delegate的方法
    [self->_hutXMPPStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    //设置服务器
    [self->_hutXMPPStream setHostName:hutLifeServer];
    
    //激活自动连接模块
    [[self hutXMPPReconnectModule] activate:self->_hutXMPPStream];
    
    //激活电子名片模块
    [[self hutXMPPvCardTempModule] activate:self->_hutXMPPStream];
    
    //激活个人头像模块
    [[self hutXMPPvCardAvatarModule] activate:self->_hutXMPPStream];
    
    
    //激活花名册模块
    [[self hutXMPPRosterModule] activate:self->_hutXMPPStream];
    
    //激活消息模块
    [[self hutXMPPMessageModule]activate:self->_hutXMPPStream];
    
    
    return self->_hutXMPPStream;
}

-(XMPPReconnect*)hutXMPPReconnectModule
{
    if(self->_hutXMPPReconnectModule){
        return self->_hutXMPPReconnectModule;
    }
    
    self->_hutXMPPReconnectModule = [[XMPPReconnect alloc] init];
    return self->_hutXMPPReconnectModule;
}

-(XMPPRoster*)hutXMPPRosterModule
{
    if (self->_hutXMPPRosterModule) {
        return self->_hutXMPPRosterModule;
    }
    
    self->_hutXMPPRosterModule = [[XMPPRoster alloc] initWithRosterStorage:[self hutXMPPRosterStorage]];
    [self->_hutXMPPRosterModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    return self->_hutXMPPRosterModule;
}


- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    
    for (XMPPPresence *presenceItem in [self presenceSubscriptionRequestArray]) {
        if ([[presenceItem from] isEqualToJID:[presence from]]) {
            [[self presenceSubscriptionRequestArray] removeObject:presenceItem];
        }
    }
    [[self presenceSubscriptionRequestArray] addObject:presence];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HUTManagerDidReceivePresenceSubscriptionRequestNotificationName object:self];
    
}

-(XMPPRosterCoreDataStorage*)hutXMPPRosterStorage
{
    if (self->_hutXMPPRosterStorage) {
        return self->_hutXMPPRosterStorage;
    }
    self->_hutXMPPRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    
    return self->_hutXMPPRosterStorage;
}

-(XMPPvCardTempModule*)hutXMPPvCardTempModule
{
    if (self->_hutXMPPvCardTempModule) {
        return self->_hutXMPPvCardTempModule;
    }
    
    self->_hutXMPPvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:[self hutXMPPvCardStorage]];
    [self->_hutXMPPvCardTempModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    return self->_hutXMPPvCardTempModule;
}

-(XMPPvCardCoreDataStorage*)hutXMPPvCardStorage
{
    if(self->_hutXMPPvCardStorage){
        return self->_hutXMPPvCardStorage;
    }
    
    self->_hutXMPPvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    
    return self->_hutXMPPvCardStorage;
}

-(XMPPvCardAvatarModule*)hutXMPPvCardAvatarModule
{
    if (self->_hutXMPPvCardAvatarModule) {
        return self->_hutXMPPvCardAvatarModule;
    }
    
    self->_hutXMPPvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:[self hutXMPPvCardTempModule]];
    
    return self->_hutXMPPvCardAvatarModule;
}

-(XMPPvCardTemp*)friendvCardTempWithAccount:(XMPPJID*)account;
{
    
    XMPPvCardTemp *vCard = [[self hutXMPPvCardTempModule] vCardTempForJID:account shouldFetch:YES];
    
    return vCard;
}


/**
 *获取用户的存储模型
 */
-(XMPPUserCoreDataStorageObject*)friendModelWithAccount:(XMPPJID*)account
{
    return [[self hutXMPPRosterStorage] userForJID:account xmppStream:[self hutXMPPStream] managedObjectContext:[[self hutXMPPRosterStorage] mainThreadManagedObjectContext]];
}

-(XMPPMessageArchivingCoreDataStorage*)hutXMPPMessageStorage
{
    if (self->_hutXMPPMessageStorage) {
        return self->_hutXMPPMessageStorage;
    }
    
    self->_hutXMPPMessageStorage = [[XMPPMessageArchivingCoreDataStorage alloc] init];
    
    return self->_hutXMPPMessageStorage;
}

-(XMPPMessageArchiving*)hutXMPPMessageModule
{
    if (self->_hutXMPPMessageModule) {
        return self->_hutXMPPMessageModule;
    }
    
    self->_hutXMPPMessageModule = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:[self hutXMPPMessageStorage]];
    
    return self->_hutXMPPMessageModule;
}

-(NSMutableArray<XMPPPresence*>*)presenceSubscriptionRequestArray
{
    if (self->_presenceSubscriptionRequestArray) {
        return self->_presenceSubscriptionRequestArray;
    }
    
    self->_presenceSubscriptionRequestArray = [NSMutableArray<XMPPPresence*> array];
    
    return self->_presenceSubscriptionRequestArray;
}




/**
 *获取教务管理系统的登录首页
 */

-(void)getLoginPageFormDictWithSuccess:(void (^)(NSDictionary*))success andFailure:(void(^)(NSError*))failure
{
    NSURLRequest *loginPageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:loginPageURL]];
    [NSURLConnection sendAsynchronousRequest:loginPageRequest queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            NSLog(@"打开教务管理系统的登录页面时发生错误");
            if (failure) {
            
                dispatch_sync(dispatch_get_main_queue(), ^{
                    failure([NSError errorWithDomain:@"" code:-1 userInfo:@{@"reason":@"打开教务管理系统的登录页面时发生错误"}]);
                    
                });
            
            }
        }else{
            NSString *pageContent = [[NSString alloc] initWithData:data encoding:gb2312Encoding];
            NSDictionary *formDict = [self getHTMLFormData:pageContent];
            if (success) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                success(formDict);
                });
            }
        }
    }];
}

/**
 *获取最新的登陆界面验证码
 */
-(void)getLatestVerifyCodeWithSuccessBlock:(void (^)(NSData *))success failureBlock:(void (^)(NSError *))faiure
{
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:checkCodeURL]] queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (connectionError != nil) {//连接失败
                if (faiure) {
                    faiure(connectionError);
                }
            }else{
                if (success) {
                    success(data);
                }
            }
        });
        
    }];
}


/**
 *用户登录
 */
-(void)loginWithUserName:(NSString *)userName userPassword:(NSString *)userPassword andVerifyCode:(NSString *)verifyCode withSuccessBlock:(void (^)())success failureBlock:(void (^)(NSError *))failure
{
    
    //首先获取登录页面中的隐藏表单信息
    [self getLoginPageFormDictWithSuccess:^(NSDictionary *formDict) {
        
        NSString* requestInfo = [NSString stringWithFormat:@"__VIEWSTATE=dDwyODE2NTM0OTg7Oz5IQ%%2FUNIWFQ97%%2FvhvmrIysrDk7Sog%%3D%%3D&txtUserName=%@&TextBox2=%@&txtSecretCode=%@&RadioButtonList1=%@&Button1=&lbLanguage=&hidPdrs=&hidsc=",userName,userPassword,verifyCode,userIdentity];
        
        
        NSURL* url = [NSURL URLWithString:loginPageURL];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        NSString *formDataStr = [self formDictToFormString:formDict];
        NSData *formData = [formDataStr dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:formData];
        
        [request setHTTPBody:[requestInfo dataUsingEncoding:gb2312Encoding]];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            
            
            
            if (connectionError != nil) {//连接失败
                if (failure) {
                    failure(connectionError);
                }
            }else{;
                
                NSURL* checkURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?xh=%@",homePageURL,userName]];
                if ([[response URL] isEqual:checkURL]) {
                    //HTML网页数据
                    //                NSString *rawData = [[NSString alloc] initWithData:data encoding:gb212Encoding];
                    
                    self->_cookie = [self findCookieWithDomain:loginDomain];//存储登录界面的cookie
                    self->_userAccount = userName;
                    self->_userPassword = userPassword;
                    
#pragma mark - 连接HUTLife服务器
                    
                    [self hutLifeConnect];
                    
                    if (success) {
                        success();
                    }
                    
                    
                }else{//登录失败
                    NSError *error = [NSError errorWithDomain:@"密码错误" code:-1 userInfo:nil];
                    if (failure) {
                        failure(error);
                    }
                    
                }
            }
            
        }];
    
    } andFailure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}


/**
 *获取用户信息
 */
-(void)getUserInfoWithSuccess:(void (^)(UserModel *))success andFailur:(void (^)(NSError *))failure
{    
    if (self->_user!=nil) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            if (success) {
                success(self->_user);
            }
        }];
    }else{
        
        NSString *refererURLStr = [homePageURL stringByAppendingString:[NSString stringWithFormat:@"?xh=%@",self->_userAccount]];
        NSString *requestURLStr = [[NSString stringWithFormat:@"http://%@:83/xsgrxx.aspx?xh=%@",loginDomain,self->_userAccount] stringByAppendingString:@"&xm=%C1%E8%D3%EE&gnmkdm=N121501"];

        NSURL* requestURL = [NSURL URLWithString:requestURLStr];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:requestURL];
        [request setValue:refererURLStr forHTTPHeaderField:@"Referer"];
        [request setValue:self->_cookie forHTTPHeaderField:@"Cookie"];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            
            
            
            if (connectionError != nil) {//连接错误
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if (failure) {
                        failure(connectionError);
                    }
                });
                
                
            }else{
                dispatch_sync(dispatch_get_main_queue(), ^{
                    NSString* contentString = [[NSString alloc] initWithData:data encoding:gb2312Encoding];
                    UserModel *user = [self userModelFromData:[contentString dataUsingEncoding:NSUTF8StringEncoding]];
                    self->_user = user;
                    success(user);
                });
            }
        }];
    }
}


/**
 *获取课表
 */

-(void)enquireClassTimeTableWithSuccess:(void (^)(TimeTable*))success andFailure:(void (^)(NSError *))failure
{
    
    if (self->_userTimeTable) {
        if (success) {
            success(self->_userTimeTable);
        }
    }else{
        
        NSString * userNameEncoding = [[self->_user name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *refererURLStr = [homePageURL stringByAppendingString:[NSString stringWithFormat:@"?xh=%@",self->_userAccount]];
        
        NSString *requestURLStr = [NSString stringWithFormat:@"http://%@:83/xskbcx.aspx?xh=%@&xm=%@&gnmkdm=N121603",loginDomain,self->_userAccount,userNameEncoding];
        
        
        NSURL* requestURL = [NSURL URLWithString:requestURLStr];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:requestURL];
        [request setValue:refererURLStr forHTTPHeaderField:@"Referer"];
        [request setValue:self->_cookie forHTTPHeaderField:@"Cookie"];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            if (connectionError) {
                if (failure) {
                    failure(connectionError);
                }
            }else{
                
                NSString *classTableContent = [[NSString alloc] initWithData:data encoding:gb2312Encoding];
                self->_userTimeTable= [self classTableFromData:[classTableContent dataUsingEncoding:NSUTF8StringEncoding]];
                if (success) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        success(self->_userTimeTable);
                    });
                }
            }
        }];
            
    }
    
}
/**
 *获取指定域名(IP)的Cookie
 */
-(NSString*)findCookieWithDomain:(NSString*)domain
{
    
    NSArray* cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    
    for( NSHTTPCookie* cookieItem in cookies)
    {
        if ([[cookieItem domain] isEqualToString:domain]) {
            NSString* name = [cookieItem name];
            NSString* value = [cookieItem value];
            return [NSString stringWithFormat:@"%@=%@",name,value];
        }
    }
    return nil;
    
}


/**
 *对教务管理系统返回的HTML格式的学生信息进行解析
 */
-(UserModel*)userModelFromData:(NSData*)data
{
    
    TFHpple *doc = [[TFHpple alloc] initWithData:data encoding:@"UTF-8" isXML:NO];
    
    NSArray * elements  = [doc searchWithXPathQuery:@"//td"];
    
    UserModel *user = [UserModel new];
    
    for (int index  = 0; index < ([elements count]-1); index++) {
        NSString *currentField = [[[elements objectAtIndex:index] firstChild] text];
        NSString *nextField = [[[elements objectAtIndex:(index + 1)] firstChild] text];
        
        if ([currentField isEqualToString:@"学号："]) {
            [user setStudentID:nextField];
            continue;
        }
        
        if ([currentField isEqualToString:@"姓名："]) {
            [user setName:nextField];
            continue;
        }
        
        if ([currentField isEqualToString:@"性别："]) {
            if ([nextField isEqualToString:@"男"]) {
                [user setSex:YES];
            }else{
                [user setSex:NO];
            }
            continue;
        }
        
        if ([currentField isEqualToString:@"入学日期："]) {
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            [dateFormatter setDateFormat:@"yyyyMMdd"];
            [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh"]];
            NSDate *date = [dateFormatter dateFromString:nextField];
            [user setEnrollmentDate:date];
            continue;
        }
        
        if ([currentField isEqualToString:@"出生日期："]) {
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            [dateFormatter setDateFormat:@"yyyyMMdd"];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            NSDate *date = [dateFormatter dateFromString:nextField];
            [user setBirthDate:date];
            continue;
        }
        
        if ([currentField isEqualToString:@"毕业中学："]) {
            [user setMiddleSchool:nextField];
            continue;
        }
        
        if ([currentField isEqualToString:@"来源省："]) {
            [user setHomeTown:nextField];
            continue;
        }
        
        if ([currentField isEqualToString:@"身份证号："]) {
            [user setIdentity:nextField];
            continue;
        }
        
        if ([currentField isEqualToString:@"学院："]) {
            [user setCollege:nextField];
            continue;
        }
        
        if ([currentField isEqualToString:@"专业名称："]) {
            [user setMajor:nextField];
            continue;
        }
        
        if ([currentField isEqualToString:@"行政班："]) {
            [user setClassName:nextField];
            continue;
        }
    }
    
    return user;
}

/**
 *对教务管理系统返回的HTML格式的课表进行解析
 */
-(TimeTable*)classTableFromData:(NSData*)data
{
    
    NSString *xpath = @"//table[@class='blacktab']/tr";
    
    NSMutableArray<NSMutableDictionary*> *timeTableItemDictArray = [NSMutableArray<NSMutableDictionary*> array];
    
    NSMutableArray<NSString*> *weeksArray = [NSMutableArray<NSString*> array];
    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data encoding:@"utf-8"];
    
    NSArray *elements = [doc searchWithXPathQuery:xpath];
    
    for (TFHppleElement *trObject in elements) {//遍历Table中的每一行
        
        //在这个Table中，有两种类型的行：表头行和记录行
        //可以通过每一行中第一字段的文本节点来判断
        
        NSArray<TFHppleElement*> *tdObjectArray = [trObject childrenWithTagName:@"td"];//一行中的所有字段
        
        NSString *weekFlag = @"时间";
        
        TFHppleElement *firstElement = [tdObjectArray firstObject];
        
        if ([[firstElement content] isEqualToString:weekFlag]) {//表头行
            
            //获取
            
            [tdObjectArray enumerateObjectsUsingBlock:^(TFHppleElement *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx!=0) {
                    //将表头中的每一字段依次存入weeksArray中
                    [weeksArray addObject:[obj content]];
                }
            }];
            
        }else{//记录行
            
            //记录行中所有的课程字段都是以第\\d节正式开始
            //同时该字段还标识课程字段属于第几节课。index用于标识改课程字段属于第几天。
            
            NSInteger timeindex = 0;//第几节课
            NSInteger weekIndex = 0;//第几天
            
            for (TFHppleElement *tdObject in tdObjectArray) {//遍历记录行中的所有字段
                
                //字段内容
                NSString *tdObjectContent = [[tdObject content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
                if (timeindex) {
                    //第几节课已经确定
                    weekIndex++;
                    if (![tdObjectContent isEqualToString:@""]) {//课程字段不为空
                        
                        //四个子节点表示一个课程
                        //第一个子节点表示课程名称
                        //第二个子节点表示课程时间
                        //第三个子节点表示课程老师
                        //第四个子节点表示课程地点
                        
                        NSInteger index = 0;
                        NSInteger timeTableItemCount = 1;
                        for (TFHppleElement *detailElement in [tdObject children]) {
                            
                            NSString *detailContent = [[detailElement content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                            
                            if ([detailContent isEqualToString:@""]) {
                                continue;
                            }
                            
                            if (index==0) {
                                //需要创建一个新的Dictionary病添加到timeTableItemDictArray中
                                NSMutableDictionary *timeTableItemDict = [NSMutableDictionary dictionary];
                                [timeTableItemDictArray addObject:timeTableItemDict];
                            }
                            
                            NSMutableDictionary *currentItemDict = [timeTableItemDictArray lastObject];
                            
                            switch (index) {
                                case 0://课程名称 概率论与数理统计C
                                {
                                    [currentItemDict setObject:detailContent forKey:@"courseName"];
                                }
                                    break;
                                case 1://课程时间 1-13单(1,2)
                                {
                                    //courseFrom    起始周
                                    [detailContent enumerateStringsMatchedByRegex:@"\\d+-" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
//                                        NSInteger from = [[[*capturedStrings componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""] integerValue];
                                        NSInteger from = [*capturedStrings toIntegetValue];
                                        [currentItemDict setObject:[NSNumber numberWithInteger:from] forKey:@"courseFrom"];
                                    }];
                                    //courseTo      //结束周
                                    
                                    [detailContent enumerateStringsMatchedByRegex:@"\\-\\d+" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
//                                        NSInteger to = [[[*capturedStrings componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""] integerValue];
                                        NSInteger to = [*capturedStrings toIntegetValue];
                                        [currentItemDict setObject:[NSNumber numberWithInteger:to] forKey:@"courseTo"];
                                    }];
                                    
                                    //courseDay     星期几
                                    [currentItemDict setObject:[NSNumber numberWithInteger:weekIndex] forKey:@"courseDay"];
                                    //courseFlag    //单周、双周、不区分单双周
                                    if ([detailContent rangeOfString:@"单"].length) {
                                        [currentItemDict setObject:[NSNumber numberWithInteger:CourseFlagSingle] forKey:@"courseFlag"];
                                    }else if ([detailContent rangeOfString:@"双"].length){
                                        [currentItemDict setObject:[NSNumber numberWithInteger:CourseFlageDouble] forKey:@"courseFlag"];
                                    }else{
                                        [currentItemDict setObject:[NSNumber numberWithInteger:CourseFlageCommon] forKey:@"courseFlag"];
                                    }
                                    //courseTime    //上课时间
                                    
                                    NSMutableArray<NSNumber*> *courseTime = [NSMutableArray<NSNumber*> array];
                                    //\\((\\d+,)+\\d+\\)
                                    [detailContent enumerateStringsMatchedByRegex:@"(\\d+,)+\\d+" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                                        //提取出匹配的字符串
                                        //使用,作为分隔符，将字符串分隔
                                        NSArray<NSString*> *numbers = [*capturedStrings componentsSeparatedByString:@","];
                                        for (NSString *numberItem in numbers) {
                                            NSInteger num = [[[numberItem componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""] integerValue];
                                            [courseTime addObject:[NSNumber numberWithInteger:num]];
                                        }
                                        
                                    }];
                                    [currentItemDict setObject:courseTime forKey:@"courseTime"];
                                }
                                    break;
                                case 2://课程老师 刘斌2
                                {
                                    
                                    [currentItemDict setObject:detailContent forKey:@"courseTeacher"];
                                }
                                    break;
                                case 3://课程地点 公共201
                                {
                                    
                                    [currentItemDict setObject:detailContent forKey:@"coursePlace"];
                                }
                                    break;
                            }
                            
                            
                            
                            if (index == 3) {
                                index = 0;
                                timeTableItemCount++;
                            }else{
                                index++;
                            }
                        }
                    }
                }else{
                    
                    //第几节课还未确定
                    if ([tdObjectContent isMatchedByRegex:@"第\\d节"]) {
                        timeindex = [[[[tdObject content] componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""] integerValue];
                    }
                    
                }
                
                
            }
            
        }
    }
    
    TimeTable *table = [TimeTable titmeTableWithDictionaries:timeTableItemDictArray];
    return table;
}


/**
 *获取成绩查询首页中的隐藏表单信息
 */

-(void)getGradePageFormDictWithSuccess:(void (^)(NSDictionary*))success andFailure:(void(^)(NSError*))failure
{
    
    NSString * userNameEncoding = [[self->_user name] stringByAddingPercentEscapesUsingEncoding:gb2312Encoding];
    
    NSString *gradePgaeURL = [NSString stringWithFormat:@"http://%@:83/xscjcx.aspx?xh=%@&xm=%@&gnmkdm=N121605",loginDomain,self->_userAccount,userNameEncoding];
    
    NSMutableURLRequest *loginPageRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:gradePgaeURL]];
    NSString *refererURLStr = [NSString stringWithFormat:@"http://%@:83/xscjcx.aspx?xh=%@&xm=%@&gnmkdm=N121605",loginDomain,self->_userAccount,userNameEncoding];
    [loginPageRequest setValue:refererURLStr forHTTPHeaderField:@"Referer"];
    [loginPageRequest setValue:self->_cookie forHTTPHeaderField:@"Cookie"];
    [NSURLConnection sendAsynchronousRequest:loginPageRequest queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            NSLog(@"打开教务管理系统的成绩查询页面时发生错误");
            if (failure) {
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    failure([NSError errorWithDomain:@"" code:-1 userInfo:@{@"reason":@"打开教务管理系统的成绩查询页面时发生错误"}]);
                    
                });
                
            }
        }else{
            NSString *pageContent = [[NSString alloc] initWithData:data encoding:gb2312Encoding];
            NSDictionary *formDict = [self getHTMLFormData:pageContent];
            if ([self findCookieWithDomain:loginDomain]) {
                self->_cookie = [self findCookieWithDomain:loginDomain];//存储登录界面的cookie
            }
            if (success) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    success(formDict);
                });
            }
        }
    }];
}
/**
 *获取成绩
 */

-(void)enquireUserSchoolRecordsWithSuccess:(void (^)(NSArray<StudentGradeItem *> *))success andFailure:(void (^)(NSError *))failure
{
    
    //首先获取成绩查询的首页面
    
    [self getGradePageFormDictWithSuccess:^(NSDictionary *formDict) {
        
        NSString * userNameEncoding = [[self->_user name] stringByAddingPercentEscapesUsingEncoding:gb2312Encoding];
        
        NSString *refererURLStr = [NSString stringWithFormat:@"http://%@:83/xscjcx.aspx?xh=%@&xm=%@&gnmkdm=N121605",loginDomain,self->_userAccount,userNameEncoding];
        
        NSString *requestURLStr = [NSString stringWithFormat:@"http://%@:83/xscjcx.aspx?xh=%@&xm=%@&gnmkdm=N121605",loginDomain,self->_userAccount,userNameEncoding];
        
        NSURL* requestURL = [NSURL URLWithString:requestURLStr];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:requestURL];
        [request setHTTPMethod:@"POST"];
        [request setValue:refererURLStr forHTTPHeaderField:@"Referer"];
        [request setValue:self->_cookie forHTTPHeaderField:@"Cookie"];
        [request setValue:[NSString stringWithFormat:@"http://%@:83",loginDomain] forHTTPHeaderField:@"Origin"];
        
        NSString *ddlxn = @"2014-2015";
        NSString *ddlxq = @"1";
        NSString *btnCx = @"01";
        NSString *btn_xq = [@"必修课"  stringByAddingPercentEscapesUsingEncoding:gb2312Encoding];
        
        [formDict setValue:[self stringByURLEncode:[formDict objectForKey:@"__VIEWSTATE"]] forKey:@"__VIEWSTATE"];
        NSString *formDataStr = [self formDictToFormString:formDict];
        
        NSMutableString *postFormStr = [NSMutableString new];
        postFormStr = [NSMutableString stringWithString:formDataStr];
        [postFormStr appendFormat:@"&ddlXN=%@",ddlxn];
        [postFormStr appendFormat:@"&ddlXQ=%@",ddlxq];
        [postFormStr appendFormat:@"&ddl_kcxz=%@",btnCx];
        [postFormStr appendFormat:@"&btn_xq=%@",btn_xq];
        
        NSData *postFormData = [postFormStr dataUsingEncoding:NSUTF8StringEncoding];
        
        [request setHTTPBody:postFormData];
        
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            if (connectionError != nil) {
                if (failure) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        failure([[NSError alloc] initWithDomain:@"" code:-1 userInfo:@{@"reason":@"查询成绩 网络连接错误"}]);
                    });
                }
                NSLog(@"%@",connectionError);
            }else{
                
                NSString* contentString = [[NSString alloc] initWithData:data encoding:gb2312Encoding];
                
                NSArray<NSDictionary*> *gradeDictArray = [self analysisUserSchoolRecords:[contentString dataUsingEncoding:NSUTF8StringEncoding]];
                
                NSMutableArray<StudentGradeItem*> *gradeItemArray = [NSMutableArray<StudentGradeItem*> array] ;
                for (NSDictionary *gradeDictItem in gradeDictArray) {
                    
                    StudentGradeItem *item = [[StudentGradeItem alloc] initWithDict:gradeDictItem];
                    
                    [gradeItemArray addObject:item];
                }
                
                if (success) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        success(gradeItemArray);
                    });
                }
                
            }
        }];

    } andFailure:^(NSError *error) {
        if (failure) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                failure(error);
            });
        }
    }];
    
}

/**
 *对教务管理系统返回的成绩HTML网页进行解析
 */

-(NSArray<NSDictionary*>*)analysisUserSchoolRecords:(NSData*)schoolRecordsData
{
    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:schoolRecordsData encoding:@"utf-8"];
    
    //获取表头项
    
    NSMutableArray<NSString*> *gradeFiedNamesArray = [NSMutableArray<NSString*> array];
    
    NSString *xpath = @"//table[@class='datelist']/tr[@class='datelisthead']";
    
    NSArray *elements = [doc searchWithXPathQuery:xpath];
    
    TFHppleElement *datelistheadElement = [elements lastObject];
    
    for (TFHppleElement *tdObject in [datelistheadElement childrenWithTagName:@"td"]) {
        NSString *content = [[tdObject content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [gradeFiedNamesArray addObject:content];
    }
    
    //获取每一项
    NSMutableArray<NSDictionary*> *gradeDictArray = [NSMutableArray<NSDictionary*> array];
    
    xpath = @"//table[@class='datelist']/tr[position()>1]";
    elements = [doc searchWithXPathQuery:xpath];
    for (TFHppleElement *gradeObject in elements) {//获取每一个grade记录
        
        //遍历每一个grade记录的字段
        NSUInteger index = 0;
        NSMutableDictionary *gradeDict = [NSMutableDictionary dictionary];
        
        for (TFHppleElement *gradeField in [gradeObject childrenWithTagName:@"td"]) {
            NSString *fieldContent = [[gradeField content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSString *fieldName = [gradeFiedNamesArray objectAtIndex:index];
            
            [gradeDict setObject:fieldContent forKey:fieldName];
            index++;
            
        }
        
        [gradeDictArray addObject:gradeDict];
        
    }
    
    return gradeDictArray;
    
}

/**
 *更新TimeLine
 */
-(void)refreshNewTimeLineWithSuccess:(void (^)(NSArray<TimeLineModel *> *))success andFailure:(void (^)(NSError *))failure
{
    
}


/**
 *获取HTML页面中的所有hiiden表单信息
 */
-(NSDictionary*)getHTMLFormData:(NSString*)htmlPageContent
{
    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:[htmlPageContent dataUsingEncoding:NSUTF8StringEncoding] encoding:@"utf-8"];
    
    
    NSString *xpath = @"//input[@type='hidden']";
    
    NSArray *elements = [doc searchWithXPathQuery:xpath];
    
    NSMutableDictionary *formDict = [NSMutableDictionary dictionary];
    
    for (TFHppleElement *inputElement in elements) {
        
        if ([[inputElement attributes] objectForKey:@"name"]) {
            if ([[inputElement attributes] objectForKey:@"value"]) {
                [formDict setObject:[[inputElement attributes] objectForKey:@"value"] forKey:[[inputElement attributes] objectForKey:@"name"]];
            }else{
                [formDict setObject:@"" forKey:[[inputElement attributes] objectForKey:@"name"]];
            }
        }
        
    }
    
    return formDict;
    
}

/**
 *将Dict中的表单数据转换为字符串
 */
-(NSString*)formDictToFormString:(NSDictionary*)formDict
{
    
    NSMutableString *formString = [NSMutableString string];
    
    NSUInteger index = 0;
    for (NSString *formKey in [formDict allKeys]) {
        
        NSString *formValue = [formDict objectForKey:formKey];
        if (index) {
            [formString appendString:[NSString stringWithFormat:@"&%@=%@",formKey,formValue]];
        }else{
            [formString appendString:[NSString stringWithFormat:@"%@=%@",formKey,formValue]];
        }
        index++;
    }
    
    return formString;
}

/**
 *对字符串进行URL编码
 */
-(NSString*)stringByURLEncode:(NSString*)rawString
{
    NSString *encodedValue = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                                  (CFStringRef)rawString, nil,
                                                                                                  (CFStringRef)@"!*'();:@&=+$,/ %#[]", kCFStringEncodingUTF8));
    return encodedValue;
}


/**
 *发送文本消息
 */

-(void)sendChatMessage:(XMPPMessage*)message;
{
    [[self hutXMPPStream] sendElement:message];
}

#pragma mark HUTLife即时通讯

/**
 *登录HUTXMPP服务器
 */
-(void)loginHUTLifeWithAccount:(NSString*)account andPassword:(NSString*)password success:(LoginSuccess)success failure:(LoginFailure)failure
{
    self->_userAccount = account;
    self->_userPassword = password;
    
    if ([[self hutXMPPStream] isConnected] || [[self hutXMPPStream] isConnecting]) {
        [[self hutXMPPStream] disconnect];
    }
    
    self->isRegister = NO;
    
    
    self->loginSuccessBlock = success;
    self->loginFailureBlock = failure;
    
    [self hutLifeConnect];
    
    
}

/**
 *注册账号
 */
-(void)registerHUTLifeAccountWith:(NSString*)account andPassword:(NSString*)password success:(RegisterSuccess)success failure:(RegisterFailure)failure;
{
    self->_userAccount = account;
    self->_userPassword = password;
    
    if ([[self hutXMPPStream] isConnected] || [[self hutXMPPStream] isConnecting]) {
        [[self hutXMPPStream] disconnect];
    }
    
    
    self->isRegister = YES;
    
    self->registerSuccessBlock = success;
    self->registerFailureBlock = failure;
    
    [self hutLifeConnect];
}


-(NSString*)hutLifeAccount
{
    if (nil==self->_userAccount) {
        return nil;
    }else{
        return [NSString stringWithFormat:@"%@@%@",self->_userAccount,hutLifeServer];
    }
}

-(NSString*)hutLifePassword
{
    if (nil==self->_userPassword) {
        return nil;
    }else{
        return self->_userPassword;
    }
}

/**
 *HUTLifeConnect
 *向HUTLife服务器发送用户名建立连接
 */
-(BOOL)hutLifeConnect
{
    
    if ([[self hutXMPPStream] isConnected]) {
        return YES;
    }
    
    //用户帐号和密码不能为空
    if([self hutLifeAccount]==nil||[self hutLifePassword]==nil){
        return NO;
    }
    
    //设置登录用户
    [[self hutXMPPStream]setMyJID:[XMPPJID jidWithString:[self hutLifeAccount]]];
    
    //连接服务器
    NSError *connectError;
    [[self hutXMPPStream] connectWithTimeout:10 error:&connectError];
    
    if (nil!=connectError) {
        
        NSError *error = [NSError errorWithDomain:hutLifeServer code:HUTLifeConnectError userInfo:nil];
        
        if (self->isRegister) {
            if (self->registerFailureBlock) {
                self->registerFailureBlock(self,error);;
            }
        }else{
            if (self->loginFailureBlock) {
                self->loginFailureBlock(self,error);
                self->loginFailureBlock = nil;

            }
        }
        
        return NO;
    }else{
        return YES;
    }
    
}

/**
 *XMPPStreamDelegate Method:This method is called after the XML stream has been fully opened.
 *连接HUTLife服务器成功,向HUTLife服务器发送用户密码进行认证
 */

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSError *connectError;
    
    if (self->isRegister) {//注册
        [sender registerWithPassword:[self hutLifePassword] error:&connectError];
    }else{//登录
        [sender authenticateWithPassword:[self hutLifePassword] error:&connectError];
    }
    
    if (nil!=connectError) {
        NSError *error = [NSError errorWithDomain:hutLifeServer code:HUTLifeConnectError userInfo:nil];
        
        if (self->isRegister) {
            if (self->registerFailureBlock) {
                self->registerFailureBlock(self,error);;
            }
        }else{
            if (self->loginFailureBlock) {
                self->loginFailureBlock(self,error);
                self->loginFailureBlock = nil;
            }
        }

    }
}

/**
 *XMPPStreamDelegate Method:This method is called if authentication fails
 *登录HUTLife服务器成功，更新用户的在线状态
 */

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    
    NSXMLElement *onLinePresence = [NSXMLElement elementWithName:@"presence" xmlns:@"jabber:client"];
    [onLinePresence addAttributeWithName:@"from" stringValue:[self hutLifeAccount]];
    [onLinePresence addAttributeWithName:@"type" stringValue:@"chat"];
    
    NSXMLElement *showNode = [NSXMLElement elementWithName:@"show"];
    [showNode setStringValue:@"show"];
    
    NSXMLElement *statusNode = [NSXMLElement elementWithName:@"status"];
    [statusNode setStringValue:@"在线"];
    
    [onLinePresence addChild:showNode];
    [onLinePresence addChild:statusNode];
    
    [sender sendElement:onLinePresence];
    
    if (self->loginSuccessBlock) {
        self->loginSuccessBlock(self);;
        self->loginSuccessBlock = nil;
    }
}

/**
 *XMPPStreamDelegate Method:This method is called if authentication fails
 *登录HUTLife服务器失败——密码错误
 **/
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    NSError *passworderror = [NSError errorWithDomain:hutLifeServer code:HUTLifePasswordError userInfo:nil];
    if (self->loginFailureBlock) {
        self->loginFailureBlock(self,passworderror);;
        self->loginFailureBlock = nil;
    }

}

/**
 *XMPPStreamDelegate Method:This method is called if register fails
 *注册成功
 **/
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    if (self->registerSuccessBlock) {
        self->registerSuccessBlock(self);
        self->registerSuccessBlock = nil;
    }
}


/**
 *注册失败
 * XMPPStreamDelegate Methid:This method is called if registration fails.
 **/
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    if (self->registerFailureBlock) {
        self->registerFailureBlock(self,nil);;
        self->registerFailureBlock = nil;
    }
}

/**
 *发送消息
 */
-(void)sendMessage:(NSString*)message toFriend:(NSString*)friendAccount
{
    NSXMLElement *messageElement = [NSXMLElement elementWithName:@"message" xmlns:@"jabber:client"];
    [messageElement addAttributeWithName:@"from" stringValue:[self hutLifeAccount]];
    [messageElement addAttributeWithName:@"to" stringValue:friendAccount];
    [messageElement addAttributeWithName:@"type" stringValue:@"chat"];
    
    NSXMLElement *bodyElement = [NSXMLElement elementWithName:@"body"];
    [bodyElement setStringValue:message];
    
    [messageElement addChild:bodyElement];
    
    [[self hutXMPPStream] sendElement:messageElement];
}

/**
 *XMPPStreamDelegate Method:These methods are called after their respective XML elements are received on the stream.
 *收到Message
 */

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    //提取消息内容
    NSString *messageContent = [[message elementForName:@"body"] stringValue];
//    NSString *messageContent = [message body];
    
    //提取消息sender的JID
    NSString *senderJID = [[message attributeForName:@"from"] stringValue];
//    NSString *senderJID = [[message from] user];
    
    if ([messageContent isNotEmpty]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HUTManagerDidReceiveMessageNotificationName object:nil userInfo:@{@"senderJID":senderJID,@"messageContent":messageContent}];
    }
}

/**
 *XMPPStreamDelegate Method
 *收到Presence
 */

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    //提取sender的JID
    NSString *senderJID = [[presence attributeForName:@"from"] stringValue];
    //提取type
    NSString *type = [[presence attributeForName:@"type"] stringValue];
    if (nil==type) {
        //提取show
        NSString *show = [[presence elementForName:@"show"] stringValue];
        //提取status
        NSString *status = [[presence elementForName:@"status"] stringValue];
        
    }else if ([type isEqualToString:@"unavailable"]){
        
    }else{
    }
    
    
}

/**
 *XMPPStreamDelegate Method
 *收到iq
 */

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    
    //判断类型
    NSString *type = [[iq attributeForName:@"type"] stringValue];
    
    if ([type isEqualToString:@"result"]) {
        
        NSXMLElement *queryElement = [iq elementForName:@"query"];
        
        if ([[queryElement xmlns] isEqualToString:@"jabber:iq:roster"]) {
            NSArray<NSXMLElement*> *friends = [queryElement elementsForName:@"item"];
            for (NSXMLElement *itemElement in friends) {
                NSString *friendName = [[itemElement attributeForName:@"name"] stringValue];
                NSString *friendJID = [[itemElement attributeForName:@"jid"] stringValue];
                NSLog(@"friendName:%@ friendJID:%@",friendName,friendJID);
            }
        }else if([[queryElement xmlns] isEqualToString:@"jabber:iq:search"]){
            NSLog(@"%@",iq);
        }
        
    }else if([type isEqualToString:@"set"]){
        NSXMLElement *queryElement = [iq elementForName:@"query"];
        /**
         <iq from='juliet@example.com/balcony'
         to='example.com'
         type='result'
         id='a78b4q6ha463'/>
         */
        NSXMLElement *iqElement = [NSXMLElement elementWithName:@"iq" xmlns:@"jabber:client"];
        [iqElement addAttributeWithName:@"from" stringValue:[self hutLifeAccount]];
        [iqElement addAttributeWithName:@"to" stringValue:hutLifeServer];
        [iqElement addAttributeWithName:@"type" stringValue:@"result"];
        [sender sendElement:iqElement];
        
    }else if([type isEqualToString:@"error"]){
    }
    
    return YES;
}

/**
 *获取好友列表
 */

-(NSArray<XMPPUserCoreDataStorageObject*>*)fetchFriendList
{
    //使用CoreData获取数据
    
    // 1.上下文【关联到数据库XMPPRoster.sqlite】
    NSManagedObjectContext *context = [self hutXMPPRosterStorage].mainThreadManagedObjectContext;
    
    // 2.FetchRequest【查哪张表】
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
        //设置约束:挑选当前登录用户的好友
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@",[self hutLifeAccount]];
    request.predicate = pre;
        //设置排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    // 3.执行查询
    NSArray<XMPPUserCoreDataStorageObject*> *friendArray  = [context executeFetchRequest:request error:nil];
    
    if (nil==self->_hutXMPPRosterController) {
        self->_hutXMPPRosterController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        [self->_hutXMPPRosterController setDelegate:self];
        [self->_hutXMPPRosterController performFetch:nil];
    }
    
    return friendArray;

}
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    if (self->_hutXMPPRosterController==controller) {
            [[NSNotificationCenter defaultCenter] postNotificationName:HUTManagerDidFriendListChangedNotificationName object:self];
    }
}

/**
 *删除好友
 */

-(void)deleteFriend:(XMPPUserCoreDataStorageObject*)friendModel;
{
    
    [[self hutXMPPRosterModule] removeUser:[friendModel jid]];
}


/**
 *添加好友
 */
-(void)addFriendWithAccount:(NSString*)account
{
    NSString *friendJID = [NSString stringWithFormat:@"%@@%@",account,hutLifeServer];
    
    [[self hutXMPPRosterModule] subscribePresenceToUser:[XMPPJID jidWithString:friendJID]];
    
    return;
    
    /**
     <presence to='juliet@example.com' type='subscribe'/>
     */
    
    NSXMLElement *presenceElement = [NSXMLElement elementWithName:@"presence" xmlns:@"jabber:client"];
    [presenceElement addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@%@",account,hutLifeServer]];
    [presenceElement addAttributeWithName:@"type" stringValue:@"subscribe"];
    
    [[self hutXMPPStream] sendElement:presenceElement];
}


/**
 *同意添加好友请求
 */
-(void)acceptFriendSubscription:(XMPPJID*)friendAccount
{
    [[self hutXMPPRosterModule] acceptPresenceSubscriptionRequestFrom:friendAccount andAddToRoster:YES];
}

/*
*拒绝添加好友请求
*/
-(void)rejectFriendSubscription:(XMPPJID*)friendAccount
{
    [[self hutXMPPRosterModule] rejectPresenceSubscriptionRequestFrom:friendAccount];
}

/**
 *搜索用户
 */
-(void)searchUserWithAccount:(NSString*)userAccount
{
}


/**
 *获取添加好友请求
 */
-(NSArray<XMPPPresence*>*)getAllPresenceSubscriptionRequest
{
    return [[self presenceSubscriptionRequestArray] copy];
}

/**
 *退出登录
 */
-(void)logout
{
    if ([[self hutXMPPStream] isConnected]) {
        NSXMLElement *logoutPresenceElement = [NSXMLElement elementWithName:@"presence" xmlns:@"jabber:client"];
        [logoutPresenceElement addAttributeWithName:@"from" stringValue:[self hutLifeAccount]];
        [logoutPresenceElement addAttributeWithName:@"to" stringValue:hutLifeServer];
        [logoutPresenceElement addAttributeWithName:@"type" stringValue:@"unavailable"];
        [[self hutXMPPStream] sendElement:logoutPresenceElement];
        [[self hutXMPPStream] disconnect];
    }
}


/**
 *用户名片
 */
-(XMPPvCardTemp*)uservCard
{
    if ([[self hutXMPPvCardTempModule] myvCardTemp]) {
        return [[self hutXMPPvCardTempModule] myvCardTemp];
    }else{
        return [XMPPvCardTemp vCardTemp];
    }
}

/**
 *更新用户名片
 */
-(void)updateUserVCard:(XMPPvCardTemp*)newvCardTemp success:(UserVCardUpdateSuccess)success failure:(UserVCardUpdateFailure)failure
{
    
    self->hutUservCardUpdateSucessBlock = success;
    self->hutUsercCardUpdateFailureBlock = failure;
    
    /**
     NSXMLElement *vCardXML = [NSXMLElement elementWithName:@"vCard" xmlns:@"vcard-temp"];
     XMPPvCardTemp *newvCardTemp = [XMPPvCardTemp vCardTempFromElement:vCardXML];
     [newvCardTemp setNickname:@"aaaaaa"];
     NSArray *interestsArray= [[NSArray alloc] initWithObjects:@"food", nil];
     [newvCardTemp setLabels:interestsArray];
     [newvCardTemp setMiddleName:@"Stt"];
     
     [newvCardTemp setEmailAddresses:[NSMutableArray arrayWithObjects:@"email", nil]];
     
     [xmppvCardTempModule updateMyvCardTemp:newvCardTemp];
     }
     */
    
//    NSXMLElement *vCardXML = [NSXMLElement elementWithName:@"vCard" xmlns:@"vcard-temp"];
//    XMPPvCardTemp *vCardTemp = [XMPPvCardTemp vCardTempFromElement:vCardXML];
    [[self hutXMPPvCardTempModule] updateMyvCardTemp:newvCardTemp];
}


- (void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule
{
    if (self->hutUservCardUpdateSucessBlock) {
        self->hutUservCardUpdateSucessBlock(self);
        self->hutUservCardUpdateSucessBlock = nil;
    }else{
    }
}


- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule failedToUpdateMyvCard:(NSXMLElement *)error
{
    
    if (self->hutUsercCardUpdateFailureBlock) {
        self->hutUsercCardUpdateFailureBlock(self,nil);
        self->hutUsercCardUpdateFailureBlock = nil;
    }else{
    }
}

/**
 *获取与好友的最近一条聊天消息
 */
-(XMPPMessageArchiving_Message_CoreDataObject*)getLastedMessageWithFriend:(XMPPJID*)friendAccount
{
    
    // 上下文
    NSManagedObjectContext *context = [HUTManager sharedHUTManager].hutXMPPMessageStorage.mainThreadManagedObjectContext;
    // 设置查询
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    // 设置条件
    // 1.当前登录用户的JID的消息
    // 2.好友的Jid的消息
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",[[HUTManager sharedHUTManager] hutLifeAccount],[friendAccount bare]];
    request.predicate = pre;
    
    //3.按时间升序
    NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[timeSort];

   return  [[context executeFetchRequest:request error:nil] lastObject];
    
}

-(void)dealloc
{
#pragma mark - TODO
    [self logout];
    
    //关闭相关模块
    [[self hutXMPPReconnectModule] deactivate];
    [[self hutXMPPRosterModule] deactivate];
    [[self hutXMPPvCardAvatarModule] deactivate];
    [[self hutXMPPvCardTempModule] deactivate];
    [[self hutXMPPMessageModule] deactivate];
    
}


@end
