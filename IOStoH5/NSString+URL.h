//
//  NSString+URL.h
//  IOStoH5
//
//  Created by water on 14-8-15.
//  Copyright (c) 2014年 water. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)

- (NSString *)URLEncodedString;
- (NSString*) URLDecodedString;

- (NSDictionary *) defaultParameters;
- (NSDictionary *) parametersWithSeparator:(NSString *)separator delimiter:(NSString *)delimiter;
- (NSString *) parametersKey;
- (NSString *) parametersData;

@end
