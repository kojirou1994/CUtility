public struct StaticCString {

  public init(cString: UnsafePointer<CChar>) {
    self.cString = cString
  }

  public let cString: UnsafePointer<CChar>

  public var string: String {
    String(cString: cString)
  }

}
