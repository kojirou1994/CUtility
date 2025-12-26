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
    XCTAssertNoThrow(safeInitialize({ $0 = 1 }))
    XCTAssertEqual(safeInitialize({ $0 = 1 }), 1)

    struct CustomError: Error {}
    // user's error
    XCTAssertThrowsError(try safeInitialize({ (v: inout Int?) in
      throw CustomError()
    })) { error in
      XCTAssertTrue(error is CustomError)
    }
  }

  func testCStackArray() {
    let stackString = nonnull_terminated_stack_string()
    XCTAssertEqual(CStackArray4(value: stackString.string)[1], Int8(UInt8(ascii: "b")))
    for index in 0...3 {
      XCTAssertEqual(stack_string_char_at(stackString, numericCast(index)),
                     CStackArray4(value: stackString.string)[index])
    }
  }

  struct CMacroOptions: OptionSet, MacroRawRepresentable {
    let rawValue: UInt32 /* different integer type */
    static var high: Self {
      .init(macroValue: C_MACRO_OPTION_HIGH)
    }
  }

  func testCMacroCast() {
    XCTAssertTrue(CMacroOptions(rawValue: 1 << 31).contains(.high))
//    let missCasted = CMacroOptions(rawValue: numericCast(C_MACRO_HIGH))
  }

  func testContiguousStorageSegments() {
    let count = 1024

    // check all elements used
    let repeatValue = 110
    let noStorage = repeatElement(repeatValue, count: count)
    var usedElements = 0
    noStorage.withContiguousStorageSegments(capacity: 10) { buffer in
      usedElements += buffer.count
      XCTAssertTrue(buffer.allSatisfy { $0 == repeatValue } )
    }
    XCTAssertEqual(count, usedElements)

    // check elements value
    var rg = SystemRandomNumberGenerator()
    let randomData = (1...count).map { _ in Int(bitPattern: rg.next()) }
    XCTAssertEqual(count, randomData.count)
    var copiedElements = [Int]()
    randomData.withContiguousStorageSegments(capacity: 10) { buffer in
      copiedElements.append(contentsOf: buffer)
    }
    XCTAssertEqual(randomData, copiedElements)
  }

}
