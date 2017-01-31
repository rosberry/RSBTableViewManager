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

NS_ASSUME_NONNULL_BEGIN

/*!
 * @discussion Every cell item should adopt this protocol for correct working with RSBTableViewManager.
 */
@protocol RSBTableViewCellItemProtocol <NSObject>

///Should return height for cell class, managed by cell item.
- (CGFloat)heightInTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
/*!
 * @discussion Use this method for configuring cell.
 * @warning Don't forget to call [super configureCell:cell]; for right inheritance.
 */
- (void)configureCell:(UITableViewCell *)cell inTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

@optional

/*!
 * @discussion If your cell should be loaded from xib provide UINib instance.
 * @warning You have to provide at least one of the following methods
 * registeredTableViewCellNib, registeredTableViewCellClass or 
 * storyboardPrototypeTableViewCellReuseIdentifier.
 */
- (UINib *)registeredTableViewCellNib;
/*!
 * @discussion If your cell should be created without xib provide it class.
 * @warning You have to provide at least one of the following methods
 * registeredTableViewCellNib, registeredTableViewCellClass or
 * storyboardPrototypeTableViewCellReuseIdentifier.
 */
- (Class)registeredTableViewCellClass;
/*!
 * @discussion If your cell should be loaded from storyboard return reuse identifier you
 * provide in storyboard.
 * @warning You have to provide at least one of the following methods
 * registeredTableViewCellNib, registeredTableViewCellClass or
 * storyboardPrototypeTableViewCellReuseIdentifier.
 */
- (NSString *)storyboardPrototypeTableViewCellReuseIdentifier;


///Cell removed in table view at index path.
- (void)didRemoveFromTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

///This method called when remove animation is finished.
- (void)didFinishRemoveAnimationFromTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

///Asks delegate whether cell should be highlighted at specific index path.
- (BOOL)shouldHighlightInTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

///Notifies delegate that cell did highlight at specific index path.
- (void)didHighlightInTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

///Notifies delegate that cell did unhighlight at specific index path.
- (void)didUnhighlightInTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

///Asks to return some replacement index path to select with given index path.
- (nullable NSIndexPath *)willSelectInTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

///Asks to return some replacement index path to deselect with given index path.
- (nullable NSIndexPath *)willDeselectInTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

///Cell selected in table view at index path.
- (void)didSelectInTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

///Cell did deselect in table view at index path.
- (void)didDeselectInTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

///This method called when cell is about to display.
- (void)willDisplayCell:(UITableViewCell *)cell inTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

///This method called when cell did end displaying.
- (void)didEndDisplayingCell:(UITableViewCell *)cell inTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

///This method called by UITableViewDataSource tableView:canEditRowAtIndexPath: method for checking cell managed by this cell item can be edited.
- (BOOL)canEditInTableView:(UITableView *)tableView;

///This method called in tableView:commitEditingStyle:forRowAtIndexPath: for check commit editing style availability
- (BOOL)canCommitEditingStyle:(UITableViewCellEditingStyle)editingStyle inTableView:(UITableView *)tableView;

///Actions to display in response to a swipe.
- (NSArray<UITableViewRowAction *> *)editActionsInTableView:(UITableView *)tableView;

///See same method in UITableViewDelegate protocol.
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath;

///Return YES if row is able to move.
- (BOOL)canMoveRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
