//
//  Atomic.swift
//  Pokemon
//
//  Created by Salome Tsiramua on 2/10/21.
//

import Foundation

@propertyWrapper
public class Atomic<T> {
    private var value: T
    private let queue = DispatchQueue(label: "atomic.queue", attributes: .concurrent)

    public var wrappedValue: T {
        get { queue.sync { value } }
        set { queue.sync { self.value = newValue } }
    }

    public init(wrappedValue value: T) {
        self.value = value
    }
}
