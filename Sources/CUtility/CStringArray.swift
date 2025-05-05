#if canImport(Darwin)
import Darwin.C
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#elseif canImport(Android)
import Android
#elseif canImport(WASILibc)
import WASILibc
#endif

public final class CStringArray {

  private var cArray: [UnsafeMutablePointer<CChar>?]

  public init() {
    cArray = [nil]
  }

  deinit {
    cArray.dropLast().forEach { free($0) }
  }
}

public extension CStringArray {

  convenience init(_ strings: some Sequence<some ContiguousUTF8Bytes>) {
    self.init()
    append(contentsOf: strings)
  }

  func withUnsafeCArrayPointer<R: ~Copyable, E: Error>(_ body: (UnsafePointer<UnsafeMutablePointer<CChar>?>) throws(E) -> R) throws(E) -> R {
    try body(cArray)
  }

  func append(_ string: consuming DynamicCString) {
    cArray[cArray.count-1] = string.take()
    cArray.append(nil)
  }

  func append(contentsOf strings: some Sequence<some ContiguousUTF8Bytes>) {
    reserveCapacity(strings.underestimatedCount)
    cArray.removeLast()
    strings.forEach { string in
      cArray.append(DynamicCString.copy(bytes: string).take())
    }
    cArray.append(nil)
  }

  func reserveCapacity(_ n: Int) {
    cArray.reserveCapacity(n)
  }

}
