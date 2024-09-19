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

  func testLazyCopiedCString() {
    let string = "ABCD"
    do {
      let needFreeContent = LazyCopiedCString(cString: strdup(string), freeWhenDone: true)
      XCTAssertEqual(string, needFreeContent.string)
    }

    string.withCString { cString in
      let noFreeContent = LazyCopiedCString(cString: cString, freeWhenDone: false)
      XCTAssertEqual(string, noFreeContent.string)
    }

    let forceLength = 2
    let partialString = LazyCopiedCString(cString: strdup(string), forceLength: forceLength, freeWhenDone: true)
    XCTAssertEqual(forceLength, partialString.length)
    XCTAssertTrue(string.prefix(forceLength) == partialString.string)
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

  func testCStringArray() {
    let swiftArray = [String](repeating: "ABCD", count: 20)
    let cArray = CStringArray(swiftArray)
    cArray.withUnsafeCArrayPointer { ptr in
      XCTAssertEqual(NullTerminatedArray(ptr).map { String(cString: $0.pointee) }, swiftArray)
    }
  }

}
