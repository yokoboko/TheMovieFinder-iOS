//
//  MovieDetailsDismissTransition.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 6.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

class MovieDetailDismissTransition: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.45
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
            let toFrame = movieDetailVC.posterCell.imageView.convert(movieDetailVC.posterCell.imageView.frame, to: UIApplication.shared.keyWindow)

            let originalFrame = detailView.posterViewOriginalFrame
            detailView.posterTopConstraint.constant = originalFrame.minY
            detailView.posterLeftConstraint.constant = originalFrame.minX
            detailView.posterWidthConstraint.constant = originalFrame.width
            detailView.posterHeightConstraint.constant = originalFrame.height
            movieDetailVC.view.layoutIfNeeded()
            UIView.animate(withDuration: duration, animations: {
                detailView.posterTopConstraint.constant = toFrame.minY
                detailView.posterLeftConstraint.constant = toFrame.minX
                detailView.posterWidthConstraint.constant = toFrame.width
                detailView.posterHeightConstraint.constant = toFrame.height
                detailView.visualEffectView.effect = nil
                movieDetailVC.view.layoutIfNeeded()
            }) { _ in
                if !transitionContext.transitionWasCancelled {
                    movieDetailVC.posterCell.isHidden = false
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


