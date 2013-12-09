//
//  AppDelegate.h
//  LXFXMPPDemo
//
//  Created by iObitLXF on 4/25/13.
//  Copyright (c) 2013 iObitLXF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPP.h"
#import "MessageVO.h"

@class UsersViewController;

/*************用代理实现（若用代理，则把当前关于代理的代码解除注释，同时在相关VC的.h文件加入代理，然后把关于Block的代码注释掉）***************/
//@protocol UserListDelegate;
//@protocol ChatDelegate;

//用Block
typedef void (^UserListNewBuddyOnlineBlock)(NSString *aStr);
typedef void (^UserListBuddyWentOfflineBlock)(NSString *aStr);

typedef void (^ChatNewMessageReceivedBlock)(MessageVO *aMsgVO);

@interface AppDelegate : UIResponder <UIApplicationDelegate,XMPPStreamDelegate>
{
    XMPPStream      *xmppStream;
    NSString        *strPassword;
    BOOL            bIsOpen;

}
@property (strong, nonatomic)   UIWindow *window;
@property (strong, readonly)    XMPPStream      *xmppStream;

@property (strong, nonatomic)   UsersViewController *viewController;

//@property (strong, nonatomic) id<UserListDelegate> userListDelegate;
//@property (strong, nonatomic) id<ChatDelegate> chatDelegate;

@property (nonatomic,strong)UserListNewBuddyOnlineBlock    blockNewBuddyOnline;
@property (nonatomic,strong)UserListBuddyWentOfflineBlock    blockBuddyWentOffline;
@property (nonatomic,strong)ChatNewMessageReceivedBlock    blockNewMessageReceived;

//是否连接
-(BOOL)connect;

//断开连接
-(void)disconnect;

//设置xmppStream
-(void)setupStream;

//上线
-(void)goOnline;

//下线
-(void)goOffline;

-(void)setUserListBlocks:(UserListNewBuddyOnlineBlock )block1 otherBlock:(UserListBuddyWentOfflineBlock)block2;
-(void)setChatBlock:(ChatNewMessageReceivedBlock )aBlock;

@end

//@protocol UserListDelegate <NSObject>
//-(void)newBuddyOnline:(NSString *)buddyName;
//-(void)buddyWentOffline:(NSString *)buddyName;
//-(void)disconnect;
//@end

//@protocol ChatDelegate <NSObject>
//-(void)newMessageReceived:(MessageVO *)aMsgVO;
//@end