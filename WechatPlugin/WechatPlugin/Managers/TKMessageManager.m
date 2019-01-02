//
//  TKMessageManager.m
//  WechatPlugin
//
//  Created by Kagura Chen on 2019/1/2.
//  Copyright © 2019 Kagura Chen. All rights reserved.
//

#import <objc/runtime.h>
#import "TKMessageManager.h"

@implementation TKMessageManager

+ (instancetype)shareManager {
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)sendTextMessage:(id)msgContent toUsrName:(id)toUser delay:(NSInteger)delayTime {
//    MessageService *service = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
//    NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
//
//    if (delayTime == 0) {
//        [service SendTextMessage:currentUserName toUsrName:toUser msgText:msgContent atUserList:nil];
//        return;
//    }
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [service SendTextMessage:currentUserName toUsrName:toUser msgText:msgContent atUserList:nil];
//        });
//    });
}

@end
