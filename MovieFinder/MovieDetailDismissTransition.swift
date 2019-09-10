//
//  MovieDetailsDismissTransition.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 6.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

class MovieDetailDismissTransition: NSObject, UIViewControllerAnimatedTransitioning {

    private var posterCell: PosterCell

    init(posterCell: PosterCell) {
        self.posterCell = posterCell
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from)
            else { return }

        let duration = self.transitionDuration(using: transitionContext)
        if  let toNavVC = toViewController as? UINavigationController,
            let _ = toNavVC.viewControllers.first as? MainVC,
            let movieDetailVC = fromViewController as? MovieDetailVC {

            let detailView = movieDetailVC.detailView
            let toFrame = posterCell.imageView.convert(posterCell.imageView.frame, to: UIApplication.shared.keyWindow)

            let originalFrame = detailView.posterViewOriginalFrame
            detailView.posterTopConstraint.constant = originalFrame.minY
            detailView.posterLeftConstraint.constant = originalFrame.minX
            detailView.posterWidthConstraint.constant = originalFrame.width
            detailView.posterHeightConstraint.constant = originalFrame.height
            movieDetailVC.view.layoutIfNeeded()

            UIView.animate(withDuration: duration / 2, delay: 0, options: [.curveEaseInOut], animations: {
                detailView.dismissBtn.alpha = 0
                detailView.posterInfoSV.alpha = 0
                detailView.favouriteBtn.alpha = 0
                detailView.infoSV.alpha = 0
            }, completion: nil)

            UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
                detailView.posterTopConstraint.constant = toFrame.minY
                detailView.posterLeftConstraint.constant = toFrame.minX
                detailView.posterWidthConstraint.constant = toFrame.width
                detailView.posterHeightConstraint.constant = toFrame.height
                detailView.posterView.transform = .identity
                detailView.visualEffectView.effect = nil
                detailView.dismissBtn.transform = CGAffineTransform(translationX: 0, y: toFrame.minY - originalFrame.minY)
                detailView.posterInfoSV.transform = CGAffineTransform(translationX: 0, y: toFrame.minY - originalFrame.minY)
                detailView.favouriteBtn.transform = CGAffineTransform(translationX: 0, y: toFrame.minY - originalFrame.minY)
                detailView.infoSV.transform = CGAffineTransform(translationX: 0, y: toFrame.maxY - originalFrame.maxY)
                movieDetailVC.view.layoutIfNeeded()
            }) { _ in
                if !transitionContext.transitionWasCancelled {
                    self.posterCell.isHidden = false
                    if let posterSmallCell = self.posterCell as? PosterSmallCell {
                        posterSmallCell.ratingLabel.alpha = 0
                        posterSmallCell.genresLabel.alpha = 0
                        posterSmallCell.titleLabel.alpha = 0
                        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
                            posterSmallCell.ratingLabel.alpha = 1
                            posterSmallCell.genresLabel.alpha = 1
                            posterSmallCell.titleLabel.alpha = 1
                        }, completion: nil)
                    }
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }

        } else {

            UIView.animate(withDuration: duration, animations: {
                fromViewController.view.alpha = 0
            }) { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}


