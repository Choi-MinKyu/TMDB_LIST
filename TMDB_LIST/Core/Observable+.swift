//
//  Observable+.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/09/14.
//

import RxSwift
import RxCocoa

extension ObservableType {
    func replace<T>(_ value: T) -> Observable<T> {
        self.map { _ in value }
    }
}

extension SharedSequenceConvertibleType {
    func replace<T>(_ value: T) -> SharedSequence<SharingStrategy, T> {
        self.map { _ in value }
    }
}
