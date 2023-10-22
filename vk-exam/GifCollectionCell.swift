//
//  GifCollectionCell.swift
//  vk-exam
//
//  Created by Maksim Kuznecov on 20.10.2023.
//

import UIKit
import SnapKit
import SwiftyGif

class ImagePreviewCollectionCell: UICollectionViewCell {
        
    private var uiImageView = UIImageView()
    
    private var uiImageViewTwo = UIImageView()
    
    private var activityIndicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        contentView.addSubview(uiImageView)
        contentView.addSubview(uiImageViewTwo)
        contentView.addSubview(activityIndicator)
        activityIndicator.isHidden = true
    }
    
    private func prepareView () {
        activityIndicator.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        uiImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(contentView.snp.centerX)
        }
        
        uiImageViewTwo.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(contentView.snp.centerX)
        }
    }
    
    func configureCell(imageOne: GyphyGif, imageTwo: GyphyGif?) {
        activityIndicator.startAnimating()
        uiImageView.load(url: URL(string: imageOne.images.downSized.url)!) { [weak self] in
            self?.activityIndicator.stopAnimating()
        }
        
        if let imageTwo = imageTwo {
            uiImageViewTwo.load(url: URL(string: imageTwo.images.downSized.url)!) { [weak self] in
                self?.activityIndicator.stopAnimating()
            }
        }
    }
}

extension UIImageView {
    func load(url: URL, actionAfter: @escaping() -> Void = {} ) {
        DispatchQueue.global().async { [weak self] in
            DispatchQueue.main.async {
                self?.setGifFromURL(url)
                actionAfter()
            }
        }
    }
}
