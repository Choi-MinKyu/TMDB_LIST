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
        case noAction
    }
    
    enum MutateActionType {
        case noMutate
    }
    
    struct OutputActionType {
        let title: PublishRelay<String> = .init()
        let subTitle: PublishRelay<String> = .init()
    }
    
    struct Output {
        let title: Driver<String>
        let subTitle: Driver<String>
    }
    
    let typeValueForOutput: OutputActionType = .init()
    
    private let model: MovieModel?
    
    init(model: MovieModel?) {
        self.model = model
    }
}

extension CollectionTableViewCEllViewModel {
    func generateOutput(from outputActionType: OutputActionType) -> Output {
        .init(title: outputActionType.title.asDriver(onErrorJustReturn: ""), subTitle: outputActionType.subTitle.asDriver(onErrorJustReturn: ""))
    }
}

extension CollectionTableViewCEllViewModel {
    func action(inputAction: InputActionType) -> Observable<MutateActionType> {
        return .empty()
    }
    
    func update(mutateAction: MutateActionType) {
        switch mutateAction {
        case .noMutate:
            self.typeValueForOutput.title.accept("test action")
        }
    }
}
