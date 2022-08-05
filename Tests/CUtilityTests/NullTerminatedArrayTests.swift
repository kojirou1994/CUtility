import XCTest
import CUtility

final class NullTerminatedArrayTests: XCTestCase {
  func testNullTerminatedArray() {
    XCTAssertEqual(CommandLine.arguments, NullTerminatedArray(CommandLine.unsafeArgv).map { String(cString: $0.pointee) } )
  }
}
