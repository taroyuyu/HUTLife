//
//  HUTManager.h
//  HUT
//
//  Created by Lingyu on 16/1/26.
//  Copyright © 2016年 Lingyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XMPPvCardTemp.h"
@class UserModel;
@class TimeTable;
@class StudentGradeItem;
@class TimeLineModel;
@class FriendModel;
@class ChatMessageModel;
@class XMPPUserCoreDataStorageObject;
@class XMPPMessageArchiving_Message_CoreDataObject;
@class UIImage;
@class XMPPJID;
@class XMPPMessageArchivingCoreDataStorage;
@class XMPPMessage;
@class XMPPPresence;
extern NSString * const HUTManagerDidFriendListChangedNotificationName;
extern NSString * const HUTManagerDidReceivePresenceSubscriptionRequestNotificationName;
extern NSString * const HUTManagerDidReceiveMessageNotificationName;
@class HUTManager;


extern  NSInteger const HUTLifeConnectError;//网络连接异常
extern  NSInteger const HUTLifePasswordError;//密码错误

typedef void (^LoginSuccess)(HUTManager* manager);
typedef void (^LoginFailure)(HUTManager *manager,NSError *error);

typedef void (^RegisterSuccess)(HUTManager* manager);
typedef void (^RegisterFailure)(HUTManager *manager,NSError *error);

typedef void (^UserVCardUpdateSuccess)(HUTManager *manager);
typedef void (^UserVCardUpdateFailure)(HUTManager *manager,NSError*error);


@interface HUTManager : NSObject
@property(nonatomic,strong)UserModel *user;
@property(nonatomic,strong)XMPPMessageArchivingCoreDataStorage *hutXMPPMessageStorage;
+(instancetype)sharedHUTManager;
+(void)cleanData;


#pragma mark - HUTXMPP

/**
 *登录HUTXMPP服务器
 *account不需要指定域名
 */
-(void)loginHUTLifeWithAccount:(NSString*)account andPassword:(NSString*)password success:(LoginSuccess)success failure:(LoginFailure)failure;

/**
 *注册账号
 */
-(void)registerHUTLifeAccountWith:(NSString*)account andPassword:(NSString*)password success:(RegisterSuccess)success failure:(RegisterFailure)failure;
/**
 *当前用户的帐号
 */
-(NSString*)hutLifeAccount;

/**
 *获取好友列表
 */
-(NSArray<XMPPUserCoreDataStorageObject*>*)fetchFriendList;

/**
 *添加好友
 */
-(void)addFriendWithAccount:(NSString*)account;

/**
 *同意添加好友请求
 */
-(void)acceptFriendSubscription:(XMPPJID*)friendAccount;

/**
 *拒绝添加好友请求
 */
-(void)rejectFriendSubscription:(XMPPJID*)friendAccount;

/**
 *删除好友
 */
-(void)deleteFriend:(XMPPUserCoreDataStorageObject*)friendModel;

/**
 *获取用户的电子名片
 */
-(XMPPvCardTemp*)friendvCardTempWithAccount:(XMPPJID*)account;

/**
 *获取用户的存储模型
 */
-(XMPPUserCoreDataStorageObject*)friendModelWithAccount:(XMPPJID*)account;

/**
 *发送文本消息
 */
-(void)sendChatMessage:(XMPPMessage*)message;

/**
 *搜索用户
 */
-(void)searchUserWithAccount:(NSString*)userAccount;

/**
 *获取添加好友请求
 */
-(NSArray<XMPPPresence*>*)getAllPresenceSubscriptionRequest;

/**
 *用户名片
 */
-(XMPPvCardTemp*)uservCard;


/**
 *更新用户名片
 */
-(void)updateUserVCard:(XMPPvCardTemp*)newvCardTemp success:(UserVCardUpdateSuccess)success failure:(UserVCardUpdateFailure)failure;

/**
 *获取与好友的最近一条聊天消息
 */
-(XMPPMessageArchiving_Message_CoreDataObject*)getLastedMessageWithFriend:(XMPPJID*)friendAccount;


#pragma mark - HUTLife

/**
 *获取最新的登陆界面验证码
 */
-(void)getLatestVerifyCodeWithSuccessBlock:(void (^)(NSData *))success failureBlock:(void (^)(NSError *))faiure;

/**
 *用户登录
 *请确保验证码有效
 */
-(void)loginWithUserName:(NSString*)userName userPassword:(NSString*)userPassword andVerifyCode:(NSString*)verifyCode withSuccessBlock:(void(^)())success failureBlock:(void(^)(NSError *))failure;

/**
 *获取用户信息
 */
-(void)getUserInfoWithSuccess:(void (^)(UserModel*))success andFailur:(void(^)(NSError*))failure;

/**
 *获取课表
 */
-(void)enquireClassTimeTableWithSuccess:(void (^)(TimeTable*))success andFailure:(void(^)(NSError*))failure;

/**
 *获取成绩
 */
-(void)enquireUserSchoolRecordsWithSuccess:(void (^)(NSArray<StudentGradeItem*>*))success andFailure:(void(^)(NSError* ))failure;

/**
 *获取TimeLine
 */
-(void)refreshNewTimeLineWithSuccess:(void(^)(NSArray<TimeLineModel*>*))success andFailure:(void(^)(NSError*))failure;

@end
