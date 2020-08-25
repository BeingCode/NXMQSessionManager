//
//  NXLVTopicsHelper.m
//  ysscw_ios
//
//  Created by next on 2020/7/14.
//  Copyright © 2020 ysscw. All rights reserved.
//

#import "NXLVTopicsHelper.h"

@interface NXLVTopicsHelper ()

@end

@implementation NXLVTopicsHelper

- (instancetype)initWithRid:(NSString *)roomId {
    if (self = [super init]) {
        self.TOPIC_1 = [NSString stringWithFormat:@"#%@", roomId];
        self.TOPIC_2 = [NSString stringWithFormat:@"#%@", roomId];
        self.TOPIC_3 = [NSString stringWithFormat:@"#%@", roomId];
        self.TOPIC_4 = [NSString stringWithFormat:@"#%@", roomId];
        self.TOPIC_5 = [NSString stringWithFormat:@"#%@", roomId];
        self.topics = @{self.TOPIC_1 : @(0),
                        self.TOPIC_2 : @(0),
                        self.TOPIC_3 : @(0),
                        self.TOPIC_4 : @(0),
                        self.TOPIC_5 : @(0)};
    }
    return self;
}

@end

