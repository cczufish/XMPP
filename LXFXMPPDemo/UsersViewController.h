//
//  UsersViewController.h
//  LXFXMPPDemo
//
//  Created by iObitLXF on 4/25/13.
//  Copyright (c) 2013 iObitLXF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>//UserListDelegate
@property (weak, nonatomic) IBOutlet UITableView *tabelViewUsers;

@end
