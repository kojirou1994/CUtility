import Foundation

extension Data: SyscallValue {

  @inlinable
  public init<E: Error>(bytesCapacity capacity: Int, initializingBufferWith initializer: (UnsafeMutableRawBufferPointer) throws(E) -> Int) throws(E) {
    let buffer = UnsafeMutableRawBufferPointer.allocate(byteCount: capacity, alignment: MemoryLayout<UInt>.alignment)
    do {
      let realCount = try initializer(buffer)
      self.init(bytesNoCopy: buffer.baseAddress.unsafelyUnwrapped, count: realCount, deallocator: .free)
    } catch {
      buffer.deallocate()
      throw error
    }
  }

}
