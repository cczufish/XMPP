//
//  MsgSendCell.h
//  LXFXMPPDemo
//
//  Created by iObitLXF on 4/26/13.
//  Copyright (c) 2013 iObitLXF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgSendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBg;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelMsg;

+(MsgSendCell*)getInstanceWithNib;
-(void)setUI:(MessageVO *)aMsg;
@end
