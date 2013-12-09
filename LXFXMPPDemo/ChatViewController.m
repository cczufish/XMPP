//
//  ChatViewController.m
//  LXFXMPPDemo
//
//  Created by iObitLXF on 4/25/13.
//  Copyright (c) 2013 iObitLXF. All rights reserved.
//

#import "ChatViewController.h"
#import "MsgReceiveCell.h"
#import "MsgSendCell.h"
#import "Statics.h"

@interface ChatViewController ()
{
    NSMutableArray *aryMessages;
    
}
@end

@implementation ChatViewController

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
     self.title = self.chatWithUser;
    
    aryMessages = [NSMutableArray array];
    
    AppDelegate *appDelegate = [self appDelegate];
//    appDelegate.chatDelegate = self;
    [appDelegate setChatBlock:^(MessageVO *aMsgVO) {
        [self newMessageReceived:aMsgVO];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTabelViewChat:nil];
    [self setViewTool:nil];
    [self setTextFieldTool:nil];
    [self setButtonSend:nil];
    [super viewDidUnload];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat screenHeight = self.view.bounds.size.height;
    __block CGRect frame = self.viewTool.frame;
    
    if (frame.origin.y != screenHeight - keyboardSize.height - 40.) {
        frame.origin.y = screenHeight - keyboardSize.height - 40.;//lxf
        
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.viewTool.frame = frame;
                             
                         } completion:^(BOOL finished) {
                            self.viewTool.frame = frame;
                         }];
        
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    
    
    CGFloat screenHeight = self.view.bounds.size.height;
    __block CGRect frame = self.viewTool.frame;
    frame.origin.y = screenHeight- 40;//lxf
    self.viewTool.frame = frame;
    
    //    [UIView animateWithDuration:fAniTimeSecond animations:^{
    //        self.viewItems.frame = frame;
    //    }];
}


- (IBAction)sendButton:(id)sender {
    
    //本地输入框中的信息
    NSString *message = self.textFieldTool.text;
    
    if (message.length > 0) {
        
        //XMPPFramework主要是通过KissXML来生成XML文件
        //生成<body>文档
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:message];
        
        //生成XML消息文档
        NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
        //消息类型
        [mes addAttributeWithName:@"type" stringValue:@"chat"];
        //发送给谁
        [mes addAttributeWithName:@"to" stringValue:self.chatWithUser];
        //由谁发送
        [mes addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] stringForKey:USERID]];
        //组合
        [mes addChild:body];
        
        //发送消息
        [[self xmppStream] sendElement:mes];
        
        self.textFieldTool.text = @"";
        [self.textFieldTool resignFirstResponder];
        
        MessageVO *aVo = [[MessageVO alloc]init];
        aVo.strText = message;
        aVo.strFromUsername = @"You";
        aVo.strToUsername = self.chatWithUser;
        aVo.msgType = MsgType_Send;
        NSString *strTime = [Statics getCurrentTime];
        aVo.strTime = strTime;
        
        [aryMessages addObject:aVo];
        
        //重新刷新tableView
        [self.tabelViewChat reloadData];
        
    }
    
    
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

#pragma mark KKMessageDelegate
-(void)newMessageReceived:(MessageVO *)aMsgVO{
    
    [aryMessages addObject:aMsgVO];
    
    [self.tabelViewChat reloadData];
    
}

#pragma mark -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [aryMessages count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MessageVO *msg = [aryMessages objectAtIndex:indexPath.row];
    
    if (msg.msgType == MsgType_Receive) {
        NSString *CellIdentifier = @"MsgReceiveCell";
        MsgReceiveCell *cell = (MsgReceiveCell *)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            
            cell = [MsgReceiveCell getInstanceWithNib];
        }
        [cell setUI:msg];
        return cell;
    }
    else if (msg.msgType == MsgType_Send) {
        NSString *CellIdentifier = @"MsgSendCell";
        MsgSendCell *cell = (MsgSendCell *)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            
            cell = [MsgSendCell getInstanceWithNib];
        }
        [cell setUI:msg];
        return cell;
    }
    return nil;
    
}
@end
