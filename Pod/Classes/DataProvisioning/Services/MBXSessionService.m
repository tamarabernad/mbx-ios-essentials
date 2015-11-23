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

#import "MBXSessionService.h"
#import "MBXSessionConnectorProtocol.h"
@implementation MBXSessionService
- (NSString *)loggedUserId{
    return [(NSObject <MBXSessionConnectorProtocol> *)self.connector loggedUserId];
}
- (NSObject *)loggedInUser{
    NSObject __block *user;
    [self.parser processWithData:[(NSObject <MBXSessionConnectorProtocol> *)self.connector loggedInUser] AndCompletion:^(id result) {
        user = result;
    }];
    return  user;
}
- (BOOL)isLoggedIn{
    return  [(NSObject <MBXSessionConnectorProtocol> *)self.connector isLoggedIn];
}
- (void)logout{
    [(NSObject <MBXSessionConnectorProtocol> *)self.connector logout];
}
- (void)authorizeWithData:(id)data Success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [(NSObject <MBXSessionConnectorProtocol> *)self.connector authorizeWithData:data Success:success failure:failure];
}
- (void)signUpWithData:(id)data Success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [(NSObject <MBXSessionConnectorProtocol> *)self.connector signUpWithData:data Success:success failure:failure];
}
- (void)checkSessionValidSuccess:(void (^)(BOOL))success failure:(void (^)(NSError *))failure{
    [(NSObject <MBXSessionConnectorProtocol> *) self.connector checkSessionValidSuccess:success failure:failure];
}
@end
