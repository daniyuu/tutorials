//
//  TKMessageManager.h
//  WechatPlugin
//
//  Created by Kagura Chen on 2019/1/2.
//  Copyright © 2019 Kagura Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TKMessageManager : NSObject

+ (instancetype)shareManager;
- (void)sendTextMessage:(id)msgContent toUsrName:(id)toUser delay:(NSInteger)delayTime;

@end

NS_ASSUME_NONNULL_END
