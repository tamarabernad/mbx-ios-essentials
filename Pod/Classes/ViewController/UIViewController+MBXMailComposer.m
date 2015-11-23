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

#import "UIViewController+MBXMailComposer.h"

NSString *const kMailComposerSubject = @"mailcomposer-subject";
NSString *const kMailComposerToRecipients = @"mailcomposer-to-recipients";
NSString *const kMailComposerCCRecipients = @"mailcomposer-cc-recipients";
NSString *const kMailComposerMessageBody = @"mailcomposer-message-body";
NSString *const kMailComposerMessageBodyIsHtml = @"mailcomposer-message-body-html";
NSString *const kMailComposerAttachmentFilename = @"mailcomposer-attachment-filename";
NSString *const kMailComposerAttachmentMimeType = @"mailcomposer-attachment-mime-type";
NSString *const kMailComposerAttachmentData = @"mailcomposer-attachment-data";

@implementation UIViewController (MBXMailComposer)

- (void)openMailComposerWithOptions:(NSDictionary *)options{
    NSData *attachmentData = [options valueForKey:kMailComposerAttachmentData];
    NSString *mimeType  = [options valueForKey:kMailComposerAttachmentMimeType];
    NSString *fileName  = [options valueForKey:kMailComposerAttachmentFilename];
    NSArray *toRecipients  = [options valueForKey:kMailComposerToRecipients];
    NSString *subject  = [options valueForKey:kMailComposerSubject];
    NSArray *ccRecipients  = [options valueForKey:kMailComposerCCRecipients];
    NSString *messageBody  = [options valueForKey:kMailComposerMessageBody];
    NSNumber *messageBodyIsHtml = [options valueForKey:kMailComposerMessageBodyIsHtml];
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        mailComposer.mailComposeDelegate = self;
        
        if (attachmentData) {
            [mailComposer addAttachmentData:attachmentData mimeType:mimeType fileName:fileName];
        }
        if(toRecipients){
            [mailComposer setToRecipients:toRecipients];
        }
        if(subject){
            [mailComposer setSubject:subject];
        }
        if(ccRecipients){
            [mailComposer setCcRecipients:ccRecipients];
        }
        if(messageBody){
            [mailComposer setMessageBody:messageBody isHTML:[messageBodyIsHtml boolValue]];
        }
        
        
        [self presentViewController:mailComposer animated:YES completion:nil];
    }
}
#pragma mark MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
