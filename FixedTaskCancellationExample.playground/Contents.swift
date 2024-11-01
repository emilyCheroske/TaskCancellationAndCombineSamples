import UIKit
import Combine
import SwiftUI

class FixedTaskCancellation {
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var property: Int = 0
    
    init() {
        $property.sink { [weak self] newValue in
            guard let self else { return }
            print("::FixedTaskCancellation:: newValue \(newValue)")
            
            Task {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                print("::FixedTaskCancellation:: task \(newValue) finished")
            }.store(in: &subscriptions)
            
        }.store(in: &subscriptions)
    }
    
    deinit {
        print("::FixedTaskCancellation:: ** deinit **")
        subscriptions.removeAll()
    }
    
    public func increment() {
        property = property + 1
    }
}

extension Task {
    func store(in set: inout Set<AnyCancellable>) {
        set.insert(AnyCancellable(cancel))
    }
}

var fixed: FixedTaskCancellation? = FixedTaskCancellation()
fixed?.increment()
fixed?.increment()
fixed?.increment()
fixed = nil
