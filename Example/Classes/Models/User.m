// User.m
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "User.h"
#import "AFImageRequestOperation.h"

NSString * const kUserProfileImageDidLoadNotification = @"com.alamofire.user.profile-image.loaded";

//#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
//@interface User ()
//+ (NSOperationQueue *)sharedProfileImageRequestOperationQueue;
//@end
//#endif

@implementation User {
@private
    NSString *_avatarImageURLString;
    AFImageRequestOperation *_avatarImageRequestOperation;
}

@synthesize userID = _userID;//建议这么做，因为这样使用_userID与使用userID一样，从而避免了getter方法与变量同名
@synthesize username = _username;

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    NSLog(@"%@",attributes);
    _userID = [[attributes valueForKeyPath:@"id"] integerValue];
    _username = [attributes valueForKeyPath:@"username"];
    //JSON是一种网络数据传输结构，它包含传输对象的多个属性，而每个属性又可以是独立的dictionary，其
    //又可以包含多个子属性，当然这样的递归是没有上限，只要满足实际需求。而对于这种较复杂的多级结构，
    //通过P1.P11.P111的形式调用每个属性值。
    _avatarImageURLString = [attributes valueForKeyPath:@"avatar_image.url"];
    
    return self;
}

//属性变量的getter方法
- (NSURL *)avatarImageURL {
    return [NSURL URLWithString:_avatarImageURLString];
}

//#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
//
//@synthesize profileImage = _profileImage;
//
//+ (NSOperationQueue *)sharedProfileImageRequestOperationQueue {
//    static NSOperationQueue *_sharedProfileImageRequestOperationQueue = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _sharedProfileImageRequestOperationQueue = [[NSOperationQueue alloc] init];
//        [_sharedProfileImageRequestOperationQueue setMaxConcurrentOperationCount:8];
//    });
//    
//    return _sharedProfileImageRequestOperationQueue;
//}
//
//- (NSImage *)profileImage {
//	if (!_profileImage && !_avatarImageRequestOperation) {
//		_avatarImageRequestOperation = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:self.avatarImageURL] success:^(NSImage *image) {
//			self.profileImage = image;
//            
//			_avatarImageRequestOperation = nil;
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:kUserProfileImageDidLoadNotification object:self userInfo:nil];
//		}];
//        
//		[_avatarImageRequestOperation setCacheResponseBlock:^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
//			return [[NSCachedURLResponse alloc] initWithResponse:cachedResponse.response data:cachedResponse.data userInfo:cachedResponse.userInfo storagePolicy:NSURLCacheStorageAllowed];
//		}];
//		
//        [[[self class] sharedProfileImageRequestOperationQueue] addOperation:_avatarImageRequestOperation];
//	}
//	
//	return _profileImage;
//}
//
//#endif

@end
