//
//  TitleCollectionViewCell.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/08/12.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

final class TitleCollectionViewCell: UICollectionViewCell {
    static let identifier = "TitleCollectionViewCell"
    
    var disposeBag = DisposeBag()
    
    private let thumbnailImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(thumbnailImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.thumbnailImageView.frame = self.contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }
}

extension TitleCollectionViewCell: ViewModelBindableType {
    func bindInput(viewModel: TitleCollectionCellViewModel) {
        Observable.just(.load)
            .bind(to: viewModel.input)
            .disposed(by: self.disposeBag)
    }
    
    func bindOutput(viewModel: TitleCollectionCellViewModel) {
        let baseUrlObservable = Driver.just("https://image.tmdb.org/t/p/w500/")

        viewModel.output.data
            .withLatestFrom(baseUrlObservable) { posterPath, baseUrlString in
                URL(string: "\(baseUrlString)\(posterPath)")
            }
            .compactMap { $0 }
            .drive(with: self, onNext: {
                $0.thumbnailImageView.kf.setImage(with: $1)
            })
            .disposed(by: self.disposeBag)
    }
}
