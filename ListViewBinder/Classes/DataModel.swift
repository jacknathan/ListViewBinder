//
//  DataModel.swift
//  RxListViewBinder
//
//  Created by jackpro on 2022/12/13.
//

import UIKit
import Differentiator
import RxSwift

// 配置Section
public protocol ListSection: SectionModelType where Item == RowData {
    var items: [RowData] {get set}
    init(items: [RowData])
}


// 配置UICollectionView的组数据
public protocol CollectionSection: ListSection {
    var header: SupplementaryInfo? {get set} // header resuseIdentify
    var footer: SupplementaryInfo? {get set} // footer resuseIdentify
    init(items: [RowData],
         header: SupplementaryInfo?,
         footer: SupplementaryInfo?)
}

// 数据model配置 UITableViewCell/UICollectionViewCell
public struct RowData {
    public var identity: String
    public var model: Any?
    public init(identity: String,
                model: Any? = nil) {
        self.identity = identity
        self.model = model
    }
}

// tableView的section model （业务层可自己定义）
public struct TableVSectionData: ListSection {
    public typealias RowItem = Any
    public var items: [RowData]
    public init(items: [RowData]) {
        self.items = items
    }
    public init(original: TableVSectionData, items: [RowData]) {
        self = original
        self.items = items
    }
}

// 配置SupplementaryView数据
public struct SupplementaryInfo {
    var reuseIdStr: String
    var model: Any?
    init(reuseIdStr: String,
         model: Any?) {
        self.reuseIdStr = reuseIdStr
        self.model = model
    }
}

// collectionView的section model （业务层可自己定义）
public struct CollectionVSectionData: CollectionSection {
    public var items: [RowData]
    public var header: SupplementaryInfo? // header resuseIdentify
    public var footer: SupplementaryInfo? // footer resuseIdentify
    
    public init(items: [RowData],
                header: SupplementaryInfo? = nil,
                footer: SupplementaryInfo? = nil) {
        self.header = header
        self.items = items
        self.footer = footer
    }
    public init(items: [RowData]) {
        self.items = items
    }
    
    public init(original: CollectionVSectionData,
                items: [RowData]) {
        self = original
        self.items = items
    }
}
// 业务层（网络请求）返回的单页数据，分单section和多section的情况
public enum PageItem<S: ListSection>{
    // 只有一个section的情况
    case singleSection(page: Int, rows: [RowData])
    // 多个section的情况
    case multiSection(page: Int, sections: [S])
}

internal struct AssociateKey {
    static var state = "AssociateKey_state"
    static var dataArray = "AssociateKey_dataArray"
}

