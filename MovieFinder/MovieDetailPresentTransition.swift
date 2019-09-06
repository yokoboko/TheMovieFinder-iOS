//
//  MovieDetailsPresentTransition.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 6.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

class MovieDetailPresentTransition: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.45
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from)
            else { return }

        transitionContext.containerView.addSubview(toViewController.view)
        let duration = self.transitionDuration(using: transitionContext)

        
        if  let fromNavVC = fromViewController as? UINavigationController,
            let _ = fromNavVC.viewControllers.first as? MainVC,
            let movieDetailVC = toViewController as? MovieDetailVC {

            let detailView = movieDetailVC.detailView

            let fromFrame = movieDetailVC.posterCell.imageView.convert(movieDetailVC.posterCell.imageView.frame, to: UIApplication.shared.keyWindow)
            let toFrame = movieDetailVC.detailView.posterViewOriginalFrame

            detailView.posterTopConstraint.constant = fromFrame.minY
            detailView.posterLeftConstraint.constant = fromFrame.minX
            detailView.posterWidthConstraint.constant = fromFrame.width
            detailView.posterHeightConstraint.constant = fromFrame.height
            movieDetailVC.view.layoutIfNeeded()
            movieDetailVC.posterCell.isHidden = true
            UIView.animate(withDuration: duration, animations: {
                detailView.posterTopConstraint.constant = toFrame.minY
                detailView.posterLeftConstraint.constant = toFrame.minX
                detailView.posterWidthConstraint.constant = toFrame.width
                detailView.posterHeightConstraint.constant = toFrame.height
                detailView.visualEffectView.effect = detailView.blurEffect
                movieDetailVC.view.layoutIfNeeded()
            }) { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }

        } else {

            toViewController.view.alpha = 0
            UIView.animate(withDuration: duration, animations: {
                toViewController.view.alpha = 1
            }) { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}
