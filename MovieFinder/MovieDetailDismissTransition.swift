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
    private var posterAnimationEnabled: Bool

    init(posterCell: PosterCell, posterAnimationEnabled: Bool) {
        self.posterCell = posterCell
        self.posterAnimationEnabled = posterAnimationEnabled
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionContext?.isInteractive ?? true ? 0.3 : 0.6
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }

        let duration = self.transitionDuration(using: transitionContext)
        
        if  let movieDetailVC = fromViewController as? MovieDetailVC {

            if posterAnimationEnabled {
                posterDismissAnimation(transitionContext: transitionContext, movieDetailVC: movieDetailVC, duration: duration)
            } else {
                withoutPosterDismissAnimation(transitionContext: transitionContext, movieDetailVC: movieDetailVC, duration: duration)
            }

        } else {

            UIView.animate(withDuration: duration, animations: {
                fromViewController.view.alpha = 0
            }) { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }

    private func posterDismissAnimation(transitionContext: UIViewControllerContextTransitioning,
                                        movieDetailVC: MovieDetailVC,
                                        duration: TimeInterval) {

        let detailView = movieDetailVC.detailView
        let safeAreaInsets = UIApplication.shared.keyWindow?.safeInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let cellFrameToWindow = posterCell.imageView.convert(posterCell.imageView.frame, to: UIApplication.shared.keyWindow)
        let toFrame = CGRect(x: cellFrameToWindow.minX - safeAreaInsets.left,
                               y: cellFrameToWindow.minY - safeAreaInsets.top,
                               width: cellFrameToWindow.width,
                               height: cellFrameToWindow.height)

        let originalFrame = detailView.posterViewOriginalFrame
        detailView.posterTopConstraint.constant = originalFrame.minY
        detailView.posterLeftConstraint.constant = originalFrame.minX
        detailView.posterWidthConstraint.constant = originalFrame.width
        detailView.posterHeightConstraint.constant = originalFrame.height
        movieDetailVC.view.layoutIfNeeded()

        detailView.visualEffectView.effect = detailView.blurEffect

        let damping: CGFloat = transitionContext.isInteractive ? 1.0 : 0.74
        let animationCurve: UIView.AnimationOptions = transitionContext.isInteractive ? .curveLinear : .curveEaseOut
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: [animationCurve], animations: {

            detailView.dismissBtn.alpha = 0
            detailView.posterInfoSV.alpha = 0
            detailView.favouriteBtn.alpha = 0
            detailView.infoSV.alpha = 0

            detailView.posterTopConstraint.constant = toFrame.minY
            detailView.posterLeftConstraint.constant = toFrame.minX
            detailView.posterWidthConstraint.constant = toFrame.width
            detailView.posterHeightConstraint.constant = toFrame.height
            detailView.posterView.transform = .identity
            detailView.visualEffectView.effect = nil
            detailView.posterInfoSV.transform = CGAffineTransform(translationX: 0, y: toFrame.minY - originalFrame.minY)
            detailView.favouriteBtn.transform = CGAffineTransform(translationX: 0, y: toFrame.minY - originalFrame.minY)
            detailView.infoSV.transform = CGAffineTransform(translationX: 0, y: toFrame.maxY - originalFrame.maxY)
            detailView.dismissBtn.transform = CGAffineTransform(translationX: 0, y: toFrame.maxY - originalFrame.maxY)
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
    }

    private func withoutPosterDismissAnimation(transitionContext: UIViewControllerContextTransitioning,
                                                     movieDetailVC: MovieDetailVC,
                                                     duration: TimeInterval) {

        let detailView = movieDetailVC.detailView

        detailView.visualEffectView.effect = detailView.blurEffect

        let shiftY: CGFloat = 128

        self.posterCell.isHidden = false
        posterCell.alpha = 0

        let damping: CGFloat = transitionContext.isInteractive ? 1.0 : 0.74
        let animationCurve: UIView.AnimationOptions = transitionContext.isInteractive ? .curveLinear : .curveEaseOut
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: [animationCurve], animations: {

            detailView.dismissBtn.alpha = 0
            detailView.posterInfoSV.alpha = 0
            detailView.favouriteBtn.alpha = 0
            detailView.infoSV.alpha = 0
            detailView.posterView.alpha = 0

            detailView.posterView.transform = CGAffineTransform(translationX: 0, y: shiftY)
            detailView.visualEffectView.effect = nil
            detailView.posterInfoSV.transform = CGAffineTransform(translationX: 0, y: shiftY)
            detailView.favouriteBtn.transform = CGAffineTransform(translationX: 0, y: shiftY)
            detailView.infoSV.transform = CGAffineTransform(translationX: 0, y: shiftY)
            detailView.dismissBtn.transform = CGAffineTransform(translationX: 0, y: shiftY)
            movieDetailVC.view.layoutIfNeeded()

            self.posterCell.alpha = 1

        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}


