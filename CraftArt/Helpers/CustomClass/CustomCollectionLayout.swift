//
//  CustomCollectionLayout.swift
//  CountAnimationLBTA
//
//  Created by YusuKe on 2018/11/20.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

protocol CustomCollectionDelegate: class {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat
}

class CustomCollectionLayout: UICollectionViewLayout {
    weak var delegate: CustomCollectionDelegate!
    var numColumns = 3
    var padding: CGFloat = 3
    var attributesArray = [UICollectionViewLayoutAttributes]()
    var contentHeight: CGFloat = 0
    
    var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.bounds.width
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard attributesArray.isEmpty, let collectionView = collectionView else { return }
        
        let columnWidth = contentWidth / CGFloat(numColumns)
        var xOffsets = [CGFloat]()
        for column in 0..<numColumns {
            xOffsets.append(columnWidth * CGFloat(column))
        }
        
        var column = 0
        var yOffsets = [CGFloat](repeating: 0, count: numColumns)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let itemHeight = delegate.collectionView(collectionView, heightForItemAt: indexPath)
            let height = itemHeight + padding * 2
            let frame = CGRect(x: xOffsets[column], y: yOffsets[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: padding, dy: padding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            attributesArray.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffsets[column] = yOffsets[column] + height
            column = column < (numColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in attributesArray {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
}
