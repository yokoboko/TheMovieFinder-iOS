//
//  MovieDetailsPresentTransition.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 6.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

class MovieDetailPresentTransition: NSObject, UIViewControllerAnimatedTransitioning {

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

        transitionContext.containerView.addSubview(toViewController.view)
        let duration = self.transitionDuration(using: transitionContext)

        
        if  let fromNavVC = fromViewController as? UINavigationController,
            let _ = fromNavVC.viewControllers.first as? MainVC,
            let movieDetailVC = toViewController as? MovieDetailVC {

            let detailView = movieDetailVC.detailView

            let fromFrame = posterCell.imageView.convert(posterCell.imageView.frame, to: UIApplication.shared.keyWindow)
            let toFrame = movieDetailVC.detailView.posterViewOriginalFrame

            detailView.posterTopConstraint.constant = fromFrame.minY
            detailView.posterLeftConstraint.constant = fromFrame.minX
            detailView.posterWidthConstraint.constant = fromFrame.width
            detailView.posterHeightConstraint.constant = fromFrame.height
            movieDetailVC.view.layoutIfNeeded()
            posterCell.isHidden = true

            detailView.dismissBtn.alpha = 0
            detailView.posterInfoSV.alpha = 0
            detailView.favouriteBtn.alpha = 0
            detailView.infoSV.alpha = 0
            UIView.animate(withDuration: duration / 2, delay: duration / 2, options: [.curveEaseInOut], animations: {
                detailView.dismissBtn.alpha = 1
                detailView.posterInfoSV.alpha = 1
                detailView.favouriteBtn.alpha = 1
                detailView.infoSV.alpha = 1
            }, completion: nil)

            detailView.dismissBtn.transform = CGAffineTransform(translationX: 0, y: fromFrame.minY - toFrame.minY)
            detailView.posterInfoSV.transform = CGAffineTransform(translationX: 0, y: fromFrame.minY - toFrame.minY)
            detailView.favouriteBtn.transform = CGAffineTransform(translationX: 0, y: fromFrame.minY - toFrame.minY)
            detailView.infoSV.transform = CGAffineTransform(translationX: 0, y: fromFrame.maxY - toFrame.maxY)
            UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
                detailView.posterTopConstraint.constant = toFrame.minY
                detailView.posterLeftConstraint.constant = toFrame.minX
                detailView.posterWidthConstraint.constant = toFrame.width
                detailView.posterHeightConstraint.constant = toFrame.height
                detailView.visualEffectView.effect = detailView.blurEffect
                detailView.dismissBtn.transform = .identity
                detailView.posterInfoSV.transform = .identity
                detailView.favouriteBtn.transform = .identity
                detailView.infoSV.transform = .identity
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
