//
//  MessageVO.h
//  LXFXMPPDemo
//
//  Created by iObitLXF on 4/26/13.
//  Copyright (c) 2013 iObitLXF. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    MsgType_Receive=0,
    MsgType_Send,
    
}MsgType;

@interface MessageVO : NSObject

@property (nonatomic, copy) NSString *strId;
@property (nonatomic, copy) NSString *strText;
@property (nonatomic, copy) NSString *strUserid;
@property (nonatomic, copy) NSString *strTime;
@property (nonatomic, copy) NSString *strFromUsername;
@property (nonatomic, copy) NSString *strToUsername;
@property (nonatomic, assign)MsgType msgType;
@end
