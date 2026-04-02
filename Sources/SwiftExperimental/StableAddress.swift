// https://github.com/swiftlang/swift/blob/main/stdlib/public/Synchronization/Cell.swift
//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Atomics open source project
//
// Copyright (c) 2024 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import Builtin

@frozen
@_rawLayout(like: Value, movesAsLike)
public struct StableAddress<Value: ~Copyable>: ~Copyable {
  @_alwaysEmitIntoClient
  @_transparent
  public var _address: UnsafeMutablePointer<Value> {
    unsafe UnsafeMutablePointer<Value>(_rawAddress)
  }

  @_alwaysEmitIntoClient
  @_transparent
  internal var _rawAddress: Builtin.RawPointer {
    Builtin.addressOfRawLayout(self)
  }

  @_alwaysEmitIntoClient
  @_transparent
  public init(_ initialValue: consuming Value) {
    unsafe _address.initialize(to: initialValue)
  }

  @_alwaysEmitIntoClient
  @inlinable
  deinit {
    unsafe _address.deinitialize(count: 1)
  }
}
