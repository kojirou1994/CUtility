import XCTest
import SyscallValue

final class SyscallValueTests: XCTestCase {
  func testString() {
    let string = "ABCDEFG👌"
    string.withCString { cstr in
      let length = strlen(cstr)
      for capicity in [length, length+1] {
        let copied = String(bytesCapacity: capicity) { buffer in
          buffer.copyMemory(from: .init(start: cstr, count: capicity))
          return capicity
        }

        XCTAssertEqual(string, copied)
      }
    }
  }

  func testArray() {
    struct Item: Equatable {
      let x, y: Int
    }

    let data = Array(1...100)
    let arr = [Item](bytesCapacity: MemoryLayout<Int>.stride * data.count) { buf in
      data.withUnsafeBytes { buf.copyMemory(from: $0); return $0.count }
    }
    XCTAssertEqual(arr.count, data.count / 2)
    XCTAssertEqual(arr.first, .init(x: 1, y: 2))
    XCTAssertEqual(arr.last, .init(x: 99, y: 100))

    struct NotAlignedItem: Equatable {
      let x: Int
      let y: Bool
      let z: Int
    }

    let data2 = (1...10).map { ($0, Bool.random(), $0+1) }
    let arr2 = [NotAlignedItem](bytesCapacity: MemoryLayout<(Int, Bool, Int)>.stride * data2.count) { buf in
      data2.withUnsafeBytes { buf.copyMemory(from: $0); return $0.count }
    }
    XCTAssertEqual(arr2.count, data2.count)
    for (v1, v2) in zip(data2, arr2) {
      XCTAssertEqual(v1.0, v2.x)
      XCTAssertEqual(v1.1, v2.y)
      XCTAssertEqual(v1.2, v2.z)
    }
  }
}
