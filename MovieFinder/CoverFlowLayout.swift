//
//  CoverFlowLayout.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 22.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

protocol CoverFlowLayoutDelegate: class {
    func coverFlowFocused(pageIndex: Int)
}

class CoverFlowLayout: UICollectionViewFlowLayout {
    
    var minItemScale : CGFloat = 0.9
    var itemSpacing: CGFloat = 16
    var itemShift: CGFloat = 0.0
    
    var delegate: CoverFlowLayoutDelegate?
    
    private var layoutSize: CGSize = .zero
    
    
    // MARK: - Override
    
    override func prepare() {
        super.prepare()
        if let collectionViewBoundsSize = self.collectionView?.bounds.size,
            !layoutSize.equalTo(collectionViewBoundsSize) {
            layoutSize = collectionViewBoundsSize
            setupCollecitonView()
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
            let newAttributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
            else { return nil }
        return newAttributes.map { transformToCoverFlowLayoutAttributes($0) }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        return snapToItem(proposedContentOffset: proposedContentOffset, velocity: velocity)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
    // MARK: - Coverflow
    
    private func setupCollecitonView() {
        
        guard let collectionView = self.collectionView else { return }
        if collectionView.decelerationRate != .fast {
            collectionView.decelerationRate = .fast
        }
        if collectionView.isPagingEnabled {
            collectionView.isPagingEnabled = false
        }
        if scrollDirection != .horizontal {
            scrollDirection = .horizontal
        }
        if collectionView.showsHorizontalScrollIndicator {
            collectionView.showsHorizontalScrollIndicator = false
        }
    }
    
    private func transformToCoverFlowLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        guard let collectionView = self.collectionView else { return attributes }
        
        let collectionCenter = collectionView.frame.size.width / 2
        let offset = collectionView.contentOffset.x
        let normalizedCenter = attributes.center.x - offset
        
        let maxDistance = self.itemSize.width + minimumLineSpacing
        let distance = min(abs(collectionCenter - normalizedCenter), maxDistance)
        let ratio = (maxDistance - distance) / maxDistance
        
        let scale = ratio * (1 - minItemScale) + minItemScale
        let shift = (1 - ratio) * itemShift
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        attributes.zIndex = Int(ratio * 10)
        attributes.center.x = attributes.center.x + shift
        
        return attributes
    }
    
    private func snapToItem(proposedContentOffset: CGPoint, velocity: CGPoint) -> CGPoint {
        
        guard let collectionView = collectionView, !collectionView.isPagingEnabled
            else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }
        
        let pageWidth = itemSize.width + minimumLineSpacing
        let approximatePage = collectionView.contentOffset.x / pageWidth
        var currentPage = approximatePage
        
        // Velocity 0 - When you drag, hold and then release the finger. In this case in order to go to the next page, we have to go past the middle screen
        // This fixes it
        // 'else' is solving the scenario when we have velocity(to calculate clicked pages)
        if velocity.x == 0 {
            currentPage = round(approximatePage)
            let diff = (approximatePage) - floor(approximatePage + 0.5)
            let treshold: CGFloat = 0.1 // 0 -> 0.49
            if diff > treshold {
                currentPage += 1
            } else if diff < -treshold {
                currentPage -= 1
            }
        } else {
            currentPage = velocity.x < 0 ? floor(approximatePage) : ceil(approximatePage)
        }
        
        // Custom flick velocity allows for more then one page flick (the higher the value, more pages will be flicked based on high velocity)
        let flickVelocity = velocity.x * 0.3
        let flickedPages = abs(round(flickVelocity)) <= 1 ? 0 : round(flickVelocity)
        
        let newPage = max(currentPage + flickedPages, 0)
        let newHorizontalOffset = (newPage * pageWidth) - collectionView.contentInset.left
        
        delegate?.coverFlowFocused(pageIndex: Int(newPage))
        
        return CGPoint(x: newHorizontalOffset, y: proposedContentOffset.y)
    }
    
    func updateFocused() {
        
        guard let collectionView = collectionView else { return }
        let pageWidth = itemSize.width + minimumLineSpacing
        let approximatePage = collectionView.contentOffset.x / pageWidth
        delegate?.coverFlowFocused(pageIndex: Int(approximatePage))
    }
}

