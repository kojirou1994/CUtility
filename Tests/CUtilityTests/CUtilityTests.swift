import XCTest
import CUtility
import CTestCode

final class CUtilityTests: XCTestCase {
  func testCBoolConversion() {
    let cFalse = 0
    XCTAssertFalse(Bool(cValue: cFalse))
    XCTAssertFalse(cFalse.cBool)

    let cTrue = 1
    XCTAssertTrue(Bool(cValue: cTrue))
    XCTAssertTrue(cTrue.cBool)
  }

  func testCStackString() {
    let stackValue = (UInt8(ascii: "A"), UInt8(ascii: "B"), UInt8(ascii: "C"), UInt8(ascii: "D"), UInt8(0))
    XCTAssertEqual(String(cStackString: stackValue), "ABCD")

    XCTAssertEqual(String(cStackString: null_terminated_stack_string()), "abc")
    XCTAssertEqual(String(cStackString: nonnull_terminated_stack_string(), isNullTerminated: false), "abcd")
  }

  func testSafeInitialize() {
    XCTAssertNoThrow(try safeInitialize({ $0 = 1 }))
    XCTAssertEqual(try! safeInitialize({ $0 = 1 }), 1)

    // built-in error
    XCTAssertThrowsError(try safeInitialize({ (v: inout Int?) in })) { error in
      XCTAssertTrue(error is UnexpectedInitializationFailure)
    }

    struct CustomError: Error {}
    // user's error
    XCTAssertThrowsError(try safeInitialize({ (v: inout Int?) in
      throw CustomError()
    })) { error in
      XCTAssertTrue(error is CustomError)
    }
  }
}
