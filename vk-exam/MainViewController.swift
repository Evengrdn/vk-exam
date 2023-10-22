//
//  MainViewController.swift
//  vk-exam
//
//  Created by Maksim Kuznecov on 20.10.2023.
//

import UIKit
import SnapKit

enum Section {
    case content
}

class MainViewController: UIViewController {
    
    private let viewModel = MainViewModel()
    
    private var isWating = false
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Gifs>!
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collView.showsVerticalScrollIndicator = false
        collView.delegate = self
        collView.register(ImagePreviewCollectionCell.self, forCellWithReuseIdentifier: "ImagePreviewCollectionCell")
        
        return collView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        makeConstraints()
        setDataSourses()
        initRequest()
    }
    
    private func prepareView() {
        title = "Main"
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
    }
    
    private func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    
    private func initRequest() {
        Task {
            await viewModel.fetchImages()
            updateDataSorce()
        }
    }
    
    private func updateDataSorce() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Gifs>()
        snapshot.appendSections([.content])
        snapshot.appendItems(viewModel.images)
        dataSource.apply(snapshot)
    }
    
    
    private func setDataSourses() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagePreviewCollectionCell", for: indexPath) as! ImagePreviewCollectionCell
            
            cell.configureCell(imageOne: model.gifOne, imageTwo: model.gifTwo)
            return cell
        })
    }
    
    private func requestMoreData() {
        Task {
            await viewModel.fetchMore(offset: viewModel.images.count * 2)
            await MainActor.run {
                updateDataSorce()
                isWating = false
            }
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.bounds.width
        if indexPath.section == 0 {
            return CGSize(width: availableWidth, height: 200)
        } else {
            return CGSize(width: availableWidth, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.images.count - 2 && !isWating {
            isWating = true
            requestMoreData()
        }
    }
}
