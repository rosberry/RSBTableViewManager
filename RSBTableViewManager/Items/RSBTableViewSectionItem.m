//Copyright (c) 2015 RSBTableViewManager
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

#import "RSBTableViewSectionItem.h"

@implementation RSBTableViewSectionItem

- (instancetype)initWithCellItems:(NSArray<id<RSBTableViewCellItemProtocol>> *)cellItems {
    self = [super init];
    if (self) {
        [self setCellItems:cellItems];
    }
    return self;
}

- (NSString *)titleForHeaderInTableView:(UITableView *)tableView {
    return self.headerTitle;
}

- (CGFloat)heightForHeaderInTableView:(UITableView *)tableView {
    if (self.headerTitle) {
        return 22.0;
    }
    return 0.0;
}

- (NSString *)titleForFooterInTableView:(UITableView *)tableView {
    return self.footerTitle;
}

- (CGFloat)heightForFooterInTableView:(UITableView *)tableView {
    if (self.footerTitle) {
        return 22.0;
    }
    return 0.0;
}

@end
