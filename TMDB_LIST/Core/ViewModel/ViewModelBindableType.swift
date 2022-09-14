//
//  ViewModelBindableType.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/09/14.
//

import RxSwift
import Foundation
import UIKit

public protocol ViewModelBindableType: AnyObject {
    associatedtype ViewModel
    
    var disposeBag: DisposeBag { get set }
    var viewModel: ViewModel? { get set }
    
    func bindOutput(viewModel: ViewModel)
    func bindInput(viewModel: ViewModel)
}

// MARK: - Constant Key Types

fileprivate enum ViewModelKeyType {
    static var viewModel = "viewModel"
    static var disposeBagKey = "disposeBag"
}

// MARK: - disposeBag

extension ViewModelBindableType {
    
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

// MARK: - viewModel

extension ViewModelBindableType where Self: UIViewController {
    public var viewModel: ViewModel? {
        get {
            if let value = objc_getAssociatedObject(self, &ViewModelKeyType.viewModel) as? ViewModel {
                return value
            }
            
            return nil
        }
        
        set {
            objc_setAssociatedObject(self, &ViewModelKeyType.viewModel, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
//            let viewController = self as? UIViewController
            self.rx.loadView
                .asObservable()
                .replace(newValue)
                .bind(onNext: bind(viewModel: ))
                .disposed(by: self.disposeBag)
        }
    }
    
    func bind(viewModel: ViewModel?) {
        if let viewModel = viewModel {
            bindOutput(viewModel: viewModel)
            bindInput(viewModel: viewModel)
        }
    }
}

extension ViewModelBindableType where Self: UITableViewCell {
    public var viewModel: ViewModel? {
        get {
            if let value = objc_getAssociatedObject(self, &ViewModelKeyType.viewModel) as? ViewModel {
                return value
            }
            
            return nil
        }
        
        set {
            objc_setAssociatedObject(self, &ViewModelKeyType.viewModel, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            layoutIfNeeded()
            self.bind(viewModel: newValue)
        }
    }
    
    func bind(viewModel: ViewModel?) {
        if let viewModel = viewModel {
            bindOutput(viewModel: viewModel)
            bindInput(viewModel: viewModel)
        }
    }
}

