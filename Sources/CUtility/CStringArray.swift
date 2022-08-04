#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#endif

public final class CStringArray {

  public private(set) var cArray: [UnsafeMutablePointer<CChar>?]

  public init() {
    cArray = [nil]
  }

  deinit {
    cArray.dropFirst().forEach { free($0) }
  }
}

public extension CStringArray {

  func append(owned ptr: UnsafeMutablePointer<CChar>) {
    cArray[cArray.count-1] = ptr
    cArray.append(nil)
  }

  func append<T: StringProtocol>(_ string: T) {
    string.withCString { string in
      append(owned: strdup(string)!)
    }
  }

  func reserveCapacity(_ n: Int) {
    cArray.reserveCapacity(n)
  }

}
