public final class LazyCopiedCString {

  @inlinable
  public init(cString: UnsafePointer<CChar>, forceLength: Int? = nil, freeWhenDone: Bool) {
    self.cString = cString
    self.forceLength = forceLength
    self.freeWhenDone = freeWhenDone
  }

  @inlinable
  public convenience init(_ cString: StaticCString) {
    self.init(cString: cString.cString, freeWhenDone: false)
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

  @inlinable
  deinit {
    if freeWhenDone {
      cString.deallocate()
    }
  }
}
