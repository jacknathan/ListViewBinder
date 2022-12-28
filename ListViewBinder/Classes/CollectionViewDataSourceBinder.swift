//
//  CollectionViewDataSourceBinder.swift
//  RxListViewBinder
//
//  Created by jackpro on 2022/12/20.
//
import UIKit
import RxDataSources
import RxSwift
import RxRelay

public protocol CollectionViewDataSourceBinder : ListViewBinder where SectionModel : CollectionSection {
    // 已默认实现，可重写
    var configureCell: ConfigureCell { get }
    // 已默认实现，可重写
    var configureSuppleView : ConfigureSuppleView { get }
    // 已默认实现，可重写
    var moveItem : MoveItem { get }
    // 已默认实现，可重写
    var canMoveItemAtIndexPath : CanMoveItemAtIndexPath { get }
}

extension CollectionViewDataSourceBinder {
    public typealias ConfigureCell = CollectionViewSectionedDataSource<SectionModel>.ConfigureCell
    public typealias ConfigureSuppleView = CollectionViewSectionedDataSource<SectionModel>.ConfigureSupplementaryView
    public typealias MoveItem = CollectionViewSectionedDataSource<SectionModel>.MoveItem
    public typealias CanMoveItemAtIndexPath = CollectionViewSectionedDataSource<SectionModel>.CanMoveItemAtIndexPath
    
    /// 将UICollectionView与RxDataSource的数据源绑定, 该方法必须前置调用
    public func startBinder(with view: UICollectionView) {
        dataArray = BehaviorRelay(value: [])
        dataArray.asObservable()
            .bind(to: view.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    public var configureCell: ConfigureCell {
        return {(_, tbv, indexPath, item) in
            let cell = tbv.dequeueReusableCell(withReuseIdentifier: item.identity, for: indexPath)
            if let npc = cell as? CellConfigData, let model = item.model {
                npc.config(model: model, indexPath: indexPath)
            }
            return cell
        }
    }
    
    public var configureSuppleView : ConfigureSuppleView {
        return { (dataSource, list, kind, indexPath) in
            var supplementaryView: UICollectionReusableView?
            if kind == UICollectionView.elementKindSectionHeader, let headerId = dataSource[indexPath.section].header  {
                supplementaryView = list.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
            } else if let footId = dataSource[indexPath.section].footer {
                supplementaryView = list.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footId, for: indexPath)
            }
            if let view = supplementaryView as? SupplementaryViewConfig {
                view.config(model: dataSource[indexPath.section], kind: kind, indexPath: indexPath)
            }
            return supplementaryView ?? UICollectionReusableView()
        }
    }
    public var moveItem : MoveItem {
        return { _, _, _ in () }
    }
    public var canMoveItemAtIndexPath : CanMoveItemAtIndexPath {
        return { _, _ in return false}
    }
    public var dataSource : RxCollectionViewSectionedReloadDataSource
    <SectionModel> {
        return RxCollectionViewSectionedReloadDataSource<SectionModel>(
            configureCell: self.configureCell,
            configureSupplementaryView:self.configureSuppleView,
            moveItem: self.moveItem,
            canMoveItemAtIndexPath: self.canMoveItemAtIndexPath)
    }
  
}


