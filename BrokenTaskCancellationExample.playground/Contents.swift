import UIKit
import Combine
import SwiftUI

class DemoBrokenTaskCancellation {
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var property: Int = 0
    
    init() {
        $property.sink { [weak self] newValue in
            guard let self else { return }
            print("::DemoBrokenTaskCancellation:: newValue \(newValue)")
            
            Task {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                print("::DemoBrokenTaskCancellation:: task \(newValue) finished")
            }
            
        }.store(in: &subscriptions)
    }
    
    deinit {
        print("::DemoBrokenTaskCancellation:: ** deinit **")
        subscriptions.removeAll()
    }
    
    public func increment() {
        property = property + 1
    }
}

var broken: DemoBrokenTaskCancellation? = DemoBrokenTaskCancellation()
broken?.increment()
broken?.increment()
broken?.increment()
broken = nil
