//
//  EmptyStateHandler.swift
//

import DZNEmptyDataSet

open class EmptyStateHandler: NSObject {
    
    private let image: UIImage?
    private let title: String
    private let descriptionText: String?
    
    // MARK: - Appearance
    
    public struct Appearance {
        
        public struct Text {
            
            public let font: UIFont
            public let color: UIColor
            
            // MARK: - Init
            
            public init(
                font: UIFont,
                color: UIColor) {
                self.font = font
                self.color = color
            }
        }
        
        public let title: Text
        public let description: Text
        
        public static var defaultAppearance: Appearance {
            return Appearance(
                title: Text(
                    font: UIFont.systemFont(ofSize: 20, weight: .medium),
                    color: .gray
                ),
                description: Text(
                    font: UIFont.systemFont(ofSize: 17),
                    color: .lightGray
                )
            )
        }
        
        // MARK: - Init
        
        public init(
            title: Text,
            description: Text) {
            self.title = title
            self.description = description
        }
    }
    
    open var appearance: Appearance {
        return Appearance.defaultAppearance
    }
    
    // MARK: - Init
    
    public init(
        image: UIImage? = nil,
        title: String,
        descriptionText: String? = nil) {
        self.image = image
        self.title = title
        self.descriptionText = descriptionText
    }
    
    // MARK: - Interface
    
    public func configure(withScrollableView view: UIScrollView) {
        view.emptyDataSetSource = self
        view.emptyDataSetDelegate = self
    }
}

extension EmptyStateHandler: DZNEmptyDataSetSource {
    
    public func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return image
    }
    
    public func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(
            string: title,
            attributes: [
                NSAttributedString.Key.font: appearance.title.font,
                NSAttributedString.Key.foregroundColor: appearance.title.color
            ]
        )
    }
    
    public func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        guard let descriptionText = descriptionText else { return nil }
        return NSAttributedString(
            string: descriptionText,
            attributes: [
                NSAttributedString.Key.font: appearance.description.font,
                NSAttributedString.Key.foregroundColor: appearance.description.color
            ]
        )
    }
}

extension EmptyStateHandler: DZNEmptyDataSetDelegate {
    
    public func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
