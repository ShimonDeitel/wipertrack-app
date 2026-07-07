import XCTest
@testable import WiperBladeTracker

@MainActor
final class WiperBladeTrackerTests: XCTestCase {
    func testAddIncreasesCount() {
        let store = Store()
        let before = store.entries.count
        store.add(WiperEntry())
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testSeedDataIsBelowFreeLimit() {
        let seed = Store.seedData()
        XCTAssertLessThan(seed.count, Store.freeLimit)
    }

    func testCanAddMoreWhenUnderLimit() {
        let store = Store()
        store.entries = []
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreWhenAtLimitAndNotPro() {
        let store = Store()
        store.isProUnlocked = false
        store.entries = (0..<Store.freeLimit).map { _ in WiperEntry() }
        XCTAssertFalse(store.canAddMore)
    }

    func testCanAddMoreWhenProUnlockedEvenAtLimit() {
        let store = Store()
        store.isProUnlocked = true
        store.entries = (0..<Store.freeLimit).map { _ in WiperEntry() }
        XCTAssertTrue(store.canAddMore)
    }

    func testAddDoesNothingWhenOverLimitAndNotPro() {
        let store = Store()
        store.isProUnlocked = false
        store.entries = (0..<Store.freeLimit).map { _ in WiperEntry() }
        let before = store.entries.count
        store.add(WiperEntry())
        XCTAssertEqual(store.entries.count, before)
    }

    func testDeleteRemovesEntry() {
        let store = Store()
        store.entries = [WiperEntry()]
        store.delete(at: IndexSet(integer: 0))
        XCTAssertTrue(store.entries.isEmpty)
    }

    func testDeleteSpecificEntry() {
        let store = Store()
        let entry = WiperEntry()
        store.entries = [entry]
        store.delete(entry)
        XCTAssertTrue(store.entries.isEmpty)
    }
}
