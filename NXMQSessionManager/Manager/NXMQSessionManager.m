//
//  NXMQSessionManager.m
//  ysscw_ios
//
//  Created by next on 2020/7/1.
//  Copyright © 2020 ysscw. All rights reserved.
//

#import "NXMQSessionManager.h"
#import <OpenUDID/OpenUDID.h>

#define MQ_HOST @"111.111.111.111"
#define MQ_PORT 11111

@interface NXMQSessionManager () <MQTTSessionManagerDelegate>
@property (strong, nonatomic) MQTTSessionManager *sessionManager;
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSNumber *> *xTopics;
@property (copy, nonatomic) NXMQMessageHandler messageHandler;
@end

@implementation NXMQSessionManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.xTopics = @{}.mutableCopy;
    }
    return self;
}

+ (NXMQSessionManager *)shareInstance {
    static NXMQSessionManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NXMQSessionManager alloc] init];
    });
    return instance;
}


- (void)connect {
//    NSString *caPath = [[NSBundle mainBundle] pathForResource:@"ios_development_ca" ofType:@"der"];
//    NSString *p12Path = [[NSBundle mainBundle] pathForResource:@"ios_development" ofType:@"p12"];
    NSString *caPath = [[NSBundle mainBundle] pathForResource:@"ios_distribution_ca" ofType:@"der"];
    NSString *p12Path = [[NSBundle mainBundle] pathForResource:@"ios_distribution" ofType:@"p12"];
    NSArray *certificates = [MQTTSSLSecurityPolicyTransport clientCertsFromP12:p12Path passphrase:@"123456"];
    
    MQTTSSLSecurityPolicy *securityPolicy = [MQTTSSLSecurityPolicy policyWithPinningMode:MQTTSSLPinningModeCertificate];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    securityPolicy.validatesCertificateChain = NO;
    securityPolicy.pinnedCertificates = @[[NSData dataWithContentsOfFile:caPath]];
    
    self.sessionManager = MQTTSessionManager.new;
    self.sessionManager.delegate = self;
    
    [self.sessionManager connectTo:MQ_HOST
                              port:MQ_PORT
                               tls:true
                         keepalive:10
                             clean:true
                              auth:true
                              user:@"admin"
                              pass:@"password"
                              will:false
                         willTopic:nil
                           willMsg:nil
                           willQos:0
                    willRetainFlag:false
                      withClientId:[OpenUDID value]
                    securityPolicy:securityPolicy
                      certificates:certificates
                     protocolLevel:3
                    connectHandler:^(NSError *error) {
                
    }];
}

- (void)disconnect {
    
    [self.sessionManager disconnectWithDisconnectHandler:nil];
}


//订阅
- (void)subscribeToTopic:(NSString *)topic {
    self.xTopics[topic] = @(0);
    [self.sessionManager.session subscribeToTopic:topic atLevel:0 subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
        if (error) {
            DDLogVerbose(@"Subscription failed<error: %@>", error.localizedDescription);
        } else {
            DDLogVerbose(@"Subscription sucessfull! topic: %@, Qos: %@", topic, gQoss);
        }
    }];
}


- (void)subscribeToTopics:(NSDictionary<NSString *, NSNumber *> *)topics {
    [self.xTopics addEntriesFromDictionary:topics];
    [self.sessionManager.session subscribeToTopics:topics subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
        if (error) {
            DDLogVerbose(@"Subscription failed<error: %@>", error.localizedDescription);
        } else {
            DDLogVerbose(@"Subscription sucessfull!");
        }
    }];
}


//取消订阅
- (void)unsubscribeTopic:(NSString *)topic {
     [self.xTopics removeObjectForKey:topic];
     [self.sessionManager.session unsubscribeTopic:topic unsubscribeHandler:^(NSError *error) {
         if (error) {
             DDLogVerbose(@"Unsubscribe failed<error: %@>", error.localizedDescription);
         } else {
             DDLogVerbose(@"Unsubscribe sucessfull!");
         }
     }];
}


- (void)unsubscribeTopics:(NSArray<NSString *> *)topics {
    [self.xTopics removeObjectsForKeys:topics];
    [self.sessionManager.session unsubscribeTopics:topics unsubscribeHandler:^(NSError *error) {
        if (error) {
            DDLogVerbose(@"Unsubscribe failed<error: %@>", error.localizedDescription);
        } else {
            DDLogVerbose(@"Unsubscribe sucessfull!");
        }
    }];
}


- (void)sendData:(NSData *)data topic:(NSString *)topic {
    
    [self.sessionManager sendData:data topic:topic qos:0 retain:NO];

}


- (void)receivedMessage:(NXMQMessageHandler)handler {
 
    self.messageHandler = handler;
}


#pragma mark - MQTTSessionManagerDelegate
- (void)handleMessage:(NSData *)data onTopic:(NSString *)topic retained:(BOOL)retained {
    
    self.messageHandler(data, topic);
}


- (void)sessionManager:(MQTTSessionManager *)sessionManager didChangeState:(MQTTSessionManagerState)newState {
    DDLogInfo(@"newState = %d", newState);
    switch (newState) {
        case MQTTSessionManagerStateStarting:
            break;
        case MQTTSessionManagerStateConnecting:
            break;
        case MQTTSessionManagerStateError:
            break;
        case MQTTSessionManagerStateConnected:
            if (self.xTopics.count > 0) {
                [self.sessionManager.session subscribeToTopics:self.xTopics];
            }
            break;
        case MQTTSessionManagerStateClosing:
            break;
        case MQTTSessionManagerStateClosed:
            break;
        default:
            break;
    }
}


@end
