//
//  XMPPChatManager.m
//  XMPPWeChat
//
//  Created by hebiao on 15/8/13.
//  Copyright (c) 2015年 Hebiao. All rights reserved.
//

#import "XMPPChatManager.h"
#import "XMPPFramework.h"
#import "HeadFile.h"



#define ONLINETYPE @"available"
#define OFFLINETYPE @"unavailable"

#define USER_NAME @"user_name"
#define PASS_WORD @"pass_word"

typedef NS_ENUM(NSInteger,ConnectType){
    ConnectTypeNone,
    ConnectTypeLogin,
    ConnectTypeRegister
};




@interface XMPPChatManager()<XMPPStreamDelegate>{
    
    XMPPStream *_xmppStream;
    XMPPRoster *_xmppRoster;
    XMPPvCardTempModule *_vmodule;
    XMPPvCardAvatarModule *_xmppAvate;
    
    
    NSString *_userName;
    NSString *_passWord;
    
    ConnectType connectType;
    
    
}


@end


@implementation XMPPChatManager

+(instancetype)shareInstance{
    
    static XMPPChatManager *shareIns=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareIns=[[XMPPChatManager alloc] init];
    });
    
    
    return shareIns;
}

-(id) init{
    
    if (self =[super init]) {
        
        
        connectType=ConnectTypeNone;
        _xmppStream=[[XMPPStream alloc] init];
        _xmppStream.hostName=@"192.168.1.180";
        _xmppStream.hostPort=5222;
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        [self configure];
    }
    
    return self;
}

-(void)configure{
   XMPPRosterCoreDataStorage *storage=[XMPPRosterCoreDataStorage sharedInstance];
    _xmppRoster=[[XMPPRoster alloc] initWithRosterStorage:storage];
//    _xmppRoster.autoAcceptKnownPresenceSubscriptionRequests=NO;
    [_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [_xmppRoster activate:_xmppStream];
    
    
    XMPPvCardCoreDataStorage *vStorage=[XMPPvCardCoreDataStorage sharedInstance];
    _vmodule=[[XMPPvCardTempModule alloc] initWithvCardStorage:vStorage];
    [_vmodule activate:_xmppStream];
     
    
    _xmppAvate=[[XMPPvCardAvatarModule alloc]initWithvCardTempModule:_vmodule];
    [_xmppAvate activate:_xmppStream];
    
    
}


-(void)loginWith:(NSString *)userName password:(NSString *)passWord{
    
    _userName=userName;
    _passWord=passWord;
    
    if ([_xmppStream isConnected]) {
        [_xmppStream authenticateWithPassword:passWord error:nil];
    }else{
        
        connectType=ConnectTypeLogin;
        
        _xmppStream.myJID=[XMPPJID jidWithString:userName];
        [_xmppStream connectWithTimeout:100 error:nil];
        
    }
}

-(void)registerWith:(NSString *)userName password:(NSString *)passWord{
    
    _userName=userName;
    _passWord=passWord;
    
    if ([_xmppStream isConnected]) {
        
        [_xmppStream registerWithPassword:passWord error:nil];
        
    }else{
         connectType=ConnectTypeRegister;
        _xmppStream.myJID=[XMPPJID jidWithString:userName];
        [_xmppStream connectWithTimeout:100 error:nil];
    }
 
}

-(BOOL)isLogin{
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    _userName=[def objectForKey:USER_NAME];
    _passWord=[def objectForKey:PASS_WORD];
    
    if (_userName.length&&_passWord.length) {
        return YES;
    }
    
    return NO;
}
-(void)autoLogin{
    [self loginWith:_userName password:_passWord];
}
-(void)loginOut{
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    [def setObject:_userName forKey:USER_NAME];
    [def setObject:_passWord forKey:PASS_WORD];
    [def synchronize];

    
     connectType=ConnectTypeNone;
    [self offLine];
    [_xmppStream disconnect];
}
-(void)onLine{
    
    XMPPPresence *presence=[XMPPPresence presenceWithType:ONLINETYPE];
    [_xmppStream sendElement:presence];
    
}
-(void)offLine{
    XMPPPresence *presence=[XMPPPresence presenceWithType:OFFLINETYPE];
    [_xmppStream sendElement:presence];
}

-(void)addFriend:(NSString *)userName{
    XMPPJID *jid=[XMPPJID jidWithString:userName];
    [_xmppRoster addUser:jid withNickname:nil];
    
    
}
-(void)removeFriend:(NSString *)userName{
    XMPPJID *jid=[XMPPJID jidWithString:userName];
    [_xmppRoster removeUser:jid];
    
    
}



-(void)sendMessage:(NSString *)msgBody toUser:(XMPPJID *)jid{
    
    XMPPMessage *e = [XMPPMessage messageWithType:@"chat" to:jid];
    [e addBody:msgBody];
    [_xmppStream sendElement:e];
}

-(XMPPvCardAvatarModule *)vatarModule{
    
    return _xmppAvate;
    
}
-(void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    
//    NSLog(@"=================%@=",presence);
    NSString *type=[presence type];
    
    if ([type isEqualToString:@"unsubscribe"]) {
        [_xmppRoster removeUser:presence.from];
    }else if ([type isEqualToString:@"subscribe"]){
        [_xmppRoster acceptPresenceSubscriptionRequestFrom:presence.from andAddToRoster:YES];
//        [_xmppRoster rejectPresenceSubscriptionRequestFrom:presence.from];
        
    }
    
}

//// 获取消息 的 接口
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
    NSString *body = [[message elementForName:@"body"] stringValue];
    NSString *displayName = [[message from]bare];

//     NSLog(@"==========%@=======%@=",body,displayName);
    
    /*
     JSQMessage *message = [JSQMessage messageWithSenderId:dic[@"userId"]
     displayName:dic[@"display"]
     text:dic[@"msg"]];
     
     */
    
    if (body!=nil) {
        NSDictionary *info=@{@"userId":message.from.user,@"display":displayName,@"msg":body};
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_RECIVED_MSG_5 object:nil userInfo:info];
    }
    
  
}


- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(NSXMLElement *)item{
    
    
    
    
}

-(void)acceptPresenceSubscriptionRequestFrom:(XMPPJID *)jid andAddToRoster:(BOOL)flag{
    
 
    
}


- (void)rejectPresenceSubscriptionRequestFrom:(XMPPJID *)jid{
  
}

-(NSManagedObjectContext *)rosterContext{
    
    XMPPRosterCoreDataStorage *storage=_xmppRoster.xmppRosterStorage;
    
    return [storage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)messageContext  //消息模块
{
    XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    return [storage mainThreadManagedObjectContext];
}

-(void)xmppStreamWillConnect:(XMPPStream *)sender{
    
    
}
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    
    
    if (connectType==ConnectTypeLogin) {
        [self loginWith:_userName password:_passWord];
    }else if (connectType==ConnectTypeRegister){
        [self registerWith:_userName password:_passWord];
    }
    
 
    
    
    
}

-(void)xmppStreamConnectDidTimeout:(XMPPStream *)sender{
    
    connectType=ConnectTypeNone;
    
    
}

-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
   
    connectType=ConnectTypeNone;
    
}

-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    [def setObject:_userName forKey:USER_NAME];
    [def setObject:_passWord forKey:PASS_WORD];
    [def synchronize];
    
     [self onLine];
    [self postNotice:NOTICE_LOGIN_SUC_1];
    
}
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    [sender disconnect];
    
    
 
}


- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    [def setObject:_userName forKey:USER_NAME];
    [def setObject:_passWord forKey:PASS_WORD];
    [def synchronize];
    
    
    [self onLine];
    [self postNotice:NOTICE_REGISTER_SUC_3];
}
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error{
    
     [sender disconnect];
 
}




-(void)postNotice:(NSString *)noticeName{
    [[NSNotificationCenter defaultCenter] postNotificationName:noticeName object:nil];
}

@end
