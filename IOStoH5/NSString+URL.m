//
//  NSString+URL.m
//  IOStoH5
//
//  Created by water on 14-8-15.
//  Copyright (c) 2014年 water. All rights reserved.
//

#import "NSString+URL.h"

#define postman @"/postman://"

@implementation NSString (Utils)


-(NSDictionary *) defaultParameters{
    NSString *decodeUrl = [self URLDecodedString];
    
    NSString *dataUrl = [decodeUrl parametersData];
    
    return [dataUrl parametersWithSeparator:@"=" delimiter:@"&"];
}
//解析url字符串对
- (NSDictionary *)parametersWithSeparator:(NSString *)separator delimiter:(NSString *)delimiter{
    
    NSArray *parameterPairs =[self componentsSeparatedByString:delimiter];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:[parameterPairs count]];
    
    for (NSString *currentPair in parameterPairs) {
        
        NSRange range = [currentPair rangeOfString:separator];
        
        if(range.location == NSNotFound)
            
            continue;
        
        NSString *key = [currentPair substringToIndex:range.location];
        
        NSString *value =[currentPair substringFromIndex:range.location + 1];
        
        [parameters setObject:value forKey:key];
        
    }
    
    return parameters;
    
}

- (NSString *)parametersKey{
    if ([self hasPrefix:postman]) {
        return [self substringFromIndex:postman.length];
    }
    return nil;
}

- (NSString *)parametersData{
    NSRange range = [self rangeOfString:@"?"];
    
    if(range.location != NSNotFound){
        return [self substringFromIndex:range.location + 1];
    }
    return nil;
}

//url编码
- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}
//url解码
- (NSString*)URLDecodedString
{
    NSString *result = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)self, CFSTR(""),kCFStringEncodingUTF8);CFSTR(""),kCFStringEncodingUTF8;
    [result autorelease];
    return result;
}
@end
