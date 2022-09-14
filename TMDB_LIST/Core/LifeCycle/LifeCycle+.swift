//
//  LifeCycle+.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/09/14.
//

import UIKit
import RxSwift
import RxCocoa

public enum ViewControllerLifeCycleState: Equatable {
    case viewWillAppear
    case viewDidAppear
    case loadView
    case viewDidLoad
    case viewWillDisappear
    case viewDidDisappear
}

extension Reactive where Base: UIViewController {
    var viewWillAppear: ControlEvent<Void> { ControlEvent(events: self.methodInvoked(#selector(base.viewWillAppear)).replace(()) ) }
    
    var viewDidAppear: ControlEvent<Void> { ControlEvent(events: self.methodInvoked(#selector(base.viewDidAppear)).replace(()) ) }
    
    var loadView: ControlEvent<Void> { ControlEvent(events: self.methodInvoked(#selector(base.loadView)).replace(()) ) }

    var viewDidLoad: ControlEvent<Void> { ControlEvent(events: self.methodInvoked(#selector(base.viewDidLoad)).replace(()) ) }
    
    var viewWillDisappear: ControlEvent<Void> { ControlEvent(events: self.methodInvoked(#selector(base.viewWillDisappear)).replace(()) ) }
    
    var viewDidDisappear: ControlEvent<Void> { ControlEvent(events: self.methodInvoked(#selector(base.viewDidDisappear)).replace(()) ) }
}

public extension Reactive where Base: UIViewController {
    var lifeCycleState: Observable<ViewControllerLifeCycleState> {
        return Observable.of(viewWillAppear.replace(.viewWillAppear),
                             viewDidAppear.replace(.viewDidAppear),
                             loadView.replace(.loadView),
                             viewDidLoad.replace(.viewDidLoad),
                             viewWillDisappear.replace(.viewWillDisappear),
                             viewDidDisappear.replace(.viewDidDisappear))
        .merge()
    }
}

public enum ApplicationAppState: Equatable {
    case inactive
    case active
    case background
    case terminated
}

public extension Reactive where Base: UIApplication {
    var applicationWillEnterForeground: Observable<ApplicationAppState> {
        NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification)
            .replace(.inactive)
    }
    
    var applicationDidBecomeActive: Observable<ApplicationAppState> {
        NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification)
            .replace(.active)
    }
    
    var applicationDidEnterBackground: Observable<ApplicationAppState> {
        NotificationCenter.default.rx.notification(UIApplication.didEnterBackgroundNotification)
            .replace(.background)
    }
    
    var applicationWillResignActive: Observable<ApplicationAppState> {
        NotificationCenter.default.rx.notification(UIApplication.willResignActiveNotification)
            .replace(.inactive)
    }
    
    var applicationWillTerminate: Observable<ApplicationAppState> {
        NotificationCenter.default.rx.notification(UIApplication.willTerminateNotification)
            .replace(.terminated)
    }
    
    var applicationLifeCycleState: Observable<ApplicationAppState> {
        Observable.of(applicationWillEnterForeground,
                      applicationDidBecomeActive,
                      applicationDidEnterBackground,
                      applicationWillResignActive,
                      applicationWillTerminate)
        .merge()
    }
}

