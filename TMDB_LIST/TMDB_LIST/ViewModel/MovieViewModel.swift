//
//  ViewModel.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/08/13.
//

import RxSwift
import RxCocoa
import Foundation

final class MovieViewModel: ViewModelBase {
    enum InputActionType {
        case load
    }
    
    enum MutateActionType {
        case movies(VideoSectionItem)
        case error(String)
    }
    
    struct OutputActionType {
        let models: PublishRelay<[MovieModel]> = PublishRelay()
        let networkError: PublishRelay<String> = PublishRelay()
        var sections: BehaviorRelay<[VideoSectionModel]> = .init(value: [
            .thumbnail(title: "section1", items: []),
            .thumbnail(title: "section2", items: []),
            .thumbnail(title: "section3", items: []),
            .thumbnail(title: "section4", items: []),
            .thumbnail(title: "section5", items: []),
        ])
    }
    
    struct Output {
        let models: Driver<[MovieModel]>
        let networkError: Driver<String>
        let sections: Driver<[VideoSectionModel]>
    }
    
    let typeValueForOutput = OutputActionType()
    
    var movieModel: MovieModel? = nil
    
    init(movieModel: MovieModel?) {
        self.movieModel = movieModel
    }
    
    // to delete

    var titleName: String {
        self.movieModel?.original_title ?? ""
    }

    var title: String {
        self.movieModel?.title ?? ""
    }

    var thumbnailImageUrl: String {
        self.movieModel?.poster_path ?? ""
    }

    var overView: String {
        self.movieModel?.overview ?? ""
    }
    // to delete
}

extension MovieViewModel {
    func action(inputAction: InputActionType) -> RxSwift.Observable<MutateActionType> {
        switch inputAction {
        case .load:
            return Observable.create { observer in
                SimpleAPI.shared.movies {
                    switch $0 {
                    case .success(let movies):
                        let cellViewModel = CollectionTableViewCEllViewModel(model: movies)
                        let sectionItem = VideoSectionItem.ImageSectionItem(cellViewModel)
                        observer.onNext(.movies(sectionItem))
                        
                    case .failure(let error):
                        observer.onNext(.error(error.localizedDescription))
                    }
                    observer.onCompleted()
                }

                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        }
    }
    
    func update(mutateAction: MutateActionType) {
        switch mutateAction {
        case .movies(let sectionItem):
            var sections = self.typeValueForOutput.sections.value
            let item = VideoSectionModel(original: sections[0], items: [sectionItem])
            sections[0] = item

            self.typeValueForOutput.sections.accept(sections)
        case .error(let errorString):
            self.typeValueForOutput.networkError.accept(errorString)
        }
    }
    
    func generateOutput(from outputActionType: OutputActionType) -> Output {
        Output(models: outputActionType.models.asDriver(onErrorJustReturn: []),
               networkError: outputActionType.networkError.asDriver(onErrorJustReturn: ""),
               sections: outputActionType.sections.asDriver(onErrorJustReturn: []))
    }
}
