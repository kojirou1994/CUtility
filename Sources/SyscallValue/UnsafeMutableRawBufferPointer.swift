extension UnsafeMutableRawBufferPointer: SyscallValue {

  @inlinable
  public init<E: Error>(bytesCapacity capacity: Int, initializingBufferWith initializer: (UnsafeMutableRawBufferPointer) throws(E) -> Int) throws(E) {
    let buffer = UnsafeMutableRawBufferPointer.allocate(byteCount: capacity, alignment: MemoryLayout<UInt>.alignment)
    do {
      let realCount = try initializer(buffer)
      self = .init(rebasing: buffer.prefix(realCount))
    } catch {
      buffer.deallocate()
      throw error
    }
  }

}
