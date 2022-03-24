public final class LazyCString {

  public init(cString: UnsafePointer<CChar>, freeWhenDone: Bool) {
    self.cString = cString
    self.freeWhenDone = freeWhenDone
  }

  public let cString: UnsafePointer<CChar>
  private let freeWhenDone: Bool

  /// lazy-copied native string
  public internal(set) lazy var string = {
    String(cString: cString)
  }()

  deinit {
    if freeWhenDone {
      cString.deallocate()
    }
  }
}
