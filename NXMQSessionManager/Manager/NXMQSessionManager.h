//
//  NXMQSessionManager.h
//  ysscw_ios
//
//  Created by next on 2020/7/1.
//  Copyright © 2020 ysscw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MQTTClient/MQTTClient.h>
#import "NXLVTopicsHelper.h"

//NS_ASSUME_NONNULL_BEGIN

typedef void (^NXMQMessageHandler)(id data, NSString *topic);
//typedef void (^NXMQConnectHandler)(NSError *);

@interface NXMQSessionManager : NSObject

+ (NXMQSessionManager *)shareInstance;

- (void)connect;

- (void)disconnect;

//订阅
- (void)subscribeToTopic:(NSString *)topic;

//批量订阅
- (void)subscribeToTopics:(NSDictionary<NSString *, NSNumber *> *)topics;

//取消订阅
- (void)unsubscribeTopic:(NSString *)topic;

//批量取消订阅
- (void)unsubscribeTopics:(NSArray<NSString *> *)topics;

//发送数据
- (void)sendData:(NSData *)data topic:(NSString *)topic;

//接收数据
- (void)receivedMessage:(NXMQMessageHandler)handler;
   
@end

//NS_ASSUME_NONNULL_END
