//
//  ViewModelBase.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/09/14.
//

import RxSwift
import RxCocoa
import Foundation

//

/// Apple DataFlow 에 따라 흐름이 발생합니다.
///
/// ```
/// view 에서 viewModel 의 output 객체에 접근하여, view를 업데이트하도록 돕습니다.
/// 이제 view 는 output에 반응하여야 하며, viewModel 에 input event 를 통해
///  event를 발생시켜야합니다.
///
/// viewModel.output.value1.map(\.load).bind(self.view.rx.bgColor)
/// viewModel.output.value2.map(\.stringValue).bind(self.label.rx.text)
/// ```
///
/// - See Also: [Data Flow](https://developer.apple.com/documentation/swiftui/state-and-data-flow)
///
///

public protocol ViewModelBase: AnyObject {
    associatedtype InputActionType
    associatedtype MutateActionType
    associatedtype OutputActionType
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    var input: PublishRelay<InputActionType> { get }
    var typeValueForOutput: OutputActionType { get }
    
    func makeStream() -> Driver<OutputActionType>
    func before(inputAction: Observable<InputActionType>) -> Observable<InputActionType>
    func action(inputAction: InputActionType) -> Observable<MutateActionType>
    func composit(mutateAction: Observable<MutateActionType>) -> Observable<MutateActionType>
    func update(mutateAction: MutateActionType)// -> Observable<OutputActionType>
    func afterUpdate(outputAction: Observable<OutputActionType>) -> Observable<OutputActionType>
    
//    func set()
    func generateOutput(from outputActionType: OutputActionType) -> Output
}

// MARK: - Constant Key Types

fileprivate enum ViewModelKeyType {
    static var input = "input"
    static var output = "output"
    static var disposeBagKey = "disposeBag"
}

extension ViewModelBase {
    func makeStream() -> Driver<OutputActionType> {
        let beforInputAction = self.before(inputAction: self._input.asObservable())
        let mutation = beforInputAction
            .withUnretained(self)
            .flatMap { $0.action(inputAction: $1).catch { _ in .empty() } }
        
        let compositAction = self.composit(mutateAction: mutation)
        /*let update = */compositAction
            .withUnretained(self)
            .map { $0.0.update(mutateAction: $0.1) }
            .catch { _ in .empty() }
            .observe(on: MainScheduler.instance)
            .subscribe()
            .disposed(by: self.disposeBag)
        
//        let afterUpdate = self.afterUpdate(outputAction: update)
//            .withUnretained(self)
//            .map { $1 }
//            .share()
//            .asDriver(onErrorJustReturn: typeValueForOutput)

        return Observable.just(typeValueForOutput).asDriver(onErrorJustReturn: typeValueForOutput)
    }
    
    public func before(inputAction: Observable<InputActionType>) -> Observable<InputActionType> {

        return inputAction
    }
    
    public func composit(mutateAction: Observable<MutateActionType>) -> Observable<MutateActionType> {

        return mutateAction
    }
    
    public func afterUpdate(outputAction: Observable<OutputActionType>) -> Observable<OutputActionType> {
        outputAction.subscribe().disposed(by: self.disposeBag)
        return outputAction
    }
}

// MARK: - disposeBag

extension ViewModelBase {
    
    public var disposeBag: DisposeBag {
        get {
            if let value = objc_getAssociatedObject(self, &ViewModelKeyType.disposeBagKey) as? DisposeBag {
                return value
            }
            
            let disposeBag = DisposeBag()
            
            objc_setAssociatedObject(self, &ViewModelKeyType.disposeBagKey, disposeBag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return disposeBag
        }
        
        set {
            objc_setAssociatedObject(self, &ViewModelKeyType.disposeBagKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// MARK: - command

extension ViewModelBase {
    private var _input: PublishRelay<InputActionType> {
        get {
            if let value = objc_getAssociatedObject(self, &ViewModelKeyType.input) as? PublishRelay<InputActionType> {
                return value
            }
            
            let inputAction: PublishRelay<InputActionType> = PublishRelay()
//            inputAction.subscribe(onNext: bind).disposed(by: disposeBag)
            
            objc_setAssociatedObject(self, &ViewModelKeyType.input, inputAction, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return inputAction
        }
    }
    
    public var input: PublishRelay<InputActionType> {
        _ = self.output
        
        return self._input
    }
    
    public var output: Output {
        get {
            if let value = objc_getAssociatedObject(self, &ViewModelKeyType.output) as? Output {
                return value
            }
            
//            let output = self.makeStream()
            _ = self.makeStream()
            let output = generateOutput(from: typeValueForOutput)
            
            objc_setAssociatedObject(self, &ViewModelKeyType.output, output, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return output
        }
    }
}


