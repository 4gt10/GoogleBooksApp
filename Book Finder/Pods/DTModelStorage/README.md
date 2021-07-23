[![Build Status](https://travis-ci.org/DenTelezhkin/DTModelStorage.svg?branch=master)](https://travis-ci.org/DenTelezhkin/DTModelStorage)
[![codecov.io](http://codecov.io/github/DenTelezhkin/DTModelStorage/coverage.svg?branch=master)](http://codecov.io/github/DenTelezhkin/DTModelStorage?branch=master)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/DTModelStorage.svg)](https://cocoapods.org/pods/DTModelStorage)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Packagist](https://img.shields.io/packagist/l/doctrine/orm.svg)]()

DTModelStorage
================

> This project is used as a dependency by [DTTableViewManager](https://github.com/DenTelezhkin/DTTableViewManager) and [DTCollectionViewManager](https://github.com/DenTelezhkin/DTCollectionViewManager) - great tools for UITableView and UICollectionView management.

- [x] Support for any data structure - class, struct, enum, tuple
- [x] Support for automatic diffing in section
- [x] Protocol-oriented implementation with generic and associated types
- [x] Powerful events system for storage consumers.
- [x] High test coverage
- [x] [Complete documentation](https://dentelezhkin.github.io/DTModelStorage/)

What this is all about?
==============

The goal of the project is to provide storage classes for datasource based controls. Let's take UITableView, for example. It's datasource methods mostly relates on following:

* sections
* items in sections
* section headers and footers

Now, if we look on `UICollectionView`, that stuff does not change. And probably any kind of datasource based control can be adapted to use the same terminology. So, instead of reinventing the wheel every time, let's try to implement universal storage classes, that would fit any control.

`DTModelStorage` supports 4 storage classes:
* Single section storage
* Memory storage
* CoreData storage
* Realm storage

Internal structure of these will be different, but we need a common interface and pattern to interact with them. This pattern is actually very simple, and contains two simple steps.

1. Update storage
2. Notify delegate about changes in storage

Memory storage classes will provide convenience methods to update storage, CoreData storage classes will rely on updates from `NSFetchedResultsControllerDelegate` protocol. So the first step will be different, but the second step stays the same. And delegate for storage classes will receive the same message, and it will not actually care, which storage is used. They will look the same from its point of view.

`DTModelStorage` provides convenience methods to be used with `UITableView` or `UICollectionView`, but does not force any specific use, and does not imply, which UI components are compatible with it. However, storage classes are designed to work with "sections" and "items", which generally means some kind of table or collection of items.

SingleSectionStorage
================

While sometimes you need such fine-grained control, that `MemoryStorage` provides, the most often use case for this library is just showing a collection of items, for example array of posts from social network, or search results with a single entity.

In this case, mostly used methods from `MemoryStorage` are `setItems` and `addItems`, because in this case you probably don't need any other methods. What you may want, however, is an ability to automatically calculate diffs between old and new state to be able to animate UI without the need to call `reloadData`. That's where `SingleSectionStorage` comes in.

But before showing any usage examples, let's talk about diffing a little bit. There are a lot of great collection differs outhere, and `DTModelStorage` is not aimed to providing another one. Instead, it provides an API to work with currently available differs.

#### Algorithms

There are a lot of community-built algorithms to compute diff between two collections, for example here's list of frameworks that are built using Paul Heckel's `A Technique for Isolating Differences Between Files`:

- [HeckelDiff](https://github.com/mcudich/HeckelDiff)
- [ListDiff](https://github.com/lxcid/ListDiff) - port of [IGListKit's diffing algorithm](https://github.com/Instagram/IGListKit) to Swift
- [PHDiff](https://github.com/andre-alves/PHDiff)

There are other algorithms and implementations available, for example:

- [Dwifft](https://github.com/jflinter/Dwifft) - Longest common subsequence algorithm
- [Differ](https://github.com/tonyarnold/Differ) - Longest common subsequence algorithm
- [Changeset](https://github.com/osteslag/Changeset) - Wagner-Fischer algorithm (specific implementation of Levenstein algorithm).

Because algorithms are built differently, but have some common traits, `SingleSectionStorage` implements two concrete subclasses, that work with algorithms with `Equatable` elements and algorithms that work with `Hashable` elements - `SingleSectionEquatableStorage` and `SingleSectionHashableStorage`.

#### Algorithm adapter

To work with specific algorithm, you would need to create a thin adapter, that converts results of algorithm work to models, compatible with `DTModelStorage`. Here are some examples of how this can be done:

- [Adapter for Dwifft](https://github.com/DenTelezhkin/DTModelStorage/blob/master/Tests/Specs/SingleSectionStorageTestCase.swift#L18-L30)
- [Adapter for HeckelDiff](https://github.com/DenTelezhkin/DTModelStorage/blob/master/Tests/Specs/SingleSectionStorageTestCase.swift#L32-L48)
- [Adapter for Changeset](https://github.com/DenTelezhkin/DTTableViewManager/blob/master/Example/Example%20controllers/AutoDiffSearchViewController.swift#L14-L26)

#### Example

After adapter has been built, you need to implement `Identifiable` protocol on your data models to provide way to identify models:

```swift
extension Post : Identifiable {
    public var identifier: AnyHashable { return id }
}
```

Create storage:

```swift
let storage = SingleSectionEquatableStorage(items: arrayOfPosts, differ: ChangesetDiffer())
```

Set new array of items and automatically calculate all diffs:

```swift
storage.setItems(newPosts)
```

Full example of automatically animating items in `UITableView` can be seen in [DTTableViewManager repo](https://github.com/DenTelezhkin/DTTableViewManager/blob/master/Example/Example%20controllers/AutoDiffSearchViewController.swift)

#### Adding items

When you show list of items, common task is to add new loaded items to this list (for example load more content). Doing that is really simple:

```swift
storage.addItems(newItems)
```

Sometimes you may want to customize how items are accumulated in resulting collection of items. For example when content changed in time between first page request and second page request in load-more scenario. If back-end does not handle this for iOS side, you may want to build handling of such cases on client side. To do that, `DTModelStorage` provides  `AccumulationStrategy` protocol, that consists of single method:

```swift
protocol AccumulationStrategy {
    func accumulate<T:Identifiable>(oldItems: [T], newItems: [T]) -> [T]
}
```

This strategy determines how new collection of items will be formed. `DTModelStorage` provides three concrete implementations of this protocol:

- `AdditiveAccumulationStrategy` - default strategy, that simply adds oldItems to newItemsArray.
- `UpdateOldValuesAccumulationStrategy` - replaces old values with new values from `newItems` array - uniqueness is determined by `Identifiable` `identifier` property
- `DeleteOldValuesAccumulationStrategy` - deletes old items, new values remain in new location as returned by `newArray` - uniqueness is determined by `Identifiable` `identifier` property.

To use any of the strategies, just call `addItems` method with additional parameter:

```swift
storage.addItems(newItems, UpdateOldValuesAccumulationStrategy())
```

#### Several model types in SingleSectionStorage

`SingleSectionStorage` class uses generics to determine it's item type. While it provides compile-time guarantees for item type, it unfortunately prevents using several model types in `SingleSectionStorage` using `Any` type or a protocol. To do that, Swift needs to implement feature called [Generalized existentials](https://github.com/apple/swift/blob/master/docs/GenericsManifesto.md#existentials). Unfortunately, at the moment of writing (Xcode 10, Swift 4.2) this feature is not implemented.

Therefore, to support several data models type in `SingleSection` we can use technique called type-erasing. We can build generic wrapper class, that implements all protocols that are required, but actually accepts `Any` value:

```swift
struct AnyIdentifiableEquatable: Identifiable, Equatable {
    let value : Any
    let equals: (Any) -> Bool
    let identifier: AnyHashable

    init<T:Identifiable & Equatable>(_ value: T) {
        self.value = value
        equals = {
            guard let instance = $0 as? T else { return false }
            return instance == value
        }
        identifier = value.identifier
    }

    static func == (lhs: AnyIdentifiableEquatable, rhs: AnyIdentifiableEquatable) -> Bool {
        return lhs.equals(rhs.value) || rhs.equals(lhs.value)
    }
}
```

This way you can create a storage, that accepts any number of data models:

```swift
let typeErasedInstances = [AnyIdentifiableEquatable(Foo()), AnyIdentifiableEquatable(Bar())]
let storage = SingleSectionEquatableStorage(items: typeErasedInstances, differ: DwifftDiffer())
```

Quite ugly, I know. But that seems like the only option that is possible today.

#### Supplementary models for SingleSection

`SingleSectionStorage` has support for supplementaries to support `UICollectionView` supplementary views, as well as `UITableView` headers and footers. The only difference from `MemoryStorage` is that `SingleSectionStorage` contains, you guessed it, only one section, and therefore one set of supplementaries.

MemoryStorage
================
`MemoryStorage` encapsulates storage of data models in memory. It's basically Array of `SectionModel` items, which contain array of items for current section, and supplementary models of any kind, that add additional information for section. Good example would be UITableView headers and footers, or UICollectionView with UICollectionViewFlowLayout.

```swift
let storage = MemoryStorage()
```

#### Adding items

```swift
storage.addItem(model)
storage.addItem(model, toSection: 0)

storage.addItems([model1,model2])
storage.addItems([model1,model2], toSection:0)

try? storage.insertItem(model, to: indexPath)
```

#### Remove / replace / Reload

```swift
try? storage.removeItem(model)
storage.removeItems([model1,model2])
storage.removeItems(at:indexPaths)

try? storage.replaceItem(model1, with: model2)

storage.reloadItem(model1)
```

#### Managing sections

```swift
storage.deleteSections(NSIndexSet(index: 1))
```

#### Retrieving items

```swift
let item = storage.item(at:NSIndexPath(forItem:1, inSection:0)

let indexPath = storage.indexPath(forItem:model)

let itemsInSection = storage.items(inSection:0)

let section = storage.section(atIndex:0)
```

#### Updating manually

Sometimes you may need to update batch of sections, remove all items, and add new ones. For those massive updates you don't actually need to update interface until update is finished. Wrap your updates in single block and pass it to updateWithoutAnimations method:

```swift
storage.updateWithoutAnimations {
	// Add multiple rows, or another batch of edits
}
// Calling reloadData is mandatory after calling this method. or you will get crash runtime
```

For reordering of items, when animation is not needed, you can call `moveItemWithoutAnimation(from:to:)` method:

```swift
storage.moveItemWithoutAnimation(from: sourceIndexPath, to: destinationIndexPath)
```

#### Supplementary models

```swift
let section = storage.section(atIndex:0)
section.setSupplementaryModel("foo", forKind: UICollectionElementKindSectionHeader)
let model = section.supplementaryModelOfKind(UICollectionElementKindSectionHeader)
```

#### Transferring model

`DTModelStorage` defines `ModelTransfer` protocol, that allows transferring your data model to interested parties. This can be used for example for updating `UITableViewCell`. Thanks to associated `ModelType` of the protocol it is possible to transfer your model without any type casts.

CoreDataStorage
================

`CoreDataStorage` is meant to be used with `NSFetchedResultsController`. It automatically monitors all `NSFetchedResultsControllerDelegate` methods and and calls delegate with appropriate updates.

```swift
let storage = CoreDataStorage(fetchedResultsController: controller)
```

Any section in `CoreDataStorage` conform to `NSFetchedResultsSectionInfo` protocol, however `DTModelStorage` extends them to be `Section` protocol compatible. This way CoreData sections and memory sections have the same interface.

For perfomance reasons, you should not retrieve items via `items` property, if you don't need to. Items may not be fetched from CoreData database, and if you need to retrieve only one specific item, it's better to call -`item(at:)` method instead. This way only one item will be actually fetched from database.

## RealmStorage

`RealmStorage` class is made to work with [realm.io](https://realm.io) databases. It works with sections, that contain Realm.Results object.

Creating storage and filling it with results is very easy:

```
let results = try! Realm().objects(Dog)

let storage = RealmStorage()
storage.addSection(with:results)
```

That's it! Results are automatically monitored, and refreshed, if Realm objects change.

Installation
===========

[CocoaPods](https://cocoapods.org):

    pod 'DTModelStorage', '~> 7.1'

[Carthage](https://github.com/Carthage/Carthage)

    github "DenTelezhkin/DTModelStorage" ~> 7.1

Requirements
============

* Xcode 10 and higher
* Swift 4.1 and higher
* iOS 8 and higher / tvOS 9.0 and higher

Objective-C
============

Due to generic implementation of DTModelStorage currently there are no plans to support Objective-C. If you want to use `DTModelStorage` in Objective-C project, you can use [latest compatible release](https://github.com/DenTelezhkin/DTModelStorage/releases/tag/1.3.1) of the framework, that was previously written in Objective-C.
