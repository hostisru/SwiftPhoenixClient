//
//  Atomic.swift
//  SwiftPhoenixClient
//
//  Created by deni on 25/05/2022.
//  Copyright © 2022 SwiftPhoenixClient. All rights reserved.
//

import Foundation

@propertyWrapper
class Atomic<Value> {

	private let queue = DispatchQueue(label: "Atomic \(UUID().uuidString)")
	private var value: Value

	init(wrappedValue: Value) {
		self.value = wrappedValue
	}

	var wrappedValue: Value {
		get {
			return queue.sync { value }
		}
		set {
			queue.sync { value = newValue }
		}
	}

	var projectedValue: Atomic<Value> {
		return self
	}

	func mutate(_ mutation: (inout Value) -> Void) {
		return queue.sync {
			mutation(&value)
		}
	}
}
