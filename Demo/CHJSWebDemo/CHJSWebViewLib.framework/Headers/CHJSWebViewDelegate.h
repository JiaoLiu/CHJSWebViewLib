//
//  CHJSWebViewDelegate.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
 
 @class CHJSWebViewDelegate
 @discussion
 A way to block certain url request,
 then invoke native method.
 
 example blocked request:
 http://com.changhong.native.async/networkRequest:timeout:method:data:dataCharset:header:contentType:url:?param='[{"successKey":"' + this.successKey + '","failKey":"' + this.failKey
 + '"},{"timeout":"' + this.timeout + '"},{"method":"' + this.method + '"},{"data":'
 + this.data + '},{"dataCharset":"' + this.dataCharset + '"},{"header":"'
 + this.header + '"},{"contentType":"' + this.contentType + '"},{"url":"' + this.url + '"}]'
 
 The block string = "http://com.changhong.native.async/"
 The method = "networkReqest"
 The keys are joint by ":" = "timeout:method:data:dataCharset:header:contentType:url:"
 The values are in the "param = {}" paired with keys, first value is the successKey&failKey used for callback function.
 
 defined commonCallback(result) is the callback function to interact with HTML view.
 
 an example result = {"successKey":"ajax_s1234325676","failKey":"ajax_f1234325676","isSuccess":"true","response":"xx dictionary or string","token":"xxxxxxxxx","errorCode":"401","msg":"xxxxxxx"}
 */

typedef void(^networkRequetBlock)(NSURLResponse *response, NSData *data, NSError *connectionError, NSDictionary *otherInfo);
typedef void(^alertviewRequestBlock)(id action);
typedef void(^actionSheetRequestBlock)(id action);

@interface CHJSWebViewDelegate : NSObject<UIWebViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) id<UIWebViewDelegate> webDelegate;
@property (nonatomic, strong) NSMutableArray *blockPrefixArray; // Will be blocked urls contains one of the prefix strings, default is nil
@property (nonatomic, copy) networkRequetBlock networkBlock;
@property (nonatomic, strong) NSMutableArray *actionArray;
@property (nonatomic, copy) alertviewRequestBlock alertBlock;
@property (nonatomic, copy) actionSheetRequestBlock actionSheetBlock;

/* async network connection keys */
@property (nonatomic, strong) NSString *networkRequest_key;
@property (nonatomic, strong) NSString *timeout_key;
@property (nonatomic, strong) NSString *data_key;
@property (nonatomic, strong) NSString *url_key;
@property (nonatomic, strong) NSString *header_key;
@property (nonatomic, strong) NSString *contentType_key;
@property (nonatomic, strong) NSString *charset_key;
@property (nonatomic, strong) NSString *method_key;
@property (nonatomic, strong) NSString *callback_key;

/* show alert view keys */
@property (nonatomic, strong) NSString *showAlertRequest_key;
@property (nonatomic, strong) NSString *title_key;
@property (nonatomic, strong) NSString *message_key;
@property (nonatomic, strong) NSString *button_key;
@property (nonatomic, strong) NSString *style_key;
@property (nonatomic, strong) NSString *action_key;

/* show actionSheet view keys */
@property (nonatomic, strong) NSString *showActionSheetRequest_key; // multi-using some alert view keys(title, button, action etc.)

@end
