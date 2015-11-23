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

#import "MBXIconButton.h"

@implementation MBXIconButton

- (void)awakeFromNib{
    [self setImage:[self.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self setSelected:NO];
}
- (void)setTintNormal:(UIColor *)tintNormal
{
    _tintNormal = tintNormal;
    [self setSelected:self.selected];
}
- (void)setTintSelected:(UIColor *)tintSelected
{
    _tintSelected = tintSelected;
    [self setSelected:self.selected];
}
- (void)setSelected:(BOOL)selected{
    if (selected) {
        [self.imageView setTintColor:self.tintSelected];
    }else{
        [self.imageView setTintColor:self.tintNormal];
    }
}
- (void)setEnabled:(BOOL)enabled{
    if (enabled) {
        self.alpha = 1.0;
    }else{
        self.alpha = 0.4;
    }
}
@end
