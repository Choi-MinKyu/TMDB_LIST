컨벤션
1.1 임포트
내장 프레임워크를 먼저 임포트하고, 빈 줄로 구분해 3rd-party프레임워크를 임포트 합니다.
import UIKit

import RxSwift
import RxCocoa
파일이 필요로하는 최소의 모듈만 임포트 합니다. 예를들어, Foundation으로 충분하면 UIKit은 임포트 하지 않습니다.
✅ Good

import UIKit

var view: UIView
var productNames: [String]
✅ Good

import Foundation

var productNames: [String]
⛔️ Bad

import UIKit
import Foundation

var view: UIView
var productNames: [String]
⛔️ Bad

import UIKit

var productNames: [String]
모듈의 상세까지 지정할 수 있으면 지정합니다.
1.2 빈줄
빈 줄에는 공백이 포함되지 않도록 합니다. (코드와 코드 사이의 빈 줄)
모든 파일은 빈 줄로 끝나도록 합니다.
1.3 들여쓰기
탭은 4개의 space를 사용합니다.
1.4 띄어쓰기
콜론(:)을 사용할때는 콜론의 오른쪽에만 공백을 둡니다.
[상수]

✅ Good

let products: [String: String]?
⛔️ Bad

let products: [String:String]?
let products: [String : String]?
[클래스]

✅ Good

class ViewController: UIViewController {
  // ...
}
⛔️ Bad

class ViewController : UIViewController {
  // ...
}
삼항연산자의 경우 콜론 앞뒤로 띄웁니다.
✅ Good

shouldRotate ? .allButUpsideDown : .portrait
⛔️ Bad

shouldRotate ? .allButUpsideDown: .portrait
[기타]

✅ Preferred

let titlelabel: UILabel

let personDictionry: [String: String] = [
    "name": "Jobs",
    "address": ""
]

func myFunction<T, U: SomeProtocol>(firstArgument: U, secondArgument: T) where T.RelatedType == U {
    /* ... */
}

someFunction(someArgument: "Kitten")

class ViewController: UIViewController {
    /* ... */
}

extension TargetType: URLRequestConvertible {
    /* ... */
}
일반적으로 콤마(,) 뒤에는 공백을 추가합니다.
✅ Good

let myArray = [1, 2, 3, 4, 5]

⛔️ Bad

let myArray = [1,2,3,4,5]
연산자 앞뒤로 공백을 추가합니다.
✅ Good

let myValue = 20 + (30 / 2) * 3
⛔️ Bad

let myValue = 20+(30/2)*3

화살표 양쪽에 가독성을 위해 빈 공백을 추가합니다.
[함수 리턴 타입]

✅ Good

func doSomething() -> String {
  // ...
}
⛔️ Bad

func doSomething()->String {
  // ...
}
[클로저 리턴 타입]

✅ Good

func doSomething(completion: () -> Void) {
  // ...
}
⛔️ Bad

func doSomething(completion: ()->Void) {
  // ...
}
[Rx]

✅ Good

.map { $0.call.farePaymentType }
.map { method -> String? in
    guard let name = method.name else { return nil }
    return Local.Taxi.taxiDispatchingPaidItemApply.string.phrase(["item_name": name])
}
⛔️ Bad

.map {$0.call.farePaymentType}
.map {method -> String? in
    guard let name = method.name else { return nil }
    return Local.Taxi.taxiDispatchingPaidItemApply.string.phrase(["item_name": name])
}
✅ Good

var bizGroupHidden: Driver<Bool> {
    self.callInfo.asObservable()
        .map { $0.call.bizGroup }
        .map { $0 == nil }
        .asDriverJustComplete()
}
⛔️ Bad

var bizGroupHidden:Driver<Bool> {
    self.callInfo.asObservable()
        .map { $0.call.bizGroup }
        .map { $0 == nil }
        .asDriverJustComplete()
}
1.5 괄호
불필요한 괄호는 생략합니다.
✅ Good

if userCount > 0 { ... }
switch someValue { ... }
let evens = userCounts.filter { number in number % 2 == 0 }
let squares = userCounts.map { $0 * $0 }
⛔️ bad

if (userCount > 0) { ... }
switch (someValue) { ... }
let evens = userCounts.filter { (number) in number % 2 == 0 }
let squares = userCounts.map() { $0 * $0 }
enum의 연관값을 사용하지 않는 경우는 생략합니다.
✅ Good

if case .done = result { ... }

switch animal {
case .dog:
  ...
}
⛔️ Bad

if case .done(_) = result { ... }

switch animal {
case .dog(_, _, _):
  ...
}
2. 네이밍
묘사를 잘하고 일관된 네이밍은 코드를 읽고 이해하기 쉽게 해줍니다. 네이밍은 Apple의 API Design Guidelines을 따릅니다.
클래스(타입, 프로토콜 이름 포함) 이름에는 UpperCamelCase(첫 문자를 대문자로 시작하는 camel표기법), 함수 이름에는 camelCase를 사용합니다.
2.1 일반
[일반]

✅ Good

`protocol SpaceThing { // ... }

class SpaceFleet: SpaceThing {

enum Formation { // ... }

class Spaceship { // ... }

var ships: [Spaceship] = [] static let worldName: String = "Earth"

func addShip(_ ship: Spaceship) { // ... } }

let myFleet = SpaceFleet()`

[변수/상수]

일반변수 / 상수인 경우 따로 접두사를 붙이지 않습니다.
✅ Good

let maximumNumberOfLines = 3

⛔️ Bad

let kMaximumNumberOfLines = 3 let MAX_LINES = 3

static 상수인 경우 앞에 k를 붙여줍니다.
✅ Good

static let kMaximumNumberOfLines = 3

⛔️ Bad

static let maximumNumberOfLines = 3

[열거형]

✅ Good

enum Result { case success case failure }

⛔️ Bad

enum Result { case Success case Failure }

[RxSwift]

RxSwift의 Subject, Driver, ControlerProperty, ControlEvent 등은 따로 접미사를 붙이지 않습니다.
✅ Good

let recommendItem = BehaviorRelay<RecommendRideItem?>(value: nil) let optionSwitch = PublishSubject<Void>() let showRideSuggestion = PublishSubject<Void>()

⛔️ Bad

let recommendItem = BehaviorRelay<RecommendRideItem?>(value: nil) let optionSwitchSignal = PublishSubject<Void>() let showRideSuggestionPS = PublishSubject<Void>()

일반적인 부분이 앞에두고 구체적인 부분을 뒤에 둡니다.
✅ Good

let titleMarginRight: CGFloat let titleMarginLeft: CGFloat let bodyMarginRight: CGFloat let bodyMarginLeft: CGFloat

⛔️ Bad

let rightTitleMargin: CGFloat let leftTitleMargin: CGFloat let bodyRightMargin: CGFloat let bodyLeftMargin: CGFloat

생략시 사용이 모호해지는 타입은 이름에 타입에 대한 힌트를 포함시킵니다.
✅ Good

let titleText: String let cancelButton: UIButton

⛔️ Bad

let title: String let cancel: UIButton

2.2 클래스
함수 이름에는 되도록 get을 붙이지 않습니다.
✅ Good

func name(for user: User) -> String?

⛔️ Bad

func getName(for user: User) -> String?

2.3 함수
액션 함수의 네이밍은 ‘주어 + 동사 + 목적어’ 형태를 사용합니다.
will은 특정 행위가 일어나기 직전이고, did는 특정 행위가 일어난 직후입니다.
✅ Good

func backButtonDidTap() { // ... }

⛔️ Bad

`func back() { // ... }

func pressBack() { // ... }`

2.4 약어
약어로 시작하는 경우 소문자로 표기하고, 그 외 경우에는 항상 대문자로 표기합니다.
[예1]

✅ Good

let userID: Int? let html: String? let websiteURL: URL? let urlString: String?

⛔️ Bad

let userId: Int? let HTML: String? let websiteUrl: NSURL? let URLString: String?

[예2]

✅ Good

`class URLValidator {

func isValidURL(_ url: URL) -> Bool { // ... }

func isProfileURL(_ url: URL, for userID: String) -> Bool { // ... } }

let urlValidator = URLValidator() let isProfile = urlValidator.isProfileUrl(urlToTest, userID: idOfUser)`

⛔️ Bad

`class UrlValidator {

func isValidUrl(_ URL: URL) -> Bool { // ... }

func isProfileUrl(_ URL: URL, for userId: String) -> Bool { // ... } }

let URLValidator = UrlValidator() let isProfile = URLValidator.isProfileUrl(URLToTest, userId: IDOfUser)`

3. 기타
3.1 클로저
파라미터와 리턴 타입이 없는 클로저 정의시에는 () -> Void 를 사용합니다.
✅ Good

let completionBlock: (() -> Void)?

⛔️ Bad

let completionBlock: (() -> ())? let completionBlock: ((Void) -> (Void))?

클로저 정의시 파라미터에는 괄호를 사용하지 않습니다.
✅ Good

{ operation, responseObject in // doSomething() }

⛔️ Bad

{ (operation, responseObject) in // doSomething() }

클로저 정의시 가능한 경우 타입 정의를 생략합니다.
✅ Good

completion: { finished in // doSomething() }

⛔️ Bad

completion: { (finished: Bool) -> Void in // doSomething() }

클로저 호출시 또 다른 유일한 클로저를 마지막 파라미터로 받는 경우, 파라미터 이름을 생략합니다.
✅ Good

UIView.animate(withDuration: 0.5) { // doSomething() }

⛔️ Bad

UIView.animate(withDuration: 0.5, animations: { () -> Void in // doSomething() })

사용하지 않는 파라미터는 _를 사용해 표시합니다.
✅ Good

someAsyncThing() { _, _, argument3 in print(argument3) }

⛔️ Bad

// WRONG someAsyncThing() { argument1, argument2, argument3 in print(argument3) }

한줄 클로저는 반드시 각 괄호 양쪽을 공백을 추가해야 합니다.
✅ Good

let evenSquares = numbers.filter { $0 % 2 == 0 }.map { $0 * $0 }

⛔️ Bad

let evenSquares = numbers.filter {$0 % 2 == 0}.map {  $0 * $0  }

3.2 클래스와 구조체
구조체를 생성할 때는 Swift 구조체 생성자를 사용합니다.
✅ Good

let frame = CGRect(x: 0, y: 0, width: 100, height: 100)

⛔️ Bad

let frame = CGRectMake(0, 0, 100, 100)

3.3 타입
Array<T>와, Dictionary<T: U> 보다는 [T], [T: U]를 사용합니다.
✅ Good

var messages: [String]? var names: [Int: String]?

⛔️ Bad

var messages: Array<String>? var names: Dictionary<Int, String>?

3.4 타입추론 사용
컴파일러가 문맥속에서 타입을 추론할 수 있으면 더 간결한 코드를 위해 타입을 생략합니다.
✅ Good

let selector = #selector(viewDidLoad) view.backgroundColor = .red let toView = context.view(forKey: .to) let view = UIView(frame: .zero)

⛔️ Bad

let selector = #selector(ViewController.viewDidLoad) view.backgroundColor = UIColor.red let toView = context.view(forKey: UITransitionContextViewKey.to) let view = UIView(frame: CGRect.zero)

3.5 self
문법의 모호함을 제거하기 위해 언어에서 필수로 요구하지 않는 이상 self는 사용하지 않도록 권장하지만, 멤버 변수와 지역 변수의 빠른 가독성을 위해 self 사용을 권장합니다.
`final class Listing { private let isFamilyFriendly: Bool private var capacity: Int

init(capacity: Int, allowsPets: Bool) { ✅ Good self.capacity = capacity self.isFamilyFriendly = !allowsPets

  ⛔️ Bad
  capacity = capacity
  isFamilyFriendly = !allowsPets
}

private func increaseCapacity(by amount: Int) { ✅ Good self.capacity += amount

  ⛔️ Bad
  capacity += amount

  ✅ Good
  self.save()

  ⛔️ Bad
  save()
} }`

✅ Good

TaxiPush.progressing.asPushActionObservable(callInfo.value.call.id) .map { $0.progressing }.unwrap() .map { $0/60 } .bind(to: self.timeRadius) .disposed(by: self.disposeBag)

⛔️ Bad

TaxiPush.progressing.asPushActionObservable(callInfo.value.call.id) .map { $0.progressing }.unwrap() .map { $0 / 60 } .bind(to: timeRadius) .disposed(by: disposeBag)

3.6 튜플
튜플의 맴버에는 명확성을 위해 이름을 붙여줍니다. 만약 필드가 3개를 넘는 경우 struct를 사용을 고려해보는 것을 권장합니다.
✅ Good

func whatever() -> (x: Int, y: Int) { return (x: 4, y: 4) }

⛔️ Bad

func whatever() -> (Int, Int) { return (4, 4) } let thing = whatever() print(thing.0)

✅ Okay

`func whatever2() -> (x: Int, y: Int) { let x = 4 let y = 4 return (x, y) }

let coord = whatever() coord.x coord.y`

✅ Good

.map { ($0.coord, nil, false) } .withLatestFrom(viewModel.swapController) { (mapInfo: $0, swapController: $1) } .filter { guard case .search = $0.swapController else { return false }; return true } .map { $0.0 }, // ⛔️ Bad

.map { ($0.coord, nil, false) } .withLatestFrom(viewModel.swapController) { ($0, $1) } .filter { guard case .search = $0.1 else { return false }; return true } .map { $0.0 },

3.7 패턴
프로퍼티의 초기화는 가능하면 init에서하고 가능하다면 unwrapped Optionl의 사용을 지양합니다.
✅ Good

`class MyClass: NSObject {

init() { someValue = 0 super.init() }

var someValue: Int }`

⛔️ Bad

`class MyClass: NSObject {

init() { super.init() }

var someValue: Int? }`

3.8 제네릭
제네릭 타입 파라미터는 대문자를 사용하고 묘사적이어야 합니다. 타입 이름이 의미있는 관계나 역할을 갖지 않는 경우에만 T, U 혹은 V 같은 전형적인 단일 대문자를 사용하고 그 외에는 의미있는 이름을 사용합니다.
✅ Good

struct Stack<Element> { ... } func write<Target: OutputStream>(to target: inout Target) func swap<T>(_ a: inout T, _ b: inout T)

⛔️ Bad

struct Stack<T> { ... } func write<target: OutputStream>(to target: inout target) func swap<Thing>(_ a: inout Thing, _ b: inout Thing)

3.9 static
디폴트 타입 매소드는 static을 사용합니다.
✅ Good

class Fruit { static func eatFruits(_ fruits: [Fruit]) { ... } }

⛔️ Bad

class Fruit { class func eatFruits(_ fruits: [Fruit]) { ... } }

3.10 final
더 이상 상속이 발생하지 않는 클래스는 항상 final 키워드로 선언합니다.
✅ Good

final class SettingsRepository { // ... }

⛔️ Bad

class SettingsRepository { // ... }

3.11 프로토콜 extension
프로토콜을 적용할 때는 extension을 만들어서 관련된 매소드를 모아둡니다.
✅ Good

`final class ViewController: UIViewController { // ... }

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource { // ... }

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate { // ... }`

⛔️ Bad

final class MyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate { // ... }

3.12 switch-case
switch-case에서 가능한 경우 default를 사용하지 않습니다.
새로운 case가 생성됐을때 인지하지 못한 상태에서 default로 처리되지 않고 의도적으로 처리를 지정해 주기 위함입니다.
✅ Good

switch anEnum { case .a: // Do something case .b, .c: // Do something else. }

⛔️ Bad

switch anEnum { case .a: // Do something default: // Do something else. }

3.13 return
return은 생략 가능하다면 생략합니다.
✅ Good

`["1", "2", "3"].compactMap { return Int($0) }

var size: CGSize { CGSize(width: 100.0, height: 100.0) }

func makeInfoAlert(message: String) -> UIAlertController { return UIAlertController(title: "ℹ️ Info", message: message, preferredStyle: .alert) }`

⛔️ Bad

`["1", "2", "3"].compactMap { return Int($0) }

var size: CGSize { return CGSize(width: 100.0, height: 100.0) }

func makeInfoAlert(message: String) -> UIAlertController { return UIAlertController(title: "Info", message: message, preferredStyle: .alert) }`
