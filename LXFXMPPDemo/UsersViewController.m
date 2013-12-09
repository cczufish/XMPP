//
//  UsersViewController.m
//  LXFXMPPDemo
//
//  Created by iObitLXF on 4/25/13.
//  Copyright (c) 2013 iObitLXF. All rights reserved.
//

#import "UsersViewController.h"
#import "ChatViewController.h"
#import "LoginViewController.h"


@interface UsersViewController ()
{
    //在线用户
    NSMutableArray  *aryOnlineUsers;
    
    //选中的聊天人
    NSString        *strChatUserName;

}
@end

@implementation UsersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"User List";
    
    
    aryOnlineUsers = [NSMutableArray array];
    
    AppDelegate *appDelegate = [self appDelegate];
//    appDelegate.userListDelegate = self;
    [appDelegate setUserListBlocks:^(NSString *aStr) {
        [self newBuddyOnline:aStr];
    } otherBlock:^(NSString *aStr) {
        [self buddyWentOffline:aStr];
    }];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"Login"
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(Account:)];
    self.navigationItem.leftBarButtonItem = item;
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    NSString *login = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    
    if (login) {
        
        if ([[self appDelegate] connect]) {
            NSLog(@"show buddy list");
            
        }
        
    }else {
        
        //设定用户
        [self Account:self];
        
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTabelViewUsers:nil];
    [super viewDidUnload];
}

-(void)Account:(UIViewController *)vc
{
    LoginViewController *controller = [[LoginViewController alloc]init];
    [self presentViewController:controller
                       animated:YES
                     completion:^{
                         
                     }];


}
#pragma mark - 
//取得当前程序的委托
-(AppDelegate *)appDelegate{
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
}
//取得当前的XMPPStream
-(XMPPStream *)xmppStream{
    
    return [[self appDelegate] xmppStream];
}

//在线好友
-(void)newBuddyOnline:(NSString *)buddyName{
    
    if (![aryOnlineUsers containsObject:buddyName]) {
        [aryOnlineUsers addObject:buddyName];
        [self.tabelViewUsers reloadData];
    }
    
}

//好友下线
-(void)buddyWentOffline:(NSString *)buddyName{
    
    [aryOnlineUsers removeObject:buddyName];
    [self.tabelViewUsers reloadData];
    
}
-(void)disconnect
{

}

#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [aryOnlineUsers count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"userCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [aryOnlineUsers objectAtIndex:indexPath.row];
    return cell;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //start a Chat
    strChatUserName = (NSString *)[aryOnlineUsers objectAtIndex:indexPath.row];
    ChatViewController *chatController = [[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
    chatController.chatWithUser = strChatUserName;
    [self.navigationController pushViewController:chatController animated:YES];
}

@end
