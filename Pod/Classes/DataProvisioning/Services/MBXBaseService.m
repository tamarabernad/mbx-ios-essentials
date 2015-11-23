/*
 
 Copyright (c) 2015 Tamara Bernad
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import "MBXBaseService.h"
@interface MBXBaseService()

@end
@implementation MBXBaseService
- (id)initWithParser:(id<MBXServiceParserProtocol>)parser
        AndConnector:(id<MBXServiceConnectorProtocol>)connector{
    
    if(!(self = [super init]))return nil;
    
    self.parser = parser;
    self.connector = connector;
    
    return self;
}
- (void)getObjectsWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [self.connector getObjectsWithSuccess:^(id responseObject) {
        if(self.parser != nil)
            [self.parser processDataArray:responseObject WithCompletion:success];
        else
            success(responseObject);
    } failure:failure];
}
- (void)getObjectWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [self.connector getObjectWithSuccess:^(id responseObject) {
        if(self.parser != nil)
            [self.parser processWithData:responseObject AndCompletion:success];
        else
            success(responseObject);
    } failure:failure];
}
- (void)deleteObject:(id)object WithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
}
- (void)updateObject:(id)object WithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [self.connector updateObject:object WithSuccess:^(id responseObject) {
        [self.parser processWithData:responseObject AndCompletion:success];
    } failure:failure];
}
- (void)updateObjects:(NSArray *)objects WithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSMutableArray *objectsToParse = [NSMutableArray new];
    for (int i=0; i<objects.count; i++) {
        id object = [objects objectAtIndex:i];
        [self.connector updateObject:object WithSuccess:^(id responseObject) {
            [objectsToParse addObject:responseObject];
            if (i == objects.count-1) {
                [self.parser processDataArray:[NSArray arrayWithArray:objectsToParse] WithCompletion:success];
            }
        } failure:failure];
    }
}
- (void)createObject:(id)object WithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [self.parser decodeWithData:object AndCompletion:^(id result) {
         [self.connector createObject:result WithSuccess:^(id responseObject) {
             [self.parser processWithData:result AndCompletion:success];
         } failure:failure];
    }];
    
}
@end
