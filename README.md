# RSBTableViewManager #

With this manager you will never need to write any `UITableViewDelegate` or `UITableViewDataSource` methods anymore.

### Install via Cocoapods ###
```
pod 'RSBTableViewManager'
```
to your `Podfile` and run
```
pod install
```

### How to use ###
It is easy as pie. All you need to do is
```
RSBTableViewManager *tableViewManager = [[RSBTableViewManager alloc] initWithTableView:tableView];
[tableViewManager setSectionItems:sectionItems];
```
That's all. 
As you already understand you need section items for manager to work. This items are describe your table view's sections and contain cell items. The only purpose of cell item is describing cell's representation in table view.

For creating section items you need subclass/use `RSBTableViewSectionItem` or create/use your own class which will adopt `RSBTableViewSectionItemProtocol` and fill it with cell items. You can create them by subclass/use `RSBTableViewCellItem` or create/use your own class which will adopt `RSBTableViewCellItemProtocol` for cell items.

Each cell item represents one cell class at a time and contains all related datasource and delegate methods for displaying it and handling events related to cell. 

Didn't understand something? Download repo and run example project.
