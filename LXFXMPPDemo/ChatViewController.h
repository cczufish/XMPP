//
//  ChatViewController.h
//  LXFXMPPDemo
//
//  Created by iObitLXF on 4/25/13.
//  Copyright (c) 2013 iObitLXF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>//ChatDelegate
@property (weak, nonatomic) IBOutlet UITableView *tabelViewChat;
@property (weak, nonatomic) IBOutlet UIView *viewTool;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTool;
@property (weak, nonatomic) IBOutlet UIButton *buttonSend;

@property (strong, nonatomic) NSString *chatWithUser;
@end
