//
//  ViewController.m
//  TableViewManager
//
//  Created by Anton Kovalev on 15.04.16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

#import "ViewController.h"
#import "RSBTableViewManager.h"
#import "NameCellItem.h"

@interface ViewController ()

@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) RSBTableViewManager *tableViewManager;
@property (nonatomic) NSArray *names;
@property (nonatomic) NSArray *otherNames;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureTableViewManagerWithTableView:self.tableView];
    [self createNamesArray];
    [self updateSectionItems];
}

#pragma mark - Configure

- (void)configureTableViewManagerWithTableView:(UITableView *)tableView {
    [tableView setTableFooterView:[[UIView alloc] init]];
    self.tableViewManager = [[RSBTableViewManager alloc] initWithTableView:tableView];
}

- (void)createNamesArray {
    self.names = @[@"John", @"Max", @"Andrew", @"Jim", @"Jack", @"Arnold", @"Ryan"];
    self.otherNames = @[@"James", @"Bill", @"Steve", @"Ronald", @"Jason", @"Cameron", @"Alan"];
}

#pragma mark - Cell items

- (NameCellItem *)nameCellItemWithName:(NSString *)name {
    NameCellItem *item = [[NameCellItem alloc] init];
    [item setName:name];
    [item setItemDidSelectBlock:^(UITableView *__weak tableView, NSIndexPath *indexPath) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
//        [self removeAllSectionsButFirst];
//        [self replaceFirstAndSecondSectionItems];
//        [self insertTwoSectionItemsAfterFirstSection];
        
//        [self removeAllButFirstCellItemsInSectionWithIndex:indexPath.section];
//        [self replaceAllCellItemsInSectionWithIndex:indexPath.section];
//        [self insertNewItemsInSectionWithIndex:indexPath.section];
        
//        [self scrollToItemAtIndexPath:indexPath];
        [self logFrameForItemAtIndexPath:indexPath];
//        [self scrollToTop];
    }];
    return item;
}

#pragma mark - Section items

- (void)updateSectionItems {
    NSMutableArray *ma = [NSMutableArray array];
    for (int i = 0; i < 5; ++i) {
        RSBTableViewSectionItem *sectionItem = [self namesSectionItem];
        [sectionItem setHeaderTitle:[NSString stringWithFormat:@"%li", (long)i+1]];
        [ma addObject:sectionItem];
    }
    
    [self.tableViewManager setSectionItems:[NSArray arrayWithArray:ma]];
}

- (RSBTableViewSectionItem *)namesSectionItem {
    NSMutableArray *ma = [NSMutableArray array];
    for (NSString *name in self.names) {
        [ma addObject:[self nameCellItemWithName:name]];
    }
    
    return [[RSBTableViewSectionItem alloc] initWithCellItems:[NSArray arrayWithArray:ma]];
}

- (RSBTableViewSectionItem *)otherNamesSectionItem {
    NSMutableArray *ma = [NSMutableArray array];
    for (NSString *name in self.otherNames) {
        [ma addObject:[self nameCellItemWithName:name]];
    }
    
    return [[RSBTableViewSectionItem alloc] initWithCellItems:[NSArray arrayWithArray:ma]];
}

#pragma mark - Work with table
#pragma mark Sections

- (void)removeAllSectionsButFirst {
    NSArray *sectionItems = self.tableViewManager.sectionItems;
    
    RSBTableViewSectionItem *firstItem = sectionItems.firstObject;
    
    NSMutableArray *ma = [NSMutableArray arrayWithArray:sectionItems];
    [ma removeObject:firstItem];
    
    [self.tableViewManager removeSectionItems:[NSArray arrayWithArray:ma] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)replaceFirstAndSecondSectionItems {
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)];
    
    NSArray *nItems = @[self.otherNamesSectionItem, self.otherNamesSectionItem];
    
    NSInteger i = indexes.firstIndex;
    for (RSBTableViewSectionItem *sectionItem in nItems) {
        [sectionItem setHeaderTitle:[NSString stringWithFormat:@"%li", (long)i+1]];
    }
    
    [self.tableViewManager replaceSectionItemsAtIndexes:indexes withSectionItems:nItems rowAnimation:UITableViewRowAnimationMiddle];
}

- (void)insertTwoSectionItemsAfterFirstSection {
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)];
    
    NSArray *nItems = @[self.otherNamesSectionItem, self.otherNamesSectionItem];
    
    NSInteger i = indexes.firstIndex;
    for (RSBTableViewSectionItem *sectionItem in nItems) {
        [sectionItem setHeaderTitle:[NSString stringWithFormat:@"%li", (long)i+1]];
    }
    
    [self.tableViewManager insertSectionItems:nItems atIndexes:indexes withRowAnimation:UITableViewRowAnimationTop];
}

#pragma mark Cells

- (void)removeAllButFirstCellItemsInSectionWithIndex:(NSInteger)sectionIndex {
    RSBTableViewSectionItem *sectionItem = self.tableViewManager.sectionItems[sectionIndex];
    
    RSBTableViewCellItem *firstItem = sectionItem.cellItems.firstObject;
    
    NSMutableArray *ma = [NSMutableArray arrayWithArray:sectionItem.cellItems];
    [ma removeObject:firstItem];
    
    [self.tableViewManager removeCellItems:[NSArray arrayWithArray:ma] fromSectionItem:sectionItem withRowAnimation:UITableViewRowAnimationRight];
}

- (void)replaceAllCellItemsInSectionWithIndex:(NSInteger)sectionIndex {
    RSBTableViewSectionItem *sectionItem = self.tableViewManager.sectionItems[sectionIndex];
    RSBTableViewSectionItem *otherNamesItem = self.otherNamesSectionItem;
    
    NSAssert(sectionItem.cellItems.count == otherNamesItem.cellItems.count, @"Count of items should be equal");
    
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, sectionItem.cellItems.count)];
    
    [self.tableViewManager replaceCellItemsAtIndexes:indexes withCellItems:otherNamesItem.cellItems inSectionItem:sectionItem withRowAnimation:UITableViewRowAnimationFade];
}

- (void)insertNewItemsInSectionWithIndex:(NSInteger)sectionIndex {
    RSBTableViewSectionItem *sectionItem = self.tableViewManager.sectionItems[sectionIndex];
    RSBTableViewSectionItem *otherNamesItem = self.otherNamesSectionItem;
    
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(sectionItem.cellItems.count, otherNamesItem.cellItems.count)];
    
    [self.tableViewManager insertCellItems:otherNamesItem.cellItems toSectionItem:sectionItem atIndexes:indexes withRowAnimation:UITableViewRowAnimationTop];
}

#pragma mark - Other manager methods

- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath {
    RSBTableViewSectionItem *sectionItem = self.tableViewManager.sectionItems[indexPath.section];
    RSBTableViewCellItem *cellItem = sectionItem.cellItems[indexPath.row];
    
    [self.tableViewManager scrollToCellItem:cellItem inSectionItem:sectionItem atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)logFrameForItemAtIndexPath:(NSIndexPath *)indexPath {
    RSBTableViewSectionItem *sectionItem = self.tableViewManager.sectionItems[indexPath.section];
    RSBTableViewCellItem *cellItem = sectionItem.cellItems[indexPath.row];
    
    CGRect frame = [self.tableViewManager frameForCellItem:cellItem inSectionItem:sectionItem];
    
    NSLog(@"[Frame] [Section %li, Row %li] %@", (long)indexPath.section, (long)indexPath.row, NSStringFromCGRect(frame));
}

- (void)scrollToTop {
    [self.tableViewManager scrollToTopAnimated:YES];
}

@end
