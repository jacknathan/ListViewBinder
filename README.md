# ListViewBinder
对RxDataSource的封装，简化使用

## Example

	startBinder(with: tableView) 绑定UITableView或者UICollectionView数据源

	let row1 = RowData(identity: MyCell.description(), model: "model1")
	let row2 = RowData(identity: MyCell.description(), model: "model2")
	let row3 = RowData(identity: MyCell.description(), model: "model3")
	let page = PageItem<SectionModel>.singleSection(page: 0, rows: [row1, row2, row3])

	Observable
            .just(page)
            .bind(to: pageData)
            .disposed(by: disposeBag)
    省去实现UITableView DataSource的delegate
    详见工程中的example


## Requirements

## Installation

ListViewBinder is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ListViewBinder'
```

## Author

jacknathan, a63561158@163.com

## License

ListViewBinder is available under the MIT license. See the LICENSE file for more info.
