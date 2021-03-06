// AFNetworkActivityLogger.h
//
// Copyright (c) 2013 AFNetworking (http://afnetworking.com/)
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


#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

#import "AFNetworkActivityLogger.h"

#import <objc/runtime.h>

#define HDNetLog(format,...) printf("%s",[[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])

static NSURLRequest * AFNetworkRequestFromNotification(NSNotification *notification) {
    NSURLRequest *request = nil;
    if ([[notification object] respondsToSelector:@selector(originalRequest)]) {
        request = [[notification object] originalRequest];
    } else if ([[notification object] respondsToSelector:@selector(request)]) {
        request = [[notification object] request];
    }

    return request;
}

static NSError * AFNetworkErrorFromNotification(NSNotification *notification) {
    NSError *error = nil;

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    if ([[notification object] isKindOfClass:[NSURLSessionTask class]]) {
        error = [(NSURLSessionTask *)[notification object] error];
        if (!error) {
            error = notification.userInfo[AFNetworkingTaskDidCompleteErrorKey];
        }
    }
#endif

    return error;
}

@implementation AFNetworkActivityLogger

+ (instancetype)sharedLogger {
    static AFNetworkActivityLogger *_sharedLogger = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLogger = [[self alloc] init];
    });

    return _sharedLogger;
}

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.level = AFLoggerLevelInfo;

    return self;
}

- (void)dealloc {
    [self stopLogging];
}

- (void)startLogging {
    [self stopLogging];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidFinish:) name:AFNetworkingTaskDidSuspendNotification object:nil];

#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000) || (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidStart:) name:AFNetworkingTaskDidResumeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidFinish:) name:AFNetworkingTaskDidCompleteNotification object:nil];
#endif
}

- (void)stopLogging {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NSNotification

static void * AFNetworkRequestStartDate = &AFNetworkRequestStartDate;

- (void)networkRequestDidStart:(NSNotification *)notification {
    NSURLRequest *request = AFNetworkRequestFromNotification(notification);

    if (!request) {
        return;
    }


    objc_setAssociatedObject(notification.object, AFNetworkRequestStartDate, [NSDate date], OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    NSString *body = nil;
    if ([request HTTPBody]) {
        body = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
    }

    switch (self.level) {
        case AFLoggerLevelDebug:
            //            NSLog(@"====================================================");
            //            NSLog(@"%@ \n'%@': \n%@ \n%@", [request HTTPMethod], [[request URL] absoluteString], [request allHTTPHeaderFields], body);
            //            NSLog(@"====================================================");
            break;
        case AFLoggerLevelInfo:
            //            NSLog(@"====================================================");
            //            NSLog(@"%@ '%@' \n%@", [request HTTPMethod], [[request URL] absoluteString], body);
            //            NSLog(@"====================================================");
            break;
        default:
            break;
    }
}


- (void)networkRequestDidFinish:(NSNotification *)notification {
    NSURLRequest *request = AFNetworkRequestFromNotification(notification);
    NSURLResponse *response = [notification.object response];
    NSError *error = AFNetworkErrorFromNotification(notification);

    if (!request && !response) {
        return;
    }

    if (request && self.filterPredicate && [self.filterPredicate evaluateWithObject:request]) {
        return;
    }

    NSUInteger responseStatusCode = 0;
    NSDictionary *responseHeaderFields = nil;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        responseStatusCode = (NSUInteger)[(NSHTTPURLResponse *)response statusCode];
        responseHeaderFields = [(NSHTTPURLResponse *)response allHeaderFields];
    }

    id responseObject = nil;
    if (notification.userInfo) {
        responseObject = notification.userInfo[AFNetworkingTaskDidCompleteSerializedResponseKey];
    }

    NSString *body = nil;
    if ([request HTTPBody]) {
        body = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
    }
    NSArray *bodys = [body componentsSeparatedByString:@"&"];
    NSString *bodyString =  [self hd_urlDecode:[bodys description]];
    
    NSDictionary *allHTTPHeaderFields = [request allHTTPHeaderFields];
    NSString *allHTTPHeaderFieldString =  [self hd_urlDecode:[allHTTPHeaderFields description]];

    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:objc_getAssociatedObject(notification.object, AFNetworkRequestStartDate)];

    if (error) {
        NSDictionary *userInfo = error.userInfo;
        switch (self.level) {
            case AFLoggerLevelDebug:
            case AFLoggerLevelInfo:
            case AFLoggerLevelWarn:
            case AFLoggerLevelError:
                HDNetLog(@"\n\n==================================================================================\n[????????????] ???????????????%@ \n?????????url???'%@' \n??????????????????%@ \n??????????????????%@ \n??????????????????(%ld) \n???????????????[%.02f ms]\n???????????????[????????????%ld]???[???????????????%@] \n==================================================================================\n\n", [request HTTPMethod], [[request URL] absoluteString], allHTTPHeaderFieldString, bodyString, (long)responseStatusCode, elapsedTime * 1000, (long)error.code, error.localizedDescription);
            default:
                break;
        }
    } else {
        switch (self.level) {
            case AFLoggerLevelDebug:
            case AFLoggerLevelWarn:
            case AFLoggerLevelError:
                HDNetLog(@"\n\n==================================================================================\n[????????????] ???????????????%@ \n?????????url???'%@' \n??????????????????%@ \n??????????????????%@ \n??????????????????(%ld) \n???????????????[%.02f ms] \n???????????????%@ \n==================================================================================\n\n", [request HTTPMethod], [[response URL] absoluteString], allHTTPHeaderFieldString, bodyString, (long)responseStatusCode, elapsedTime * 1000, responseObject);
                break;
            case AFLoggerLevelInfo:
                HDNetLog(@"\n\n==================================================================================\n[????????????] ???????????????%@ \n?????????url???'%@' \n??????????????????%@ \n??????????????????%@ \n??????????????????(%ld) \n???????????????[%.02f ms] \n???????????????%@ \n==================================================================================\n\n", [request HTTPMethod], [[response URL] absoluteString], allHTTPHeaderFieldString, bodyString, (long)responseStatusCode, elapsedTime * 1000, responseObject);
                break;
            default:
                break;
        }
    }
}



//URLDecode
- (NSString *)hd_urlDecode:(NSString *)string
{
    NSString *decodedString = (__bridge_transfer NSString *)
    CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                            (__bridge CFStringRef)string,
                                                            CFSTR(""),
                                                            CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

@end
