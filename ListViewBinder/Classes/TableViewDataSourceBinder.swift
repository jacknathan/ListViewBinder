//
//  TableViewDataSourceBinder.swift
//  RxListViewBinder
//
//  Created by jackpro on 2022/12/20.
//

import UIKit
import RxDataSources
import RxRelay
import RxSwift

public protocol TableViewDataSourceBinder : ListViewBinder {
    // 已默认实现，可重写
    var dataSource : DataSource {get}
    // 已默认实现，可重写
    var configureCell : ConfigureCell {get}
}

extension TableViewDataSourceBinder  {
    public typealias ConfigureCell = RxTableViewSectionedReloadDataSource<SectionModel>.ConfigureCell
    public typealias DataSource = RxTableViewSectionedReloadDataSource<SectionModel>
    
    /// 将UITableView与RxDataSource的数据源绑定, 该方法必须前置调用
    public func binder(with view: UITableView) {
        dataArray = BehaviorRelay(value: [])
        dataArray
            .asObservable()
            .bind(to: view.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    public var configureCell : ConfigureCell {
        return {(_, tbv, indexPath, item) in
            let cell = tbv.dequeueReusableCell(withIdentifier: item.identity) ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
            if let npc = cell as? CellConfigData, let model = item.model {
                npc.config(model: model, indexPath: indexPath)
            }
            return cell
        }
    }
    public var dataSource : DataSource {
        return RxTableViewSectionedReloadDataSource<SectionModel>(configureCell: configureCell)
    }
}
