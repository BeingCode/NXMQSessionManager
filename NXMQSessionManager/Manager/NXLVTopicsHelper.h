//
//  NXLVTopicsHelper.h
//  ysscw_ios
//
//  Created by next on 2020/7/14.
//  Copyright © 2020 ysscw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//直播
@interface NXLVTopicsHelper : NSObject

@property (nonatomic, copy) NSString *TOPIC_1;

@property (nonatomic, copy) NSString *TOPIC_2;

@property (nonatomic, copy) NSString *TOPIC_3;

@property (nonatomic, copy) NSString *TOPIC_4;

@property (nonatomic, copy) NSString *TOPIC_5;

@property (nonatomic, strong) NSDictionary<NSString *, NSNumber *> *topics;

- (instancetype)initWithRid:(NSString *)roomId;

@end


NS_ASSUME_NONNULL_END
