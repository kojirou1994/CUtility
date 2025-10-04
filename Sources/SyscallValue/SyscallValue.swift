public protocol SyscallValue {
  /// create SyscallValue
  /// - Parameters:
  ///   - capacity: capacity to pre-allocate buffer
  ///   - initializer: closure to fill the buffer, returns initialized bytes count
  init<E: Error>(bytesCapacity capacity: Int, initializingBufferWith initializer: (UnsafeMutableRawBufferPointer) throws(E) -> Int) throws(E)
}
