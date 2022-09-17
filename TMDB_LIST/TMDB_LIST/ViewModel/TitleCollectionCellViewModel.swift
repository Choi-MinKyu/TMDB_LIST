//
//  TitleCollectionCellViewModel.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/09/17.
//

import RxSwift
import RxCocoa

class TitleCollectionCellViewModel: ViewModelBase {
    enum InputActionType {
        case no
    }
    
    enum MutateActionType {
        case no
    }
    
    struct OutputActionType {
        let data: PublishRelay<String> = .init()
    }
    
    struct Output {
        let data: Driver<String>
    }
    
    let typeValueForOutput: OutputActionType = .init()
    
    private let model: MovieModel?
    
    init(model: MovieModel?) {
        self.model = model
    }
}

extension TitleCollectionCellViewModel {
    func generateOutput(from outputActionType: OutputActionType) -> Output {
        .init(data: self.typeValueForOutput.data.asDriver(onErrorJustReturn: ""))
    }
}

extension TitleCollectionCellViewModel {
    func action(inputAction: InputActionType) -> Observable<MutateActionType> {
        .empty()
    }
    
    func update(mutateAction: MutateActionType) {
        
    }
}
