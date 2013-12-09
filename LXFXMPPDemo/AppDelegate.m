//
//  AppDelegate.m
//  LXFXMPPDemo
//
//  Created by iObitLXF on 4/25/13.
//  Copyright (c) 2013 iObitLXF. All rights reserved.
//

#import "AppDelegate.h"

#import "UsersViewController.h"
#import "Statics.h"

@implementation AppDelegate
@synthesize xmppStream;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[UsersViewController alloc] initWithNibName:@"UsersViewController" bundle:nil];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self.viewController];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)setUserListBlocks:(UserListNewBuddyOnlineBlock )block1 otherBlock:(UserListBuddyWentOfflineBlock)block2
{
    self.blockBuddyWentOffline = block2;
    self.blockNewBuddyOnline = block1;
}
-(void)setChatBlock:(ChatNewMessageReceivedBlock )aBlock
{
    self.blockNewMessageReceived = aBlock;
}

#pragma mark - 
//是否连接
-(BOOL)connect
{
    [self setupStream];
    
    //从本地取得用户名，密码和服务器地址
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userId = [defaults stringForKey:USERID];
    NSString *pass = [defaults stringForKey:PASSWORD];
    NSString *server = [defaults stringForKey:SERVER];
    
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    
    if (userId == nil || pass == nil) {
        return NO;
    }
    
    //设置用户
    [xmppStream setMyJID:[XMPPJID jidWithString:userId]];
    //设置服务器
    [xmppStream setHostName:server];
    //密码
    strPassword = pass;
    
    //连接服务器
    NSError *error = nil;
    if (![xmppStream connect:&error]) {
        NSLog(@"cant connect %@", server);
        return NO;
    }
    
    return YES;
}

//断开连接
-(void)disconnect
{
    [self goOffline];
    [xmppStream disconnect];
}

//设置xmppStream
-(void)setupStream
{
    xmppStream = [[XMPPStream alloc]init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_current_queue()];

}

//上线
-(void)goOnline
{
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];

}

//下线
-(void)goOffline
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];

}

#pragma mark - xmppStreamDelegate
//连接服务器
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    
    bIsOpen = YES;
    NSError *error = nil;
    //验证密码
    [[self xmppStream] authenticateWithPassword:strPassword error:&error];
    
}

//验证通过
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    
    [self goOnline];
}

//收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
    NSLog(@"message = %@", message);
    
    NSString *idStr = [[message attributeForName:@"id"] stringValue];
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
    NSString *to = [[message attributeForName:@"to"] stringValue];
    NSString *strTime = [Statics getCurrentTime];
    
    if (msg && from) {
        MessageVO *aVo = [[MessageVO alloc]init];
        aVo.strId = idStr;
        aVo.strText = msg;
        aVo.strFromUsername = from;
        aVo.strToUsername = to;
        aVo.msgType = MsgType_Receive;
        aVo.strTime = strTime;
        
        //消息委托(这个后面讲)
//        [self.chatDelegate newMessageReceived:aVo];
        self.blockNewMessageReceived(aVo);

    }
    
}

//收到好友状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    
    NSLog(@"presence = %@", presence);
    
    //取得好友状态
    NSString *presenceType = [presence type]; //online/offline
    //当前用户
    NSString *userId = [[sender myJID] user];
    //在线用户
    NSString *presenceFromUser = [[presence from] user];
    
    if (![presenceFromUser isEqualToString:userId]) {
        
        //在线状态
        if ([presenceType isEqualToString:@"available"]) {
            
            //用户列表委托(后面讲)
//            [self.userListDelegate newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, STRLOCAL]];
            self.blockNewBuddyOnline([NSString stringWithFormat:@"%@@%@", presenceFromUser, STRLOCAL]);
            
        }else if ([presenceType isEqualToString:@"unavailable"]) {
            //用户列表委托(后面讲)
//            [self.userListDelegate buddyWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, STRLOCAL]];
            self.blockBuddyWentOffline([NSString stringWithFormat:@"%@@%@", presenceFromUser, STRLOCAL]);
        }
        
    }
    
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    
    [self disconnect];
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    [self connect];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
