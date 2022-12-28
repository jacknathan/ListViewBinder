//
//  ListViewModel.swift
//  RxListViewBinder
//
//  Created by jackpro on 2022/12/19.
//
import RxSwift
import RxRelay
import Differentiator

// tableview或者collectionView数据绑定的基础协议
public protocol ListViewBinder: AnyObject {
    /*
     在implement的地方需要指定Section类型，
     可用默认类型TableVSectionData/CollectionVSectionData
    **/
    associatedtype SectionModel : ListSection
    //  dataSource数据源
    var dataArray : BehaviorRelay<[SectionModel]> {get set}
    //  业务层（网络请求）返回的单页数据
    var pageData: AnyObserver<PageData<SectionModel>> { get }
    // disposeBag
    var disposeBag : DisposeBag { get }
}

extension ListViewBinder {
    
    public var dataArray: BehaviorRelay<[SectionModel]> {
        get {
            guard let data = objc_getAssociatedObject(self, &AssociateKey.dataArray) as? BehaviorRelay<[SectionModel]> else {
                fatalError("dataArray需要先赋值，建议调用binder(with view:)方法，方法内部已初始化，也可以自行初始化")
            }
            return data
        }
        set {
            objc_setAssociatedObject(self, &AssociateKey.dataArray, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    /// 订阅网络请求返回的单页数据，处理后更新dataArray
    public var pageData: AnyObserver<PageData<SectionModel>> {
        return AnyObserver<PageData> { [unowned self] (event) in
            switch event {
            case .next(let pageItem):
                switch pageItem {
                case .singleSection(let page, let rows):
                    if page == 0 {
                        dataArray.accept([SectionModel(items: rows)])
                    } else {
                        // 加载更多数据
                        self[0]?.items.append(contentsOf: rows)
                    }
                case .multiSection(let page, let sections):
                    page == 0 ? dataArray.accept(sections) : dataArray.accept(dataArray.value + sections)
                }
            default: break
            }
        }
    }
    
    func accept(pageData: PageData<SectionModel>) {
        _ = Observable
             .just(pageData)
             .bind(to: self.pageData)
    }
    /// get/set某一section的数据
    public subscript(section: Int) -> SectionModel? {
        get {
            guard dataArray.value.count > section else { return nil }
            return dataArray.value[section]
        }
        set {
            guard dataArray.value.count > section else { return }
            var sections = dataArray.value
            if let sectionItem = newValue {
                // 替换操作
                sections[section] = sectionItem
            } else {
                // 删除操作
                sections.remove(at: section)
            }
            dataArray.accept(sections)
        }
    }
    /// get/set某一个row的数据
    public subscript(section: Int, row: Int) -> RowData? {
        get {
            guard
                dataArray.value.count > section,
                dataArray.value[section].items.count > row
            else {  return nil }
            let section = dataArray.value[section]
            return section.items[row]
        }
        set {
            guard
                dataArray.value.count > section,
                dataArray.value[section].items.count > row
            else { return }
            var sections = dataArray.value
            if let item = newValue {
                sections[section].items[row] = item
            } else {
                // 删除操作
                sections[section].items.remove(at: row)
            }
            dataArray.accept(sections)
        }
    }
}
