//
//  CHJSWebView.m
//  Test
//
//  Created by Jiao Liu on 4/1/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//
/*!
 The MIT License (MIT)
 
 Copyright (c) 2015 Jiao
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#import "CHJSWebView.h"

@implementation CHJSWebView

- (id)init
{
    self = [super init];
    if (self) {
        self.JSdelegate = [[CHJSWebViewDelegate alloc] init];
        self.delegate = self.JSdelegate;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.JSdelegate = [[CHJSWebViewDelegate alloc] init];
        self.delegate = self.JSdelegate;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.JSdelegate = [[CHJSWebViewDelegate alloc] init];
        self.delegate = self.JSdelegate;
    }
    return self;
}

- (void)dealloc
{
    self.JSdelegate = nil;
}

- (void)setDelegate:(id<UIWebViewDelegate>)delegate
{
    if (delegate != self.JSdelegate) {
        self.JSdelegate.webDelegate = delegate;
    }
    else
    {
        [super setDelegate:delegate];
    }
}

#pragma mark - Block Prefix Strings

- (void)setBlockPrefixArray:(NSArray *)prefixArray
{
    self.JSdelegate.blockPrefixArray = [NSMutableArray arrayWithArray:prefixArray];
}

- (void)addBlockPrefix:(NSString *)prefixStr
{
    [self.JSdelegate.blockPrefixArray addObject:prefixStr];
}

#pragma mark - Customize Network Connection Keys

- (void)setNetworkRequestKey:(NSString *)key
{
    self.JSdelegate.networkRequest_key = key;
}

- (void)setTimeoutKey:(NSString *)key
{
    self.JSdelegate.timeout_key = key;
}

- (void)setHeaderKey:(NSString *)key
{
    self.JSdelegate.header_key = key;
}

- (void)setDataKey:(NSString *)key
{
    self.JSdelegate.data_key = key;
}

- (void)setContentTypeKey:(NSString *)key
{
    self.JSdelegate.contentType_key = key;
}

- (void)setCharsetKey:(NSString *)key
{
    self.JSdelegate.charset_key = key;
}

- (void)setMethodKey:(NSString *)key
{
    self.JSdelegate.method_key = key;
}

- (void)setUrlKey:(NSString *)key
{
    self.JSdelegate.url_key = key;
}

- (void)setCallbackKey:(NSString *)key
{
    self.JSdelegate.callback_key = key;
}

- (void)setNetworkCallbackBlock:(void (^)(NSURLResponse *, NSData *, NSError *, NSDictionary *))block
{
    self.JSdelegate.networkBlock = block;
}

#pragma mark - Customize AlertView Keys

- (void)setShowAlertRequestKey:(NSString *)key
{
    self.JSdelegate.showAlertRequest_key = key;
}

- (void)setTitleKey:(NSString *)key
{
    self.JSdelegate.title_key = key;
}

- (void)setMessageKey:(NSString *)key
{
    self.JSdelegate.message_key = key;
}

- (void)setButtonKey:(NSString *)key
{
    self.JSdelegate.button_key = key;
}

- (void)setStyleKey:(NSString *)key
{
    self.JSdelegate.style_key = key;
}

- (void)setActionKey:(NSString *)key
{
    self.JSdelegate.action_key = key;
}

- (void)setAlertviewCallbackBlock:(void (^)(id))block
{
    self.JSdelegate.alertBlock = block;
}

#pragma mark - Customize ActionSheet Keys

- (void)setShowActionSheetRequestKey:(NSString *)key
{
    self.JSdelegate.showActionSheetRequest_key = key;
}

- (void)setActionSheetCallbackBlock:(void (^)(id))block
{
    self.JSdelegate.actionSheetBlock = block;
}

@end
