public protocol ContiguousUTF8Bytes: ~Copyable, ~Escapable {
  /// Invokes the given closure with a buffer containing the UTF-8 code unit sequence (excluding the null terminator).
  func withContiguousUTF8Bytes<R: ~Copyable, E: Error>(_ body: (UnsafeRawBufferPointer) throws(E) -> R) throws(E) -> R
}

extension StaticString: ContiguousUTF8Bytes {
  
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withContiguousUTF8Bytes<R, E>(_ body: (UnsafeRawBufferPointer) throws(E) -> R) throws(E) -> R where E : Error, R : ~Copyable {
    try safeInitialize { (result: inout Result<R, E>?) in
      withUTF8Buffer { buf in
        result = .init { () throws(E) -> R in
          try body(.init(buf))
        }
      }
    }.get()
  }
}

extension String: ContiguousUTF8Bytes {
  @_alwaysEmitIntoClient
  @inlinable
  public func withContiguousUTF8Bytes<R, E>(_ body: (UnsafeRawBufferPointer) throws(E) -> R) throws(E) -> R where E : Error, R : ~Copyable {
    try utf8.withContiguousUTF8Bytes(body)
  }
}

extension Substring: ContiguousUTF8Bytes {
  @_alwaysEmitIntoClient
  @inlinable
  public func withContiguousUTF8Bytes<R, E>(_ body: (UnsafeRawBufferPointer) throws(E) -> R) throws(E) -> R where E : Error, R : ~Copyable {
    try utf8.withContiguousUTF8Bytes(body)
  }
}

extension ContiguousUTF8Bytes where Self: Sequence<UInt8> {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withContiguousUTF8Bytes<R, E>(_ body: (UnsafeRawBufferPointer) throws(E) -> R) throws(E) -> R where E : Error, R : ~Copyable {
    var v: R!
    try toTypedThrows(E.self) {
      let result: ()? = try withContiguousStorageIfAvailable { buf in
        v = try body(.init(buf))
      }
      if result == nil {
        // no storage
        assertionFailure("please provide storage, will copy all bytes in release mode!")
        try ContiguousArray(self).withUnsafeBytes { buf in
          v = try body(buf)
        }
      }
    }
    return v
  }
}

extension ContiguousUTF8Bytes where Self: CString {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withContiguousUTF8Bytes<R, E>(_ body: (UnsafeRawBufferPointer) throws(E) -> R) throws(E) -> R where E : Error, R : ~Copyable {
    try withUnsafeCString { cString throws(E) in
      try body(.init(start: cString, count: UTF8._nullCodeUnitOffset(in: cString)))
    }
  }
}

extension UnsafeRawBufferPointer: ContiguousUTF8Bytes {}
extension UnsafeMutableRawBufferPointer: ContiguousUTF8Bytes {}
extension UnsafeBufferPointer: ContiguousUTF8Bytes where Element == UInt8 {}
extension UnsafeMutableBufferPointer: ContiguousUTF8Bytes where Element == UInt8 {}

extension Array: ContiguousUTF8Bytes where Element == UInt8 {}
extension ArraySlice: ContiguousUTF8Bytes where Element == UInt8 {}
extension CollectionOfOne: ContiguousUTF8Bytes where Element == UInt8 {}
extension ContiguousArray: ContiguousUTF8Bytes where Element == UInt8 {}
extension Slice: ContiguousUTF8Bytes where Element == UInt8 {}
extension String.UTF8View: ContiguousUTF8Bytes {}
extension Substring.UTF8View: ContiguousUTF8Bytes {}

extension EmptyCollection: ContiguousUTF8Bytes where Element == UInt8 {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withContiguousUTF8Bytes<R, E>(_ body: (UnsafeRawBufferPointer) throws(E) -> R) throws(E) -> R where E : Error, R : ~Copyable {
    try body(.init(start: nil, count: 0))
  }
}

//extension RawSpan: ContiguousUTF8Bytes {
//  @_alwaysEmitIntoClient
//  @inlinable @inline(__always)
//  public func withContiguousUTF8Bytes<R, E>(_ body: (UnsafeRawBufferPointer) throws(E) -> R) throws(E) -> R where E : Error, R : ~Copyable {
//    try withUnsafeBytes(body)
//  }
//}
