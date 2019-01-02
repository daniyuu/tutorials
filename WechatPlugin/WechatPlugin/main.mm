//
//  main.m
//  WechatPlugin
//
//  Created by Kagura Chen on 2019/1/2.
//  Copyright © 2019 Kagura Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeChat+hook.h"

static void __attribute__((constructor))initialize(void) {
    NSLog(@"++++++ WechatPlugin loaded +++++");
    [NSObject hookWeChat];
}
