//
//  WeChat+hook.m
//  WechatPlugin
//
//  Created by Kagura Chen on 2019/1/2.
//  Copyright © 2019 Kagura Chen. All rights reserved.
//

#import "WeChat+hook.h"
#import <objc/runtime.h>
#import "Utils/TKHelper.h"
#import "WechatPlugin.h"
#import "Managers/TKMessageManager.h"

@implementation NSObject(WeChatHook)

+ (void)hookWeChat {
    
    tk_hookMethod(objc_getClass("MessageService"), @selector(onRevokeMsg:), [self class], @selector(hook_onRevokeMsg:));
  
    //      微信消息同步
    tk_hookMethod(objc_getClass("MessageService"), @selector(OnSyncBatchAddMsgs:isFirstSync:), [self class], @selector(hook_OnSyncBatchAddMsgs:isFirstSync:));
}


- (void)hook_onRevokeMsg:(id)msg {
    NSLog(@"=== TK-LOG-msg = %@===",msg);
    [self hook_onRevokeMsg:msg];
}

/**
hook 微信消息同步

*/
- (void)hook_OnSyncBatchAddMsgs:(NSArray *)msgs isFirstSync:(BOOL)arg2 {
    [self hook_OnSyncBatchAddMsgs:msgs isFirstSync:arg2];
    
    [msgs enumerateObjectsUsingBlock:^(AddMsg *addMsg, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *now = [NSDate date];
        NSTimeInterval nowSecond = now.timeIntervalSince1970;
        if (nowSecond - addMsg.createTime > 180) {      // 若是3分钟前的消息，则不进行自动回复与远程控制。
            return;
        }
        
        [self autoReplyWithMsg:addMsg];
        
//        NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
//        if ([addMsg.fromUserName.string isEqualToString:currentUserName] &&
//            [addMsg.toUserName.string isEqualToString:currentUserName]) {
//            [self remoteControlWithMsg:addMsg];
//            [self replySelfWithMsg:addMsg];
//        }
    }];
}


#pragma mark - Other
/**
 自动回复
 
 @param addMsg 接收的消息
 */
- (void)autoReplyWithMsg:(AddMsg *)addMsg {
    //    addMsg.msgType != 49
//    if (addMsg.msgType != 1 && addMsg.msgType != 3) return;
    
    NSString *userName = addMsg.fromUserName.string;
    
    [self replyWithMsg:addMsg];
//    MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
//    WCContactData *msgContact = [sessionMgr getContact:userName];
//    if ([msgContact isBrandContact] || [msgContact isSelf]) {
//        //        该消息为公众号或者本人发送的消息
//        return;
//    }
//    NSArray *autoReplyModels = [[TKWeChatPluginConfig sharedConfig] autoReplyModels];
//    [autoReplyModels enumerateObjectsUsingBlock:^(TKAutoReplyModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (!model.enable) return;
//        if (!model.replyContent || model.replyContent.length == 0) return;
//
//        if (model.enableSpecificReply) {
//            if ([model.specificContacts containsObject:userName]) {
//                [self replyWithMsg:addMsg model:model];
//            }
//            return;
//        }
//        if ([addMsg.fromUserName.string containsString:@"@chatroom"] && !model.enableGroupReply) return;
//        if (![addMsg.fromUserName.string containsString:@"@chatroom"] && !model.enableSingleReply) return;
//
//        [self replyWithMsg:addMsg model:model];
//    }];
}

- (void)replyWithMsg:(AddMsg *)addMsg {
    NSString *msgContent = addMsg.content.string;
    if ([addMsg.fromUserName.string containsString:@"@chatroom"]) {
        NSRange range = [msgContent rangeOfString:@":\n"];
        if (range.length > 0) {
            msgContent = [msgContent substringFromIndex:range.location + range.length];
        }
    }
    
    NSArray *replyArray = @[@"test reply"];
    int index = arc4random() % replyArray.count;
    NSString *randomReplyContent = replyArray[index];
    NSInteger delayTime = 0;
    

        NSArray * keyWordArray = @[@"test"];
        [keyWordArray enumerateObjectsUsingBlock:^(NSString *keyword, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([keyword isEqualToString:@"*"] || [msgContent isEqualToString:keyword]) {
//                [[TKMessageManager shareManager] sendTextMessage:randomReplyContent toUsrName:addMsg.fromUserName.string delay:delayTime];
                    MessageService *service = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
                    NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
                
                    if (delayTime == 0) {
                        [service SendTextMessage:currentUserName toUsrName:addMsg.fromUserName msgText:msgContent atUserList:nil];
                        return;
                    }
                *stop = YES;
            }
        }];
    }


///**
// 远程控制
//
// @param addMsg 接收的消息
// */
//- (void)remoteControlWithMsg:(AddMsg *)addMsg {
//    NSDate *now = [NSDate date];
//    NSTimeInterval nowSecond = now.timeIntervalSince1970;
//    if (nowSecond - addMsg.createTime > 10) {      // 若是10秒前的消息，则不进行远程控制。
//        return;
//    }
//    if (addMsg.msgType == 1 || addMsg.msgType == 3) {
//        [TKRemoteControlManager executeRemoteControlCommandWithMsg:addMsg.content.string];
//    } else if (addMsg.msgType == 34) {
//        //      此为语音消息
//        MessageService *msgService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
//        MessageData *msgData = [msgService GetMsgData:addMsg.fromUserName.string svrId:addMsg.newMsgId];
//        long long mesSvrID = msgData.mesSvrID;
//        NSString *sessionName = msgData.fromUsrName;
//        [msgService TranscribeVoiceMessage:msgData completion:^ {
//            MessageData *callbackMsgData = [msgService GetMsgData:sessionName svrId:mesSvrID];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [TKRemoteControlManager executeRemoteControlCommandWithVoiceMsg:callbackMsgData.msgVoiceText];
//            });
//        }];
//    }
//}
//
//- (void)replySelfWithMsg:(AddMsg *)addMsg {
//    if (addMsg.msgType != 1 && addMsg.msgType != 3) return;
//
//    if ([addMsg.content.string isEqualToString:TKLocalizedString(@"assistant.remoteControl.getList")]) {
//        NSString *callBack = [TKRemoteControlManager remoteControlCommandsString];
//        [[TKMessageManager shareManager] sendTextMessageToSelf:callBack];
//    }
//}

@end
