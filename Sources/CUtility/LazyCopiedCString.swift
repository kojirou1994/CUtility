@available(*, deprecated, message: "use DynamicCStringWithLength")
public final class LazyCopiedCString {

  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public init(cString: UnsafePointer<CChar>, forceLength: Int? = nil, freeWhenDone: Bool) {
    self.cString = cString
    self.forceLength = forceLength
    self.freeWhenDone = freeWhenDone
  }

  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public convenience init(_ cString: StaticCString) {
    self.init(cString: cString.cString, freeWhenDone: false)
  }

  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public convenience init(_ cString: consuming DynamicCString) {
    self.init(cString: cString.take(), freeWhenDone: true)
  }

  public let cString: UnsafePointer<CChar>
  @usableFromInline
  internal let forceLength: Int?
  @usableFromInline
  internal let freeWhenDone: Bool

  /// lazy and cached length
  public private(set) lazy var length: Int = {
    forceLength ?? UTF8._nullCodeUnitOffset(in: cString)
  }()

  /// lazy-copied native string
  public private(set) lazy var string = {
    String(decoding: UnsafeRawBufferPointer(start: cString, count: length), as: UTF8.self)
  }()

  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  deinit {
    if freeWhenDone {
      cString.deallocate()
    }
  }
}
