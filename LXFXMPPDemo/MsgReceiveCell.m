//
//  MsgReceiveCell.m
//  LXFXMPPDemo
//
//  Created by iObitLXF on 4/26/13.
//  Copyright (c) 2013 iObitLXF. All rights reserved.
//

#import "MsgReceiveCell.h"

@implementation MsgReceiveCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(MsgReceiveCell*)getInstanceWithNib
{
    MsgReceiveCell *cell = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"MsgReceiveCell" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[MsgReceiveCell class]]){
            
            cell = (MsgReceiveCell *)obj;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            break;
        }
    }
    return cell;
}
-(void)setUI:(MessageVO *)aMsg
{
    UIImage *img = [UIImage imageNamed:@"chat_pop_left.png"];
//    CGSize imgSize = img.size;
    self.imageViewBg.image = [img stretchableImageWithLeftCapWidth:22.0 topCapHeight:24.0];
    self.labelName.text = aMsg.strFromUsername;
    self.labelMsg.text = aMsg.strText;
    self.labelTime.text = aMsg.strTime;
}

@end
