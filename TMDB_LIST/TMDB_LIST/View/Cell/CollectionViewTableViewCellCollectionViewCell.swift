//
//  CollectionViewTableViewCellCollectionViewCell.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/08/12.
//

import UIKit
import RxSwift
import RxDataSources

protocol CollectionViewTableViewCEllDelegate: AnyObject {
    func CollectionViewTableViewCEllDidTapCell(_ cell: CollectionViewTableViewCEll, viewModel: YoutubeSearchViewModel)
}

final class CollectionViewTableViewCEll: UITableViewCell {
    static let identifier = "CollectionViewTableViewCellCollectionViewCell"
    
    var disposeBag: DisposeBag = .init()
    
    private var movieModels = [MovieModel]()
    
    weak var delegate: CollectionViewTableViewCEllDelegate?
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        $0.scrollDirection = .horizontal
        $0.itemSize = CGSize(width: 140, height: 200)
        return $0
    }(UICollectionViewFlowLayout())
    
    private lazy var collectionView: UICollectionView = {
        $0.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
        super.prepareForReuse()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.collectionView.frame = self.contentView.bounds
    }
}

extension CollectionViewTableViewCEll: ViewModelBindableType {
    func bindInput(viewModel: CollectionTableViewCEllViewModel) {
        Observable.just(.load)
            .bind(to: viewModel.input)
            .disposed(by: self.disposeBag)
        
        // ViewModel 로 옮기면 Best~!!@
        self.collectionView.rx.modelSelected(MovieModel.self)
            .map { ($0.title, $0.overview) }
            .flatMapLatest { (titleName, overView) in
                let titleName = titleName ?? ""
                let overView = overView ?? ""

                return Observable.create { observer in
                    SimpleAPI.shared.youtube(with: titleName) { value in
                        switch value {
                        case .success(let videoElement):
                            let youtubeViewModel = YoutubeSearchViewModel(title: titleName, youtubeViewElement: videoElement, overView: overView)
                            observer.onNext(youtubeViewModel)
                            observer.onCompleted()
                        case .failure(let error):
                            print(error.localizedDescription)
                            observer.onCompleted()
                        }
                    }
                    
                    return Disposables.create()
                }
            }
            .subscribe(with: self, onNext: {
                $0.delegate?.CollectionViewTableViewCEllDidTapCell(self, viewModel: $1)
            })
            .disposed(by: self.disposeBag)
    }
    
    func bindOutput(viewModel: CollectionTableViewCEllViewModel) {
        let datasource = TitleCellDataSource.dataSource()
        
        viewModel.output
            .models
            .map { Section(header: "", items: $0) }
            .map { [$0] }
            .drive(self.collectionView.rx.items(dataSource: datasource))
            .disposed(by: self.disposeBag)
    }
}

extension CollectionViewTableViewCEll: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movieModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let movieModel = self.movieModels[indexPath.item]
        cell.viewModel = TitleCollectionCellViewModel(model: movieModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let movieModel = self.movieModels[indexPath.item]
        
//        let titleName = movieModel.titleName.isEmpty ? movieModel.title : movieModel.titleName
//        
//        SimpleAPI.shared.youtube(with: titleName) { [weak self] in
//            guard let self = self else { return }
//            
//            switch $0 {
//            case .success(let videoElement):
//                guard !movieModel.overView.isEmpty else { return }
//                let youtubeViewModel = YoutubeSearchViewModel(title: titleName, youtubeViewElement: videoElement, overView: movieModel.overView)
//                self.delegate?.CollectionViewTableViewCEllDidTapCell(self, viewModel: youtubeViewModel)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let downloadActionButton = UIAction(title: "다운로드", state: .off) { _ in
                print("Touch 3DButton")
            }
            
            return UIMenu(title: "", options: .displayInline, children: [downloadActionButton])
        }
        
        return config
    }
}
