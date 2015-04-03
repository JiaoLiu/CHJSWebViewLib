//
//  CHJSWebViewDelegate.m
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

#import "CHJSWebViewDelegate.h"

@implementation CHJSWebViewDelegate

- (id)init
{
    self = [super init];
    if (self) {
        self.blockPrefixArray = [NSMutableArray array];
        self.actionArray = [NSMutableArray array];
        
        /* async network connection keys init,
           base on CH inner JS defination.
         */
        self.networkRequest_key = @"networkRequest";
        self.method_key = @"method";
        self.timeout_key = @"timeout";
        self.data_key = @"data";
        self.charset_key = @"dataCharset";
        self.contentType_key = @"contentType";
        self.header_key = @"header";
        self.url_key = @"url";
        self.callback_key = @"commonCallback";
        
        /* show alert view keys init,
         base on CH inner JS defination.
         */
        self.showAlertRequest_key = @"showAlert";
        self.title_key = @"title";
        self.message_key = @"message";
        self.button_key = @"button";
        self.style_key = @"style";
        self.action_key = @"action";
        
        /* show actionSheet keys init,
         base on CH inner JS defination.
         */
        self.showActionSheetRequest_key = @"showActionSheet";
    }
    return self;
}

- (void)dealloc
{
    self.webDelegate = nil;
    self.blockPrefixArray = nil;
    self.actionArray = nil;
}

#pragma mark - Methods

- (void)netwokConnectionWithMethod:(NSString *)method keys:(NSArray *)keysArray values:(NSArray *)valuesArray webView:(UIWebView *)webView
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.name = method;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    for (int i = 0; i < keysArray.count; i++) {
        NSString *key = [keysArray objectAtIndex:i];
        NSDictionary *dic = [valuesArray objectAtIndex:valuesArray.count > keysArray.count ? i+1 : i]; // if first value is the successKey&failKey then step over.
        id value = [dic objectForKey:key];
        if ([key isEqualToString:self.timeout_key]) {
            request.timeoutInterval = (long)value;
        }
        if ([key isEqualToString:self.method_key]) {
            request.HTTPMethod = value;
        }
        if ([key isEqualToString:self.data_key]) {
            request.HTTPBody = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:nil];
        }
        if ([key isEqualToString:self.charset_key]) {
            [request addValue:value forHTTPHeaderField:@"Accept-Charset"];
        }
        if ([key isEqualToString:self.header_key] && [value isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *headerDic = [[NSMutableDictionary alloc] initWithDictionary:request.allHTTPHeaderFields];
            [headerDic addEntriesFromDictionary:value];
            request.allHTTPHeaderFields = headerDic;
        }
        if ([key isEqualToString:self.contentType_key]) {
            [request addValue:value forHTTPHeaderField:@"Content-Type"];
        }
        if ([key isEqualToString:self.url_key]) {
            request.URL = [NSURL URLWithString:value];
        }
    }
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (self.networkBlock) {
            self.networkBlock(response,data,connectionError,valuesArray.count > keysArray.count ? [valuesArray objectAtIndex:0] : nil);
            return;
        }
        NSHTTPURLResponse *myResponse = (NSHTTPURLResponse *)response;
        if (myResponse.statusCode == 200 && !connectionError) {
            NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSMutableDictionary *sendBackDic = [NSMutableDictionary dictionary];
            if (valuesArray.count > keysArray.count) { // contains successKey&failKey
                [sendBackDic addEntriesFromDictionary:[valuesArray objectAtIndex:0]];
            }
            [sendBackDic setObject:@"true" forKey:@"isSuccess"];
            [sendBackDic setObject:dic forKey:@"response"];
//            [sendBackDic setObject:[myResponse.allHeaderFields objectForKey:@"token"] forKey:@"token"];  // defined by Developer
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:sendBackDic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            dispatch_async(dispatch_get_main_queue(), ^{
                [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@(%@)",self.callback_key,jsonStr]];
            });
        }
        else
        {
            NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSMutableDictionary *sendBackDic = [NSMutableDictionary dictionary];
            if (valuesArray.count > keysArray.count) { // contains successKey&failKey
                [sendBackDic addEntriesFromDictionary:[valuesArray objectAtIndex:0]];
            }
            [sendBackDic setObject:@"false" forKey:@"isSuccess"];
            [sendBackDic setObject:dic forKey:@"response"];
            [sendBackDic setObject:[NSNumber numberWithLong:myResponse.statusCode] forKey:@"errorCode"];
            [sendBackDic setObject:connectionError.description forKey:@"msg"];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:sendBackDic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            dispatch_async(dispatch_get_main_queue(), ^{
                [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@(%@)",self.callback_key,jsonStr]];
            });
        }
    }];
}

- (void)showAlertWithKeys:(NSArray *)keysArray values:(NSArray *)valuesArray webView:(UIWebView *)webView
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.delegate = self;
    [self.actionArray removeAllObjects];
    for (int i = 0; i < keysArray.count; i++) {
        NSString *key = [keysArray objectAtIndex:i];
        NSDictionary *dic = [valuesArray objectAtIndex:valuesArray.count > keysArray.count ? i+1 : i]; // if first value is the successKey&failKey then step over.
        id value = [dic objectForKey:key];
        if ([key isEqualToString:self.title_key]) {
            [alert setTitle:value];
        }
        if ([key isEqualToString:self.message_key]) {
            [alert setMessage:value];
        }
        if ([key isEqualToString:self.button_key]) {
            [alert addButtonWithTitle:value];
        }
        if ([key isEqualToString:self.style_key]) {
            [alert setAlertViewStyle:[value integerValue]];
        }
        if ([key isEqualToString:self.action_key]) {
            [self.actionArray addObject:value];
        }
    }
    [alert show];
}

- (void)showActionSheetWithKeys:(NSArray *)keysArray values:(NSArray *)valuesArray webView:(UIWebView *)webView
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.delegate = self;
    [self.actionArray removeAllObjects];
    for (int i = 0; i < keysArray.count; i++) {
        NSString *key = [keysArray objectAtIndex:i];
        NSDictionary *dic = [valuesArray objectAtIndex:valuesArray.count > keysArray.count ? i+1 : i]; // if first value is the successKey&failKey then step over.
        id value = [dic objectForKey:key];
        if ([key isEqualToString:self.title_key]) {
            [actionSheet setTitle:value];
        }
        if ([key isEqualToString:self.button_key]) {
            [actionSheet addButtonWithTitle:value];
        }
        if ([key isEqualToString:self.style_key]) {
            [actionSheet setActionSheetStyle:[value integerValue]];
        }
        if ([key isEqualToString:self.action_key]) {
            [self.actionArray addObject:value];
        }
    }
    [actionSheet showInView:webView];
}

#pragma mark - UIAlertView & UIActionSheetDelegate Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.alertBlock) {
        self.alertBlock([self.actionArray objectAtIndex:buttonIndex]);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.actionSheetBlock) {
        self.actionSheetBlock([self.actionArray objectAtIndex:buttonIndex]);
    }
}

#pragma mark - UIWebview Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestStr = request.URL.absoluteString;
    for (NSString *prefix in self.blockPrefixArray) {
        if ([requestStr hasPrefix:prefix]) {
            NSString *subStr = [requestStr substringFromIndex:prefix.length];
            NSMutableArray *keysArr = (NSMutableArray *)[[[subStr componentsSeparatedByString:@"?"] objectAtIndex:0] componentsSeparatedByString:@":"];
            NSString *method = [keysArr objectAtIndex:0];
            [keysArr removeObjectAtIndex:0];
            [keysArr removeLastObject];
            NSString *paramStr = [[[[subStr componentsSeparatedByString:@"?"] objectAtIndex:1] componentsSeparatedByString:@"="] lastObject];
            paramStr = [paramStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSMutableArray *valuesArr = [NSJSONSerialization JSONObjectWithData:[paramStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            if ([method isEqualToString:self.networkRequest_key]) {
                [self netwokConnectionWithMethod:method keys:keysArr values:valuesArr webView:webView];
            }
            if ([method isEqualToString:self.showAlertRequest_key]) {
                [self showAlertWithKeys:keysArr values:valuesArr webView:webView];
            }
            if ([method isEqualToString:self.showActionSheetRequest_key]) {
                [self showActionSheetWithKeys:keysArr values:valuesArr webView:webView];
            }
            return NO;
        }
    }
    
    if (!self.webDelegate) {
        return YES;
    }
    return [self.webDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.webDelegate webViewDidFinishLoad:webView];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.webDelegate webViewDidStartLoad:webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.webDelegate webView:webView didFailLoadWithError:error];
}

@end
