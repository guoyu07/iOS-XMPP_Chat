//
//  XMPPChatManager.h
//  XMPPWeChat
//
//  Created by hebiao on 15/8/13.
//  Copyright (c) 2015年 Hebiao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NSManagedObjectContext;
@class XMPPvCardAvatarModule;
@class XMPPJID;
@class XMPPStream;


@interface XMPPChatManager : NSObject



+(instancetype)shareInstance;

-(void)loginWith:(NSString *)userName password:(NSString *)passWord;
-(void)registerWith:(NSString *)userName password:(NSString *)passWord;

-(BOOL)isLogin;
-(void)autoLogin;
-(void)loginOut;


-(void)onLine;
-(void)offLine;
-(void)addFriend:(NSString *)userName;
-(void)removeFriend:(NSString *)userName;


-(void)sendMessage:(NSString *)msgBody toUser:(XMPPJID *)jid;


-(XMPPvCardAvatarModule *)vatarModule;

-(NSManagedObjectContext *)rosterContext;
-(NSManagedObjectContext *)messageContext;



@end
