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

#import <UIKit/UIKit.h>
#import "RSBTableViewCellItemProtocol.h"

/*!
 * @discussion This class can be used as base class for any cell item.
 */
@interface RSBTableViewCellItem : NSObject <RSBTableViewCellItemProtocol>

///Block for catching didSelect event.
@property (nonatomic, copy) void(^itemDidSelectBlock)(__weak UITableView *tableView, NSIndexPath *indexPath);
- (void)setItemDidSelectBlock:(void (^)(__weak UITableView *tableView, NSIndexPath *indexPath))itemDidSelectBlock;

///Block for catching didDeselect event.
@property (nonatomic, copy) void(^itemDidDeselectBlock)(__weak UITableView *tableView, NSIndexPath *indexPath);
- (void)setItemDidDeselectBlock:(void (^)(__weak UITableView *tableView, NSIndexPath *indexPath))itemDidSelectBlock;

//Block for catching didRemove event
@property (nonatomic, copy) void(^itemDidDeleteBlock)(__weak UITableView *tableView, NSIndexPath *indexPath);
- (void)setItemDidDeleteBlock:(void (^)(__weak UITableView *tableView, NSIndexPath *indexPath))itemDidDeleteBlock;

@end
