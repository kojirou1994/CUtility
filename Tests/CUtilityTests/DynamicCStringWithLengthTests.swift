import XCTest
import CUtility

final class DynamicCStringWithLengthTests: XCTestCase {
  func testLengthUpdating() {
    var string = DynamicCStringWithLength(cString: .copy(cString: "ABCD"))
    XCTAssert(string.length == 4)

    string.withMutableCString { ptr in
      ptr[4] = .init(UInt8(ascii: "E"))
      ptr[5] = 0
    }
    XCTAssert(string.length == 5)
  }
}

