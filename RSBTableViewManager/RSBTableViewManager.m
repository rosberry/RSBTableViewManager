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

#import "RSBTableViewManager.h"
#import "RSBTableViewSectionItemProtocol.h"
#import "RSBTableViewCellItemProtocol.h"

@interface RSBTableViewManager () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak, readwrite) UITableView *tableView;

@end

@implementation RSBTableViewManager

- (instancetype)initWithTableView:(UITableView *)tableView {
    self = [super init];
    if (self) {
        self.tableView = tableView;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return self;
}

#pragma mark - Public Methods

#pragma mark Cell items

- (void)reloadCellItems:(NSArray<id<RSBTableViewCellItemProtocol>> *)cellItems
          inSectionItem:(id<RSBTableViewSectionItemProtocol>)sectionItem
       withRowAnimation:(UITableViewRowAnimation)animation {
    
    NSUInteger section = [self.sectionItems indexOfObject:sectionItem];
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
    
    for (id<RSBTableViewCellItemProtocol> cellItem in cellItems) {
        NSAssert([sectionItem.cellItems containsObject:cellItem], @"It's impossible to reload cell items that are not contained in section item %@", sectionItem);
        NSUInteger row = [sectionItem.cellItems indexOfObject:cellItem];
        [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:section]];
    }
    
    [self.tableView beginUpdates];
    
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    
    [self.tableView endUpdates];
}

- (void)removeCellItems:(NSArray <id<RSBTableViewCellItemProtocol>> *)cellItems
        fromSectionItem:(id<RSBTableViewSectionItemProtocol>)sectionItem
       withRowAnimation:(UITableViewRowAnimation)animation {
    
    NSUInteger section = [self.sectionItems indexOfObject:sectionItem];
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    
    for (id<RSBTableViewCellItemProtocol> cellItem in cellItems) {
        NSAssert([sectionItem.cellItems containsObject:cellItem], @"It's impossible to remove cell items that are not contained in section item %@", sectionItem);
        NSUInteger row = [sectionItem.cellItems indexOfObject:cellItem];
        [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:section]];
        [indexes addIndex:row];
    }
    
    [self.tableView beginUpdates];
    
    NSMutableArray<id<RSBTableViewCellItemProtocol>> *mCellItems = [NSMutableArray arrayWithArray:sectionItem.cellItems];
    [mCellItems removeObjectsAtIndexes:indexes];
    sectionItem.cellItems = [NSArray arrayWithArray:mCellItems];
    
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    
    [self.tableView endUpdates];
}

- (void)insertCellItems:(NSArray <id<RSBTableViewCellItemProtocol>> *)cellItems
          toSectionItem:(id<RSBTableViewSectionItemProtocol>)sectionItem
              atIndexes:(NSIndexSet *)indexes
       withRowAnimation:(UITableViewRowAnimation)animation {
    
    NSAssert([indexes firstIndex] <= sectionItem.cellItems.count, @"It's impossible to insert item at index that is larger than count of cell items in this section");
    for (id<RSBTableViewCellItemProtocol> cellItem in cellItems) {
        [self registerCellItem:cellItem];
    }
    
    [self.tableView beginUpdates];
    
    NSMutableArray<id<RSBTableViewCellItemProtocol>> *mCellItems = [NSMutableArray arrayWithArray:sectionItem.cellItems];
    [mCellItems insertObjects:cellItems atIndexes:indexes];
    sectionItem.cellItems = [NSArray arrayWithArray:mCellItems];
    
    NSUInteger section = [self.sectionItems indexOfObject:sectionItem];
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:section]];
    }];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    
    [self.tableView endUpdates];
}

- (void)replaceCellItemsAtIndexes:(NSIndexSet *)indexes
                    withCellItems:(NSArray<id<RSBTableViewCellItemProtocol>> *)cellItems
                    inSectionItem:(id<RSBTableViewSectionItemProtocol>)sectionItem
                 withRowAnimation:(UITableViewRowAnimation)animation {
    
    NSAssert(indexes.count == cellItems.count, @"It's impossible to replace not equals count of cell items");
    for (id<RSBTableViewCellItemProtocol> cellItem in cellItems) {
        [self registerCellItem:cellItem];
    }
    
    [self.tableView beginUpdates];
    
    NSMutableArray<id<RSBTableViewCellItemProtocol>> *mCellItems = [NSMutableArray arrayWithArray:sectionItem.cellItems];
    [mCellItems replaceObjectsAtIndexes:indexes withObjects:cellItems];
    sectionItem.cellItems = [NSArray arrayWithArray:mCellItems];
    
    NSUInteger section = [self.sectionItems indexOfObject:sectionItem];
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:section]];
    }];
    
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    
    [self.tableView endUpdates];
}

#pragma mark Section items

- (void)removeSectionItems:(NSArray<id<RSBTableViewSectionItemProtocol>> *)sectionItems
          withRowAnimation:(UITableViewRowAnimation)animation {
    
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    for (id<RSBTableViewSectionItemProtocol> sectionItem in sectionItems) {
        NSAssert([self.sectionItems containsObject:sectionItem], @"It's impossible to remove section items that are not contained in section items array");
        NSUInteger section = [self.sectionItems indexOfObject:sectionItem];
        [indexes addIndex:section];
    }
    
    [self.tableView beginUpdates];
    
    NSMutableArray<id<RSBTableViewSectionItemProtocol>> *mSectionItems = [NSMutableArray arrayWithArray:self.sectionItems];
    [mSectionItems removeObjectsAtIndexes:indexes];
    self.sectionItems = [NSArray arrayWithArray:mSectionItems];
    
    [self.tableView deleteSections:indexes withRowAnimation:animation];
    
    [self.tableView endUpdates];
}

- (void)insertSectionItems:(NSArray<id<RSBTableViewSectionItemProtocol>> *)sectionItems
                 atIndexes:(NSIndexSet *)indexes
          withRowAnimation:(UITableViewRowAnimation)animation {
    
    NSAssert([indexes firstIndex] <= self.sectionItems.count, @"It's impossible to insert item at index that is larger than count of section items");
    for (id<RSBTableViewSectionItemProtocol> sectionItem in sectionItems) {
        [self registerSectionItem:sectionItem];
    }
    
    [self.tableView beginUpdates];
    
    NSMutableArray<id<RSBTableViewSectionItemProtocol>> *mSectionItems = [NSMutableArray arrayWithArray:self.sectionItems];
    [mSectionItems insertObjects:sectionItems atIndexes:indexes];
    self.sectionItems = [NSArray arrayWithArray:mSectionItems];
    
    [self.tableView insertSections:indexes withRowAnimation:animation];
    
    [self.tableView endUpdates];
}

- (void)replaceSectionItemsAtIndexes:(NSIndexSet *)indexes
                    withSectionItems:(NSArray<id<RSBTableViewSectionItemProtocol>> *)sectionItems
                        rowAnimation:(UITableViewRowAnimation)animation {
    
    NSAssert(indexes.count == sectionItems.count, @"It's impossible to replace not equals count of section items");
    for (id<RSBTableViewSectionItemProtocol> sectionItem in sectionItems) {
        [self registerSectionItem:sectionItem];
    }
    
    [self.tableView beginUpdates];
    
    NSMutableArray<id<RSBTableViewSectionItemProtocol>> *mSectionItems = [NSMutableArray arrayWithArray:self.sectionItems];
    [mSectionItems replaceObjectsAtIndexes:indexes withObjects:sectionItems];
    self.sectionItems = [NSArray arrayWithArray:mSectionItems];
    
    [self.tableView reloadSections:indexes withRowAnimation:animation];
    
    [self.tableView endUpdates];
}

#pragma mark Other

- (void)setSectionItems:(NSArray<id<RSBTableViewSectionItemProtocol>> *)sectionItems {
    _sectionItems = sectionItems;
    for (id<RSBTableViewSectionItemProtocol> sectionItem in _sectionItems) {
        [self registerSectionItem:sectionItem];
    }
    [self.tableView reloadData];
}

- (CGRect)frameForCellItem:(id<RSBTableViewCellItemProtocol>)cellItem inSectionItem:(id<RSBTableViewSectionItemProtocol>)sectionItem {
    NSInteger sectionIndex = [self.sectionItems indexOfObject:sectionItem];
    if (sectionIndex < 0 || sectionIndex == NSNotFound) {
        return CGRectZero;
    }
    
    NSInteger cellIndex = [sectionItem.cellItems indexOfObject:cellItem];
    if (cellIndex < 0 || cellIndex == NSNotFound) {
        return CGRectZero;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:cellIndex inSection:sectionIndex];
    CGRect frame = [self.tableView rectForRowAtIndexPath:indexPath];
    
    return frame;
}

- (void)scrollToCellItem:(id<RSBTableViewCellItemProtocol>)cellItem
           inSectionItem:(id<RSBTableViewSectionItemProtocol>)sectionItem
        atScrollPosition:(UITableViewScrollPosition)position
                animated:(BOOL)animated {
    
    NSInteger sectionItemIndex = [self.sectionItems indexOfObject:sectionItem];
    NSInteger cellItemIndex = [sectionItem.cellItems indexOfObject:cellItem];
    if (sectionItemIndex < 0 || sectionItemIndex == NSNotFound ||
        cellItemIndex < 0 || cellItemIndex == NSNotFound) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:cellItemIndex inSection:sectionItemIndex];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:position animated:animated];
}

- (void)scrollToTopAnimated:(BOOL)animated {
    UIEdgeInsets insets = self.tableView.contentInset;
    [self.tableView setContentOffset:CGPointMake(0.0, insets.top) animated:animated];
}

#pragma mark - Helpers

- (void)registerSectionItem:(id<RSBTableViewSectionItemProtocol>)sectionItem {
    NSAssert([[sectionItem class] conformsToProtocol:@protocol(RSBTableViewSectionItemProtocol)], @"Section items should conform to RSBTableViewSectionItemProtocol");
    for (id<RSBTableViewCellItemProtocol> cellItem in sectionItem.cellItems) {
        NSAssert([[cellItem class] conformsToProtocol:@protocol(RSBTableViewCellItemProtocol)], @"Cell items should conform to RSBTableViewCellItemProtocol");
        [self registerCellItem:cellItem];
    }
}

- (void)registerCellItem:(id<RSBTableViewCellItemProtocol>)cellItem {
    NSString *reuseIdentifier = NSStringFromClass(cellItem.class);
    NSString *possibleStoryboardReuseIdentifier = [self reuseIdentifierForCellItem:cellItem];
    
    BOOL usedStoryboardReuseIdentifier = ![reuseIdentifier isEqualToString:possibleStoryboardReuseIdentifier];
    
    if (!usedStoryboardReuseIdentifier) {
        SEL nibSelector = @selector(registeredTableViewCellNib);
        SEL classSelector = @selector(registeredTableViewCellClass);
        
        if ([cellItem respondsToSelector:nibSelector]) {
            UINib *nib = cellItem.registeredTableViewCellNib;
            NSAssert(nib != nil, @"Your cell item %@ adopt %@ method, but provide nil", reuseIdentifier, NSStringFromSelector(nibSelector));
            
            [self.tableView registerNib:nib forCellReuseIdentifier:reuseIdentifier];
        }
        else if ([cellItem respondsToSelector:classSelector]) {
            Class class = cellItem.registeredTableViewCellClass;
            NSAssert(class != nil, @"Your cell item %@ adopt %@ method, but provide nil", reuseIdentifier, NSStringFromSelector(classSelector));
            
            [self.tableView registerClass:class forCellReuseIdentifier:reuseIdentifier];
        }
        else {
            [NSException raise:@"RSBTableViewManager register exception" format:@"You have to provide at least one of the following methods registeredTableViewCellNib, registeredTableViewCellClass or storyboardPrototypeTableViewCellReuseIdentifier."];
        }
    }
}

- (NSString *)reuseIdentifierForCellItem:(id<RSBTableViewCellItemProtocol>)cellItem {
    NSString *reuseIdentifier = NSStringFromClass(cellItem.class);
    
    SEL storyboardSelector = @selector(storyboardPrototypeTableViewCellReuseIdentifier);
    if ([cellItem respondsToSelector:storyboardSelector]) {
        NSString *storyboardReuseIdentifier = cellItem.storyboardPrototypeTableViewCellReuseIdentifier;
        NSAssert(storyboardReuseIdentifier != nil, @"Your cell item %@ adopt %@ method, but provide nil", reuseIdentifier, NSStringFromSelector(storyboardSelector));
        
        reuseIdentifier = storyboardReuseIdentifier;
    }
    return reuseIdentifier;
}

- (id<RSBTableViewCellItemProtocol>)cellItemForIndexPath:(NSIndexPath *)indexPath {
    id<RSBTableViewSectionItemProtocol> sectionItem = [self sectionItemForIndexPath:indexPath];
    if (indexPath.row < sectionItem.cellItems.count) {
        return sectionItem.cellItems[indexPath.row];
    }
    return nil;
}

- (id<RSBTableViewSectionItemProtocol>)sectionItemForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.sectionItems.count) {
        return self.sectionItems[indexPath.section];
    }
    return nil;
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<RSBTableViewSectionItemProtocol> sectionItem = self.sectionItems[section];
    return sectionItem.cellItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<RSBTableViewCellItemProtocol> cellItem = [self cellItemForIndexPath:indexPath];
    return [cellItem heightInTableView:tableView atIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    id<RSBTableViewCellItemProtocol> cellItem = [self cellItemForIndexPath:indexPath];
    if ([cellItem respondsToSelector:@selector(willDisplayCell:inTableView:atIndexPath:)]){
        [cellItem willDisplayCell:cell inTableView:tableView atIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    id<RSBTableViewCellItemProtocol> cellItem = [self cellItemForIndexPath:indexPath];
    if ([cellItem respondsToSelector:@selector(didEndDisplayingCell:inTableView:atIndexPath:)]){
        [cellItem didEndDisplayingCell:cell inTableView:tableView atIndexPath:indexPath];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<RSBTableViewCellItemProtocol> cellItem = [self cellItemForIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self reuseIdentifierForCellItem:cellItem] forIndexPath:indexPath];
    [cellItem configureCell:cell inTableView:tableView atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    id<RSBTableViewCellItemProtocol> cellItem = [self cellItemForIndexPath:indexPath];
    if ([cellItem respondsToSelector:@selector(shouldHighlightInTableView:atIndexPath:)]) {
        return [cellItem shouldHighlightInTableView:tableView atIndexPath:indexPath];
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    id<RSBTableViewCellItemProtocol> cellItem = [self cellItemForIndexPath:indexPath];
    if ([cellItem respondsToSelector:@selector(didHighlightInTableView:atIndexPath:)]) {
        [cellItem didHighlightInTableView:tableView atIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    id<RSBTableViewCellItemProtocol> cellItem = [self cellItemForIndexPath:indexPath];
    if ([cellItem respondsToSelector:@selector(didUnhighlightInTableView:atIndexPath:)]) {
        [cellItem didUnhighlightInTableView:tableView atIndexPath:indexPath];
    }
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id<RSBTableViewCellItemProtocol> cellItem = [self cellItemForIndexPath:indexPath];
    if ([cellItem respondsToSelector:@selector(willSelectInTableView:atIndexPath:)]) {
        return [cellItem willSelectInTableView:tableView atIndexPath:indexPath];
    }
    return indexPath;
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    id<RSBTableViewCellItemProtocol> cellItem = [self cellItemForIndexPath:indexPath];
    if ([cellItem respondsToSelector:@selector(willDeselectInTableView:atIndexPath:)]) {
        return [cellItem willDeselectInTableView:tableView atIndexPath:indexPath];
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id<RSBTableViewCellItemProtocol> cellItem = [self cellItemForIndexPath:indexPath];
    [cellItem didSelectInTableView:tableView atIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    id<RSBTableViewCellItemProtocol> cellItem = [self cellItemForIndexPath:indexPath];
    [cellItem didDeselectInTableView:tableView atIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    id<RSBTableViewSectionItemProtocol> sectionItem = self.sectionItems[section];
    if ([sectionItem respondsToSelector:@selector(heightForHeaderInTableView:)]) {
        return [sectionItem heightForHeaderInTableView:tableView];
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    id<RSBTableViewSectionItemProtocol> sectionItem = self.sectionItems[section];
    if ([sectionItem respondsToSelector:@selector(heightForFooterInTableView:)]) {
        return [sectionItem heightForFooterInTableView:tableView];
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    id<RSBTableViewSectionItemProtocol> sectionItem = self.sectionItems[section];
    if ([sectionItem respondsToSelector:@selector(viewForHeaderInTableView:)]) {
        return [sectionItem viewForHeaderInTableView:tableView];
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    id<RSBTableViewSectionItemProtocol> sectionItem = self.sectionItems[section];
    if ([sectionItem respondsToSelector:@selector(viewForFooterInTableView:)]) {
        return [sectionItem viewForFooterInTableView:tableView];
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id<RSBTableViewSectionItemProtocol> sectionItem = self.sectionItems[section];
    if ([sectionItem respondsToSelector:@selector(titleForHeaderInTableView:)]) {
        return [sectionItem titleForHeaderInTableView:tableView];
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    id<RSBTableViewSectionItemProtocol> sectionItem = self.sectionItems[section];
    if ([sectionItem respondsToSelector:@selector(titleForFooterInTableView:)]) {
        return [sectionItem titleForFooterInTableView:tableView];
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    id<RSBTableViewCellItemProtocol> cellItem = [self cellItemForIndexPath:indexPath];
    if (![cellItem respondsToSelector:@selector(canEditInTableView:)]) {
        return NO;
    }
    return [cellItem canEditInTableView:tableView];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    id<RSBTableViewSectionItemProtocol> sectionItem = self.sectionItems[indexPath.section];
    id<RSBTableViewCellItemProtocol> cellItem = sectionItem.cellItems[indexPath.row];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BOOL commitAvailable = YES;
        if ([cellItem respondsToSelector:@selector(canCommitEditingStyle:inTableView:)]) {
            commitAvailable = [cellItem canCommitEditingStyle:editingStyle inTableView:tableView];
        }
        if (commitAvailable) {
            [CATransaction begin];
            [CATransaction setCompletionBlock:^{
                if ([cellItem respondsToSelector:@selector(didFinishRemoveAnimationFromTableView:atIndexPath:)]) {
                    [cellItem didFinishRemoveAnimationFromTableView:tableView atIndexPath:indexPath];
                }
            }];
            [self removeCellItems:@[cellItem] fromSectionItem:sectionItem withRowAnimation:UITableViewRowAnimationAutomatic];
            [CATransaction commit];
            
            if ([cellItem respondsToSelector:@selector(didRemoveFromTableView:atIndexPath:)]) {
                [cellItem didRemoveFromTableView:tableView atIndexPath:indexPath];
            }
        }
    }
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<RSBTableViewCellItemProtocol> cellItem = [self cellItemForIndexPath:indexPath];
    if ([cellItem respondsToSelector:@selector(editActionsInTableView:)]) {
        return [cellItem editActionsInTableView:self.tableView];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    id<RSBTableViewSectionItemProtocol> sectionItem = self.sectionItems[section];
    if ([sectionItem respondsToSelector:@selector(willDisplayHeaderView:inTableView:forSection:)]) {
        [sectionItem willDisplayHeaderView:view inTableView:tableView forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    id<RSBTableViewSectionItemProtocol> sectionItem = self.sectionItems[section];
    if ([sectionItem respondsToSelector:@selector(willDisplayFooterView:inTableView:forSection:)]) {
        [sectionItem willDisplayFooterView:view inTableView:tableView forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    id<RSBTableViewSectionItemProtocol> sectionItem = self.sectionItems[section];
    if ([sectionItem respondsToSelector:@selector(didEndDisplayingHeaderView:inTableView:forSection:)]) {
        [sectionItem didEndDisplayingHeaderView:view inTableView:tableView forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section {
    id<RSBTableViewSectionItemProtocol> sectionItem = self.sectionItems[section];
    if ([sectionItem respondsToSelector:@selector(didEndDisplayingFooterView:inTableView:forSection:)]) {
        [sectionItem didEndDisplayingFooterView:view inTableView:tableView forSection:section];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if ([self.delegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)]) {
        return [self.delegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
    }
    return proposedDestinationIndexPath;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<RSBTableViewCellItemProtocol> cellItem = [self cellItemForIndexPath:indexPath];
    if ([cellItem respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)]) {
        return [cellItem tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    id<RSBTableViewCellItemProtocol> cellItem = [self cellItemForIndexPath:indexPath];
    if ([cellItem respondsToSelector:@selector(canMoveRowAtIndexPath:inTableView:)]) {
        return [cellItem canMoveRowAtIndexPath:indexPath inTableView:tableView];
    }
    return NO;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if ([self.delegate respondsToSelector:@selector(sectionIndexTitlesForTableView:)]) {
        return [self.delegate sectionIndexTitlesForTableView:tableView];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:)]) {
        return [self.delegate tableView:tableView sectionForSectionIndexTitle:title atIndex:index];
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if ([self.delegate respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)]) {
        [self.delegate tableView:tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewDidScroll:)]){
        [self.scrollDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewDidZoom:)]){
        [self.scrollDelegate scrollViewDidZoom:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]){
        [self.scrollDelegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]){
        [self.scrollDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]){
        [self.scrollDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]){
        [self.scrollDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]){
        [self.scrollDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]){
        [self.scrollDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)]){
        return [self.scrollDelegate viewForZoomingInScrollView:scrollView];
    }
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]){
        [self.scrollDelegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]){
        [self.scrollDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]){
        return [self.scrollDelegate scrollViewShouldScrollToTop:scrollView];
    }
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]){
        [self.scrollDelegate scrollViewDidScrollToTop:scrollView];
    }
}

@end
