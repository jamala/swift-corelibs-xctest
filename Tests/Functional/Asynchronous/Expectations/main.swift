// RUN: %{swiftc} %s -o %{built_tests_dir}/Asynchronous
// RUN: %{built_tests_dir}/Asynchronous > %t || true
// RUN: %{xctest_checker} %t %s

#if os(Linux) || os(FreeBSD)
    import XCTest
    import Foundation
#else
    import SwiftXCTest
    import SwiftFoundation
#endif

// CHECK: Test Suite 'All tests' started at \d+:\d+:\d+\.\d+
// CHECK: Test Suite '.*\.xctest' started at \d+:\d+:\d+\.\d+

// CHECK: Test Suite 'ExpectationsTestCase' started at \d+:\d+:\d+\.\d+
class ExpectationsTestCase: XCTestCase {
// CHECK: Test Case 'ExpectationsTestCase.test_waitingForAnUnfulfilledExpectation_fails' started at \d+:\d+:\d+\.\d+
// CHECK: .*/Tests/Functional/Asynchronous/Expectations/main.swift:[[@LINE+4]]: error: ExpectationsTestCase.test_waitingForAnUnfulfilledExpectation_fails : Asynchronous wait failed - Exceeded timeout of 0.2 seconds, with unfulfilled expectations: foo
// CHECK: Test Case 'ExpectationsTestCase.test_waitingForAnUnfulfilledExpectation_fails' failed \(\d+\.\d+ seconds\).
    func test_waitingForAnUnfulfilledExpectation_fails() {
        expectation(withDescription: "foo")
        waitForExpectations(withTimeout: 0.2)
    }

// CHECK: Test Case 'ExpectationsTestCase.test_waitingForUnfulfilledExpectations_outputsAllExpectations_andFails' started at \d+:\d+:\d+\.\d+
// CHECK: .*/Tests/Functional/Asynchronous/Expectations/main.swift:[[@LINE+5]]: error: ExpectationsTestCase.test_waitingForUnfulfilledExpectations_outputsAllExpectations_andFails : Asynchronous wait failed - Exceeded timeout of 0.2 seconds, with unfulfilled expectations: bar, baz
// CHECK: Test Case 'ExpectationsTestCase.test_waitingForUnfulfilledExpectations_outputsAllExpectations_andFails' failed \(\d+\.\d+ seconds\).
    func test_waitingForUnfulfilledExpectations_outputsAllExpectations_andFails() {
        expectation(withDescription: "bar")
        expectation(withDescription: "baz")
        waitForExpectations(withTimeout: 0.2)
    }

// CHECK: Test Case 'ExpectationsTestCase.test_waitingForAnImmediatelyFulfilledExpectation_passes' started at \d+:\d+:\d+\.\d+
// CHECK: Test Case 'ExpectationsTestCase.test_waitingForAnImmediatelyFulfilledExpectation_passes' passed \(\d+\.\d+ seconds\).
    func test_waitingForAnImmediatelyFulfilledExpectation_passes() {
        let expectation = self.expectation(withDescription: "flim")
        expectation.fulfill()
        waitForExpectations(withTimeout: 0.2)
    }

// CHECK: Test Case 'ExpectationsTestCase.test_waitingForAnEventuallyFulfilledExpectation_passes' started at \d+:\d+:\d+\.\d+
// CHECK: Test Case 'ExpectationsTestCase.test_waitingForAnEventuallyFulfilledExpectation_passes' passed \(\d+\.\d+ seconds\).
    func test_waitingForAnEventuallyFulfilledExpectation_passes() {
        let expectation = self.expectation(withDescription: "flam")
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
            expectation.fulfill()
        }
        RunLoop.current().add(timer, forMode: .defaultRunLoopMode)
        waitForExpectations(withTimeout: 1.0)
    }

// CHECK: Test Case 'ExpectationsTestCase.test_waitingForAnExpectationFulfilledAfterTheTimeout_fails' started at \d+:\d+:\d+\.\d+
// CHECK: .*/Tests/Functional/Asynchronous/Expectations/main.swift:[[@LINE+8]]: error: ExpectationsTestCase.test_waitingForAnExpectationFulfilledAfterTheTimeout_fails : Asynchronous wait failed - Exceeded timeout of 0.1 seconds, with unfulfilled expectations: hog
// CHECK: Test Case 'ExpectationsTestCase.test_waitingForAnExpectationFulfilledAfterTheTimeout_fails' failed \(\d+\.\d+ seconds\).
    func test_waitingForAnExpectationFulfilledAfterTheTimeout_fails() {
        let expectation = self.expectation(withDescription: "hog")
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            expectation.fulfill()
        }
        RunLoop.current().add(timer, forMode: .defaultRunLoopMode)
        waitForExpectations(withTimeout: 0.1)
    }

// CHECK: Test Case 'ExpectationsTestCase.test_whenTimeoutIsImmediate_andAllExpectationsAreFulfilled_passes' started at \d+:\d+:\d+\.\d+
// CHECK: Test Case 'ExpectationsTestCase.test_whenTimeoutIsImmediate_andAllExpectationsAreFulfilled_passes' passed \(\d+\.\d+ seconds\).
    func test_whenTimeoutIsImmediate_andAllExpectationsAreFulfilled_passes() {
        let expectation = self.expectation(withDescription: "smog")
        expectation.fulfill()
        waitForExpectations(withTimeout: 0.0)
    }

// CHECK: Test Case 'ExpectationsTestCase.test_whenTimeoutIsImmediate_butNotAllExpectationsAreFulfilled_fails' started at \d+:\d+:\d+\.\d+
// CHECK: .*/Tests/Functional/Asynchronous/Expectations/main.swift:[[@LINE+4]]: error: ExpectationsTestCase.test_whenTimeoutIsImmediate_butNotAllExpectationsAreFulfilled_fails : Asynchronous wait failed - Exceeded timeout of -1.0 seconds, with unfulfilled expectations: dog
// CHECK: Test Case 'ExpectationsTestCase.test_whenTimeoutIsImmediate_butNotAllExpectationsAreFulfilled_fails' failed \(\d+\.\d+ seconds\).
    func test_whenTimeoutIsImmediate_butNotAllExpectationsAreFulfilled_fails() {
        expectation(withDescription: "dog")
        waitForExpectations(withTimeout: -1.0)
    }

    static var allTests = {
        return [
            ("test_waitingForAnUnfulfilledExpectation_fails", test_waitingForAnUnfulfilledExpectation_fails),
            ("test_waitingForUnfulfilledExpectations_outputsAllExpectations_andFails", test_waitingForUnfulfilledExpectations_outputsAllExpectations_andFails),
            ("test_waitingForAnImmediatelyFulfilledExpectation_passes", test_waitingForAnImmediatelyFulfilledExpectation_passes),
            ("test_waitingForAnEventuallyFulfilledExpectation_passes", test_waitingForAnEventuallyFulfilledExpectation_passes),
            ("test_waitingForAnExpectationFulfilledAfterTheTimeout_fails", test_waitingForAnExpectationFulfilledAfterTheTimeout_fails),
            ("test_whenTimeoutIsImmediate_andAllExpectationsAreFulfilled_passes", test_whenTimeoutIsImmediate_andAllExpectationsAreFulfilled_passes),
            ("test_whenTimeoutIsImmediate_butNotAllExpectationsAreFulfilled_fails", test_whenTimeoutIsImmediate_butNotAllExpectationsAreFulfilled_fails),
        ]
    }()
}
// CHECK: Test Suite 'ExpectationsTestCase' failed at \d+:\d+:\d+\.\d+
// CHECK: \t Executed 7 tests, with 4 failures \(0 unexpected\) in \d+\.\d+ \(\d+\.\d+\) seconds

XCTMain([testCase(ExpectationsTestCase.allTests)])

// CHECK: Test Suite '.*\.xctest' failed at \d+:\d+:\d+\.\d+
// CHECK: \t Executed 7 tests, with 4 failures \(0 unexpected\) in \d+\.\d+ \(\d+\.\d+\) seconds
// CHECK: Test Suite 'All tests' failed at \d+:\d+:\d+\.\d+
// CHECK: \t Executed 7 tests, with 4 failures \(0 unexpected\) in \d+\.\d+ \(\d+\.\d+\) seconds
