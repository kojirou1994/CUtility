public final class LazyCopiedCString {

  public init(cString: UnsafePointer<CChar>, forceLength: Int? = nil, freeWhenDone: Bool) {
    self.cString = cString
    self.forceLength = forceLength
    self.freeWhenDone = freeWhenDone
  }

  public let cString: UnsafePointer<CChar>
  private let forceLength: Int?
  private let freeWhenDone: Bool

  /// lazy and cached length
  public internal(set) lazy var length: Int = {
    forceLength ?? UTF8._nullCodeUnitOffset(in: cString)
  }()

  /// lazy-copied native string
  public internal(set) lazy var string = {
    String(decoding: UnsafeRawBufferPointer(start: cString, count: length), as: UTF8.self)
  }()

  deinit {
    if freeWhenDone {
      cString.deallocate()
    }
  }
}
