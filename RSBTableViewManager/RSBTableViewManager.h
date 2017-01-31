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

#import "RSBTableViewCellItem.h"
#import "RSBTableViewSectionItem.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RSBTableViewSectionItemProtocol;
@protocol RSBTableViewCellItemProtocol;
@protocol RSBTableViewManagerDelegate;

/*!
 * @discussion This manager encapsulate all UITableView stuff and allow you to work only
 * with section items - objects that adopt RSBTableViewSectionItemProtocol.
 * @see RSBTableViewSectionItem.
 */
@interface RSBTableViewManager : NSObject


///Table view currently handled by manager.
@property (nonatomic, weak, readonly) UITableView *tableView;

///If you need to be notified about scroll events in table view - you are welcome.
@property (nonatomic, weak, nullable) id<UIScrollViewDelegate> scrollDelegate;

///Current section items.
@property (nonatomic, nullable) NSArray<id<RSBTableViewSectionItemProtocol>> *sectionItems;

///Use delegate if you need to use some common table view features.
@property (nonatomic, weak, nullable) id<RSBTableViewManagerDelegate> delegate;



///Use designated initializer -[RSBTableViewManager initWithTableView:] instead.
- (instancetype)init NS_UNAVAILABLE;

///Use this method for creating manager.
- (instancetype)initWithTableView:(UITableView *)tableView NS_DESIGNATED_INITIALIZER;



/*!
 * @discussion Reload cell items in concrete section item with animation.
 * @param cellItems Array of cell items you want to reload.
 * @param sectionItem Section item in which you want to reload items.
 * @param animation Animation of UITableViewRowAnimation type.
 */
- (void)reloadCellItems:(NSArray<id<RSBTableViewCellItemProtocol>> *)cellItems
          inSectionItem:(id<RSBTableViewSectionItemProtocol>)sectionItem
       withRowAnimation:(UITableViewRowAnimation)animation;
/*!
 * @discussion Remove cell items from concrete section item with animation.
 * @param cellItems Array of cell items you want to remove.
 * @param sectionItem Section item from which you want to remove items.
 * @param animation Animation of UITableViewRowAnimation type.
 */
- (void)removeCellItems:(NSArray<id<RSBTableViewCellItemProtocol>> *)cellItems
        fromSectionItem:(id<RSBTableViewSectionItemProtocol>)sectionItem
       withRowAnimation:(UITableViewRowAnimation)animation;
/*!
 * @discussion Insert cell items to concrete section item with animation.
 * @param cellItems Array of cell items you want to insert.
 * @param sectionItem Section item to which you want to insert items.
 * @param indexes Index set of cell item's indexes you want to insert to.
 * @param animation Animation of UITableViewRowAnimation type.
 */
- (void)insertCellItems:(NSArray<id<RSBTableViewCellItemProtocol>> *)cellItems
          toSectionItem:(id<RSBTableViewSectionItemProtocol>)sectionItem
              atIndexes:(NSIndexSet *)indexes
       withRowAnimation:(UITableViewRowAnimation)animation;
/*!
 * @discussion Repace cell items in concrete section item with animation.
 * @param indexes Index set of cell item's indexes you want to replace.
 * @param cellItems Array of cell items you want to insert.
 * @param sectionItem Section item to which you want to insert items.
 * @param animation Animation of UITableViewRowAnimation type.
 */
- (void)replaceCellItemsAtIndexes:(NSIndexSet *)indexes
                    withCellItems:(NSArray<id<RSBTableViewCellItemProtocol>> *)cellItems
                    inSectionItem:(id<RSBTableViewSectionItemProtocol>)sectionItem
                 withRowAnimation:(UITableViewRowAnimation)animation;


/*!
 * @discussion Remove cell items from concrete section item with animation.
 * @param sectionItems Array of section items you want to remove.
 * @param animation Animation of UITableViewRowAnimation type.
 */
- (void)removeSectionItems:(NSArray<id<RSBTableViewSectionItemProtocol>> *)sectionItems
          withRowAnimation:(UITableViewRowAnimation)animation;
/*!
 * @discussion Insert cell items to concrete section item with animation.
 * @param sectionItems Array of section items you want to insert.
 * @param indexes Index set of section item's indexes you want to insert to.
 * @param animation Animation of UITableViewRowAnimation type.
 */
- (void)insertSectionItems:(NSArray<id<RSBTableViewSectionItemProtocol>> *)sectionItems
                 atIndexes:(NSIndexSet *)indexes
          withRowAnimation:(UITableViewRowAnimation)animation;
/*!
 * @discussion Replace section items with animation.
 * @param indexes Index set of section items you want to replace.
 * @param sectionItems Array of section items you want to insert.
 * @param animation Animation of UITableViewRowAnimation type.
 */
- (void)replaceSectionItemsAtIndexes:(NSIndexSet *)indexes
                    withSectionItems:(NSArray<id<RSBTableViewSectionItemProtocol>> *)sectionItems
                        rowAnimation:(UITableViewRowAnimation)animation;


///You can get frame of concrete cell item cell.
- (CGRect)frameForCellItem:(id<RSBTableViewCellItemProtocol>)cellItem inSectionItem:(id<RSBTableViewSectionItemProtocol>)sectionItem;

///Scroll to concrete cell item.
- (void)scrollToCellItem:(id<RSBTableViewCellItemProtocol>)cellItem
           inSectionItem:(id<RSBTableViewSectionItemProtocol>)sectionItem
        atScrollPosition:(UITableViewScrollPosition)position
                animated:(BOOL)animated;

///Scroll to top.
- (void)scrollToTopAnimated:(BOOL)animated;

@end



///This protocol implements some common table view features.
@protocol RSBTableViewManagerDelegate <NSObject>

///See same method in UITableViewDelegate protocol.
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath;

///See same method in UITableViewDataSource protocol.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;

///See same method in UITableViewDataSource protocol.
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView;

///See same method in UITableViewDataSource protocol.
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
