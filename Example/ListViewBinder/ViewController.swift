//
//  ViewController.swift
//  ListViewBinder
//
//  Created by jacknathan on 12/28/2022.
//  Copyright (c) 2022 jacknathan. All rights reserved.
//

import UIKit
import ListViewBinder
import RxSwift

class ViewController: UIViewController, TableViewDataSourceBinder {
    typealias SectionModel = TableVSectionData
    var disposeBag = DisposeBag()

    lazy var tableView: UITableView = {
        let tbv = UITableView.init(frame: view.bounds, style: .plain)
        tbv.rowHeight = 100
        tbv.register(MyCell.self, forCellReuseIdentifier: MyCell.description())
        return tbv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        startBinder(with: tableView)
        
        // model可以自定义类型
        let row1 = RowData(identity: MyCell.description(), model: "model1")
        let row2 = RowData(identity: MyCell.description(), model: "model2")
        let row3 = RowData(identity: MyCell.description(), model: "model3")
//        let section = TableVSectionData.init(items: [row1, row2, row3])
//        let section2 = TableVSectionData.init(items: [row1, row2, row3])
        // 单组的写法
        let page = PageItem<SectionModel>.singleSection(page: 0, rows: [row1, row2, row3])
        // 多组的写法
//        let page = PageItem.multiSection(page: 0, sections: [section, section2])
        
        // 网络请求返回的结果绑定到PageData处理
        Observable
            .just(page)
            .bind(to: pageData)
            .disposed(by: disposeBag)
    }

}

class MyCell: UITableViewCell, CellConfigData {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(nameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(model: Any, indexPath: IndexPath) {
        nameLabel.frame = CGRect.init(x: 15, y: 30, width: 100, height: 30)
        if let name = model as? String {
            nameLabel.text = name
        }
    }
    
    lazy var nameLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.red
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
}
