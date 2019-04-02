//
//  ReusableViewProtocol.swift
//  FlowKit2
//
//  Created by dan on 04/03/2019.
//  Copyright © 2019 FlowKit2. All rights reserved.
//

import UIKit

public protocol ReusableViewProtocol: class {

	static var reusableViewType: AnyObject.Type { get }
	static var reusableViewClass: AnyClass { get }
	static var reusableViewIdentifier: String { get }
	static var reusableViewSource: ReusableViewSource { get }

	static func registerReusableView(inTable table: UITableView?, as type: ReusableViewRegistrationType)
	static func registerReusableView(inCollection collection: UICollectionView?, as type: ReusableViewRegistrationType)
}

public extension ReusableViewProtocol {

	static var reusableViewType: AnyObject.Type {
		return reusableViewClass.self
	}

	static var reusableViewSource: ReusableViewSource {
		return .fromStoryboard
	}

	static var reusableViewIdentifier: String {
		return String(describing: reusableViewType)
	}

	static func registerReusableView(inTable table: UITableView?, as type: ReusableViewRegistrationType) {
		switch reusableViewSource {
		case .fromStoryboard:
			if type.isHeaderFooter {
				fatalError("Cannot load header/footer from storyboard. Use another source (xib/class) instead.")
			}
			break

		case .fromXib(let name, let bundle):
			let srcBundle = (bundle ?? Bundle.init(for: reusableViewClass))
			let srcNib = UINib(nibName: (name ?? reusableViewIdentifier), bundle: srcBundle)

			if type == .cell {
				table?.register(srcNib, forCellReuseIdentifier: reusableViewIdentifier)
			} else {
				table?.register(srcNib, forHeaderFooterViewReuseIdentifier: reusableViewIdentifier)
			}

		case .fromClass:

			if type == .cell {
				table?.register(reusableViewClass, forCellReuseIdentifier: reusableViewIdentifier)
			} else {
				table?.register(reusableViewClass, forHeaderFooterViewReuseIdentifier: reusableViewIdentifier)
			}
		}
	}

	static func registerReusableView(inCollection collection: UICollectionView?, as type: ReusableViewRegistrationType) {
		switch reusableViewSource {
		case .fromStoryboard:
			if type.isHeaderFooter {
				fatalError("Cannot load header/footer from storyboard. Use another source (xib/class) instead.")
			}
			break

		case .fromXib(let name, let bundle):
			let srcBundle = (bundle ?? Bundle.init(for: reusableViewClass))
			let srcNib = UINib(nibName: (name ?? reusableViewIdentifier), bundle: srcBundle)

			switch type {
			case .cell:
				collection?.register(srcNib, forCellWithReuseIdentifier: reusableViewIdentifier)
			case .header:
				collection?.register(srcNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reusableViewIdentifier)
			case .footer:
				collection?.register(srcNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: reusableViewIdentifier)
			}

		case .fromClass:
			switch type {
			case .cell:
				collection?.register(reusableViewClass, forCellWithReuseIdentifier: reusableViewIdentifier)
			case .header:
				collection?.register(reusableViewClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reusableViewIdentifier)
			case .footer:
				collection?.register(reusableViewClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: reusableViewIdentifier)
			}

		}
	}

}

public enum ReusableViewRegistrationType {
	case cell
	case header
	case footer

	var isHeaderFooter: Bool {
		guard case .cell = self else {
			return true
		}
		return false
	}
}

extension UITableViewCell : ReusableViewProtocol {
	public static var reusableViewClass: AnyClass {
		return self
	}
}

extension UICollectionViewCell : ReusableViewProtocol {
	public static var reusableViewClass: AnyClass {
		return self
	}
}
