//
//  ViewConfigProtocol.swift
//  RxListViewBinder
//
//  Created by jackpro on 2022/12/20.
//

import UIKit

// 通过data配置cell
public protocol CellConfigData {
    func config(model: Any, indexPath: IndexPath) -> Void
}

//// 通过data配置UICollectionReusableView(header/footer)
//public protocol SupplementaryViewConfig {
//    /// UICollectionReusableView数据配置
//    /// - Parameters:
//    ///   - model: SectionData或者它的子类
//    ///   - kind: elementKindSectionHeader/elementKindSectionFooter
//    /// - Returns: void
//    func config<T: CollectionSection>(model: T,
//                                      kind: String,
//                                      indexPath: IndexPath) -> Void
//}
