//
//  CHJSWebView.h
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

#import <UIKit/UIKit.h>
#import "CHJSWebViewDelegate.h"

@interface CHJSWebView : UIWebView

@property (nonatomic, strong) CHJSWebViewDelegate *JSdelegate;

- (void)setBlockPrefixArray:(NSArray *)prefixArray; // Set will be blocked url prefix strings
- (void)addBlockPrefix:(NSString *)prefixStr; // Add block prefix string method

/*!
 
 @abstract
 a group of methods to customize the JS-Native network
 connection.
 
 @discussion
 These methods provide ways to customize the keys.
 If a value was previously set for the variable, 
 the given value will replace the previously-existing
 value.
 
 @param
 key     The key of certain method.
 */
- (void)setNetworkRequestKey:(NSString *)key;
- (void)setTimeoutKey:(NSString *)key;
- (void)setDataKey:(NSString *)key;
- (void)setUrlKey:(NSString *)key;
- (void)setHeaderKey:(NSString *)key;
- (void)setContentTypeKey:(NSString *)key;
- (void)setCharsetKey:(NSString *)key;
- (void)setMethodKey:(NSString *)key;
- (void)setCallbackKey:(NSString *)key;
/*!
 
 @method setNetworkCallbackBlock:
 
 @abstract a way to customize your own way
 to handle network response.
 */
- (void)setNetworkCallbackBlock:(void(^)(NSURLResponse *response, NSData *data, NSError *connectionError, NSDictionary *otherInfo))block;

/*!
 
 @abstract
 a group of methods to customize the JS-Native show
 alertView.
 
 @discussion
 These methods provide ways to customize the keys.
 If a value was previously set for the variable,
 the given value will replace the previously-existing
 value.
 
 @param
 key     The key of certain method.
 */
- (void)setShowAlertRequestKey:(NSString *)key;
- (void)setTitleKey:(NSString *)key;
- (void)setMessageKey:(NSString *)key;
- (void)setButtonKey:(NSString *)key;
- (void)setStyleKey:(NSString *)key;
- (void)setActionKey:(NSString *)key;
/*!
 
 @method setAlertviewCallbackBlock:
 
 @abstract a way to customize your own way
 to handle alert view button action.
 */
- (void)setAlertviewCallbackBlock:(void(^)(id action))block;

/*!
 
 @abstract
 a group of methods to customize the JS-Native show
 actionSheet view. Multi-using some alert view keys
 (title, button, action etc.)
 
 @discussion
 These methods provide ways to customize the keys.
 If a value was previously set for the variable,
 the given value will replace the previously-existing
 value.
 
 @param
 key     The key of certain method.
 */
- (void)setShowActionSheetRequestKey:(NSString *)key;
/*!
 
 @method setActionSheetCallbackBlock:
 
 @abstract a way to customize your own way
 to handle actionSheet button action.
 */
- (void)setActionSheetCallbackBlock:(void(^)(id action))block;

@end
