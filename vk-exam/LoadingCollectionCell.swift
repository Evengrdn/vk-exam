//
//  LoadingCollectionCell.swift
//  vk-exam
//
//  Created by Maksim Kuznecov on 22.10.2023.
//

import UIKit
import SnapKit

class LoadingCollectionCell: UICollectionViewCell {
    
    var activityIndicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        contentView.addSubview(activityIndicator)
    }
    
    private func prepareView () {
        activityIndicator.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

