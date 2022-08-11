#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#endif

public final class CStringArray {

  private var cArray: [UnsafeMutablePointer<CChar>?]

  public init() {
    cArray = [nil]
  }

  deinit {
    cArray.dropFirst().forEach { free($0) }
  }
}

public extension CStringArray {

  convenience init<T>(_ strings: T) where T: Sequence, T.Element: StringProtocol {
    self.init()
    append(contentsOf: strings)
  }

  func withUnsafeCArrayPointer<R>(_ body: (UnsafePointer<UnsafeMutablePointer<CChar>?>) throws -> R) rethrows -> R {
    try body(cArray)
  }

  func append(owned ptr: UnsafeMutablePointer<CChar>) {
    cArray[cArray.count-1] = ptr
    cArray.append(nil)
  }

  func append<T: StringProtocol>(_ string: T) {
    string.withCString { string in
      append(owned: strdup(string)!)
    }
  }

  func append<T>(contentsOf strings: T) where T: Sequence, T.Element: StringProtocol {
    cArray.removeLast()
    strings.forEach { string in
      string.withCString { string in
        cArray.append(strdup(string)!)
      }
    }
    cArray.append(nil)
  }

  func reserveCapacity(_ n: Int) {
    cArray.reserveCapacity(n)
  }

}
