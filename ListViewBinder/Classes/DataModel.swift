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
    var header: String? {get set}
    var footer: String? {get set}
    init(items: [RowData],
         header: String?,
         footer: String?)
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

// collectionView的section model （业务层可自己定义）
public struct CollectionVSectionData: CollectionSection {
    public var items: [RowData]
    public var header: String?
    public var footer: String?
    
    public init(items: [RowData],
                header: String? = nil,
                footer: String? = nil) {
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
public enum PageData<S: ListSection>{
    // 只有一个section的情况
    case singleSection(page: Int, rows: [RowData])
    // 多个section的情况
    case multiSection(page: Int, sections: [S])
}

internal struct AssociateKey {
    static var state = "AssociateKey_state"
    static var dataArray = "AssociateKey_dataArray"
}

