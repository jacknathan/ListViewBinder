//
//  EmptyHolder.swift
//  RxListViewBinder
//
//  Created by jackpro on 2022/12/15.
//

import UIKit
import EmptyDataSet_Swift

/*
 tableView和collectionView没数据的时候占位图配置
 */
public struct EmptyViewConfig {
    // 全局默认样式的配置（修改后全局生效）
    public static var shared = EmptyViewConfig()
    // 背景色
    public var backgroundColor: UIColor?
    // 自定义空视图
    public var customEmptyView: UIView?
    // 占位图片
    public var image: UIImage?
    // 是否允许滚动
    public var allowScroll = true
    // 垂直偏移量
    public var verticalOffset: CGFloat = .zero
    // 提示
    public var title: NSAttributedString? = NSAttributedString(
        string: "暂无数据~",
        attributes: [.font: UIFont.boldSystemFont(ofSize: 16.0),
                     .foregroundColor: UIColor.black])
    // 描述
    public var descriptionString: NSAttributedString?
}

/// 占位图协议
public protocol EmptyHolder: EmptyDataSetSource, EmptyDataSetDelegate {
    var state: EmptyViewConfig {get set}
}

extension EmptyHolder where Self: ListViewBinder {
    public var state: EmptyViewConfig {
        get {
            return objc_getAssociatedObject(self, &AssociateKey.state) as? EmptyViewConfig ?? EmptyViewConfig.shared
        }
        set {
            objc_setAssociatedObject(self, &AssociateKey.state, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // 需调用该方法来开启 空列表占位图 功能
    public func enableEmptyView(scrollView: UIScrollView ,
                                config: EmptyViewConfig? = nil) {
        self.state = config ?? EmptyViewConfig.shared
        scrollView.emptyDataSetSource = self
        scrollView.emptyDataSetDelegate = self
        setupEmpty(scrollView)
    }
    
    // 是否没有数据
    public var isEmpty: Bool {
        return dataArray.value.allSatisfy { $0.items.count == 0 }
    }

    // 是否展示空视图占位图
    public var shouldDisplayEmpty: Bool {
        return isEmpty
//        return isEmpty && !isLoading
    }

    // 设置空视图处理
    func setupEmpty(_ scrollView: UIScrollView) {
        dataArray
            .asObservable()
            .map{_ in return self.isEmpty }
            .skip(1)
            .subscribe(onNext: { _ in
                scrollView.reloadEmptyDataSet()
        }).disposed(by: disposeBag)
    }
}

extension EmptyHolder where Self: ListViewBinder {
    public func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return shouldDisplayEmpty
    }
    public func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        return state.customEmptyView
    }
    public func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return state.image
    }
    public func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return state.title
    }

    public func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return state.descriptionString
    }
    
    public func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return state.allowScroll
    }
    public func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        return state.backgroundColor
    }
    public func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return state.verticalOffset
    }
}
