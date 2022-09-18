//
//  CollectionTableViewCEllViewModel.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/09/17.
//

import RxSwift
import RxCocoa

final class CollectionTableViewCEllViewModel: ViewModelBase {
    enum InputActionType {
        case load
    }
    
    enum MutateActionType {
        case models([MovieModel])
    }
    
    struct OutputActionType {
        let models: PublishRelay<[MovieModel]> = .init()
    }
    
    struct Output {
        let models: Driver<[MovieModel]>
    }
    
    let typeValueForOutput: OutputActionType = .init()
    
    private let model: [MovieModel]?
    
    init(model: [MovieModel]?) {
        self.model = model
    }
}

extension CollectionTableViewCEllViewModel {
    func generateOutput(from outputActionType: OutputActionType) -> Output {
        .init(models: outputActionType.models.asDriver(onErrorJustReturn: []))
    }
}

extension CollectionTableViewCEllViewModel {
    func action(inputAction: InputActionType) -> Observable<MutateActionType> {
        switch inputAction {
        case .load:
            guard let models = self.model else { return .empty() }
            
            return .just(.models(models))
        }
    }
    
    func update(mutateAction: MutateActionType) {
        switch mutateAction {
        case .models(let models):
            self.typeValueForOutput.models.accept(models)
        }
    }
}
