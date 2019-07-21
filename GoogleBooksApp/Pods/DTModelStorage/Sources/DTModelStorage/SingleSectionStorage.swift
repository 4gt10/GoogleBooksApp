//
//  SingleSectionStorage.swift
//  DTModelStorage
//
//  Created by Denys Telezhkin on 13.09.2018.
//  Copyright © 2018 Denys Telezhkin. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

/// `SingleSectionStorage` that requires all it's elements to be `Equatable`.
open class SingleSectionEquatableStorage<T:Identifiable & Equatable> : SingleSectionStorage<T> {
    
    /// Diffing algorithm that requires all it's elements to be `Equatable`.
    public let differ: EquatableDiffingAlgorithm
    
    /// Creates storage with `items` and concrete implementation of `EquatableDiffingAlgorithm` - `differ`.
    ///
    /// - Parameters:
    ///   - items: starting items in storage
    ///   - differ: concrete diffing implementation
    public init(items: [T], differ: EquatableDiffingAlgorithm) {
        self.differ = differ
        super.init(items: items)
    }
    
    /// Calculate diffs between `items` and `newItems`.
    ///
    /// - Parameter newItems: new items collection
    /// - Returns: Array of changes between `items` and `newItems`.
    open override func calculateDiffs(to newItems: [T]) -> [SingleSectionOperation] {
        return differ.diff(from: items, to: newItems)
    }
}

/// `SingleSectionStorage` that requires all it's elements to be `Hashable`.
open class SingleSectionHashableStorage<T:Identifiable & Hashable> : SingleSectionStorage<T> {
    
    /// Diffing algorithm that requires all it's elements to be `Hashable`.
    public let differ: HashableDiffingAlgorithm
    
    /// Creates storage with `items` and concrete implementation of `HashableDiffingAlgorithm` - `differ`.
    ///
    /// - Parameters:
    ///   - items: starting items in storage
    ///   - differ: concrete diffing implementation
    public init(items: [T], differ: HashableDiffingAlgorithm) {
        self.differ = differ
        super.init(items: items)
    }
    
    /// Calculate diffs between `items` and `newItems`.
    ///
    /// - Parameter newItems: new items collection
    /// - Returns: Array of changes between `items` and `newItems`.
    open override func calculateDiffs(to newItems: [T]) -> [SingleSectionOperation] {
        return differ.diff(from: items, to: newItems)
    }
}

/// Abstract base class that represents a single section of items. Supports supplementary items to allow representing supplementary views in section.
/// - SeeAlso: `SingleSectionHashableStorage`
/// - SeeAlso: `SingleSectionEquatableStorage`
open class SingleSectionStorage<T: Identifiable> : BaseStorage, Storage, SupplementaryStorage, HeaderFooterSettable {
    
    /// Array of items, that section contains.
    open var items : [T] { return section.items(ofType: T.self) }
    
    /// Internal representation of a single section
    private var section : SectionModel
    
    /// Creates storage with array of items. Do not call this method directly. Instead use concrete subclasses of `SingleSectionStorage`, such as `SingleSectionEquatableStorage`.
    ///
    /// - Parameter items: array of starting items in section.
    public init(items: [T]) {
        let sectionModel = SectionModel()
        sectionModel.setItems(items)
        section = sectionModel
    }
    
    // Storage
    
    /// Retrieve item at given `indexPath`.
    ///
    /// - Parameter indexPath: indexPath of item in storage
    /// - Returns: item at specified indexPath, or nil if indexPath is out of bounds.
    public func item(at indexPath: IndexPath) -> Any? {
        guard indexPath.section == 0 else { return nil }
        guard indexPath.item < section.items.count else { return nil }
        return section.items[indexPath.item]
    }
    
    /// Array of sections in storage. This method will always return array with single section. Attempting to set any amount of sections different from one, or a section that is not `SectionModel` does nothing.
    public var sections: [Section] {
        get {
            return [section]
        }
        set {
            if newValue.count > 1 {
                print("Attempt to set more than 1 section to SingleSectionStorage. If you need more than 1 section, consider using MemoryStorage.")
            } else if let compatibleSection = newValue.first as? SectionModel {
                section = compatibleSection
            } else {
                print("Attempt to set empty or incompatible section to SingleSectionStorage. Please use SectionModel object for SingleSectionStorage section.")
            }
        }
    }
    
    // SupplementaryStorage
    
    /// Retrieve supplementary model of `kind` for section at `indexPath`.
    ///
    /// - Parameters:
    ///   - kind: supplementary kind
    ///   - indexPath: indexPath for determining supplementary location
    /// - Returns: supplementary model, or nil if indexPath is out of bounds, or section is different from 0.
    public func supplementaryModel(ofKind kind: String, forSectionAt indexPath: IndexPath) -> Any? {
        guard indexPath.section == 0 else { return nil }
        return section.supplementaryModel(ofKind: kind, atIndex: indexPath.item)
    }
    
    /// Set supplementaries for specific `kind`. Attempting to set any amount of models that is more than 1 does nothing.
    ///
    /// - Parameters:
    ///   - models: array of models. Must consist of zero or one element, otherwise is ignored.
    ///   - kind: supplementary kind
    public func setSupplementaries(_ models: [[Int : Any]], forKind kind: String) {
        guard models.count <= 1 else {
            print("Attempt to set more than 1 section of supplementaries to SingleSectionStorage.")
            return
        }
        if models.count == 0 {
            section.supplementaries[kind] = nil
        } else {
            section.supplementaries[kind] = models[0]
        }
    }
    
    // Diffing and updates
    
    /// Abstract method to calculate diffs. Do not use this method directly. Instead, use subclassed method, for example `SingleSectionEquatableStorage.calculateDiffs(to:)`.
    /// - SeeAlso: `setItems`
    /// - SeeAlso: `addItems`
    ///
    /// - Parameter newItems: new array, to which diffs are calculated
    /// - Returns: Array of changes between `items` and `newItems`.
    open func calculateDiffs(to newItems: [T]) -> [SingleSectionOperation] {
        fatalError("This method needs to be overridden in subclasses")
    }
    
    /// Replaces `items` with `newItems`, collecting changes along the way. Changes are calculated using `calculateDiffs(to:)` method and delivered to `StorageUpdating` delegate, which can animate changes in resulting UI(for example UITableView or UICollectionView).
    ///
    /// - Parameter newItems: new array of items
    public func setItems(_ newItems: [T]) {
        let diffs = calculateDiffs(to: newItems)
        collectChanges(diffs, to: newItems)
    }

    /// Adds `newItems` on top of `items`, using specified accumulation strategy.
    ///
    /// - Parameters:
    ///   - newItems: new items array
    ///   - strategy: strategy to use when accumulating items. Defaults to AdditiveAccumulationStrategy.
    public func addItems(_ newItems: [T], _ strategy: AccumulationStrategy = AdditiveAccumulationStrategy()) {
        let accumulatedItems = strategy.accumulate(oldItems: items, newItems: newItems)
        let diffs = calculateDiffs(to: accumulatedItems)
        collectChanges(diffs, to: accumulatedItems)
    }
    
    /// Convert `changes` to `StorageUpdate` and deliver it to `StorageUpdating` delegate.
    ///
    /// - Parameters:
    ///   - changes: changes to collect
    ///   - new: new collection of items
    func collectChanges(_ changes: [SingleSectionOperation], to new: [T]) {
        let update = StorageUpdate()
        update.enqueueDatasourceUpdate { [weak self] _ in
            self?.section.setItems(new)
        }
        for diff in changes {
            switch diff {
            case .delete(let item):
                update.objectChanges.append((.delete, [IndexPath(item: item, section: 0)]))
            case .insert(let item):
                update.objectChanges.append((.insert, [IndexPath(item: item, section: 0)]))
            case .update(let item):
                update.objectChanges.append((.update, [IndexPath(item: item, section: 0)]))
            case .move(let from, let to):
                update.objectChanges.append((.move, [IndexPath(item: from, section: 0), IndexPath(item: to, section: 0)]))
            }
        }
        delegate?.storageDidPerformUpdate(update)
    }
}
