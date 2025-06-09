import Combine
import UIKit
import Testing

func testAsync() async {
    await confirmation("...") { cycleMappingRecordCreated in
        print("in the block....")
        for await value in DailyCycleMappingRecord.observe(day: lhSurgeDayString, on: .main).dropFirst().values {
            print("cycle mapping record created")
            cycleMappingRecordCreated()
            break
        }
    }
}
