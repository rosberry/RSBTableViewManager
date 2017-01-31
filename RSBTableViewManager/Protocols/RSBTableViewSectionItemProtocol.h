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

#import <Foundation/Foundation.h>
@protocol RSBTableViewCellItemProtocol;

/*!
 * @discussion Every section item should adopt this protocol for correct working with RSBTableViewManager.
 */
@protocol RSBTableViewSectionItemProtocol <NSObject>

///Array of cell items managed by this section item.
@property (nonatomic) NSArray<id<RSBTableViewCellItemProtocol>> *cellItems;

@optional

///Set height for header in section.
- (CGFloat)heightForHeaderInTableView:(UITableView *)tableView;

///Set view for header in section.
- (UIView *)viewForHeaderInTableView:(UITableView *)tableView;

///Set height for footer in section.
- (CGFloat)heightForFooterInTableView:(UITableView *)tableView;

///Set view for footer in section.
- (UIView *)viewForFooterInTableView:(UITableView *)tableView;

///Set title for header in section.
- (NSString *)titleForHeaderInTableView:(UITableView *)tableView;

///Set title for footer in section.
- (NSString *)titleForFooterInTableView:(UITableView *)tableView;

///Notify section item about displaying header view.
- (void)willDisplayHeaderView:(UIView *)view inTableView:(UITableView *)tableView forSection:(NSInteger)section;

///Notify section item about displaying footer view.
- (void)willDisplayFooterView:(UIView *)view inTableView:(UITableView *)tableView forSection:(NSInteger)section;

///Notify section item about displaying header view.
- (void)didEndDisplayingHeaderView:(UIView *)view inTableView:(UITableView *)tableView forSection:(NSInteger)section;

///Notify section item about displaying footer view.
- (void)didEndDisplayingFooterView:(UIView *)view inTableView:(UITableView *)tableView forSection:(NSInteger)section;

@end
