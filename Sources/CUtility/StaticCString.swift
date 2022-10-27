public struct StaticCString {

  @_alwaysEmitIntoClient
  public init(cString: UnsafePointer<CChar>) {
    self.cString = cString
  }

  public let cString: UnsafePointer<CChar>

  @_alwaysEmitIntoClient
  public var string: String {
    String(cString: cString)
  }

}
