//
//  SearchFooter.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 27.10.2020.
//

import UIKit

class SearchFooter: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    let label = UILabel()
    
    override func draw(_ rect: CGRect) {
        label.frame = bounds
    }

    private func configureView() {
        backgroundColor = .darkGray
        alpha = 0
        
        label.textAlignment = .center
        label.textColor = .white
        addSubview(label)
    }
    
    private func hightFooter() {
        alpha = 0
    }
    
    private func showFooter() {
        alpha = 1
    }
}

extension SearchFooter {
    
    func setIsNotFiltering() {
        label.text = ""
        hightFooter()
    }
    
    func setIsFilteringShow(filteredItemCount: Int, totalItemCount: Int) {
        
        switch filteredItemCount {
        case totalItemCount: setIsNotFiltering()
        case 0: label.text = "No item mutch you query"
            showFooter()
        default:
            label.text = "Filtering: \(filteredItemCount) in \(totalItemCount)"
            showFooter()
        }
    }
}
