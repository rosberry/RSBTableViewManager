//
//  NameCellItem.m
//  TableViewManager
//
//  Created by Anton Kovalev on 15.04.16.
//  Copyright © 2016 Rosberry. All rights reserved.
//

#import "NameCellItem.h"
#import "TextTableViewCell.h"

@implementation NameCellItem

- (void)configureCell:(TextTableViewCell *)cell inTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    [cell.titleLabel setText:self.name];
}

- (CGFloat)heightInTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (UINib *)registeredTableViewCellNib {
    return [UINib nibWithNibName:NSStringFromClass([TextTableViewCell class]) bundle:nil];
}

- (BOOL)canEditInTableView:(UITableView *)tableView {
    return YES;
}

@end
