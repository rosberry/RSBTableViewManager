# RSBTableViewManager #

* You will never need to write any `UITableViewDelegate` or `UITableViewDataSource` methods anymore.
* This manager encapsulate all `UITableView` stuff and allows you to work only with section items - objects that adopt `RSBTableViewSectionItemProtocol` and represent sections of `UITableView`. This section items contains cell items - objects that adopt `RSBTableViewCellItemProtocol` and represent cells of `UITableView`.
* Version 1.0.0

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
As you already understand you need section items for manager to work. They are describe your table view's sections and contain cell items. The only purpose of cell item is describing cell's representation in table view.

For creating section items you need subclass/use `RSBTableViewSectionItem` or create/use your own class which will adopt `RSBTableViewSectionItemProtocol` and fill it with cell items you can use them by subclass/use `RSBTableViewCellItem` or create/use your own class which will adopt `RSBTableViewCellItemProtocol` for cell items.

Each cell item represents one cell class at time and contains all related datasource and delegate methods for right displaying it. 

Didn't understand something? Download repo and run example project.
