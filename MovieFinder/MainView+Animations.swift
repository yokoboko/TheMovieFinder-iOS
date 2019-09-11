//
//  MainView+Animations.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 2.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

// MARK: - Animations

extension MainView {

    func hideViewsAndShowLogoWhileLoadingOnAppLaunch() {

        guard logoImageView == nil else { return }

        self.isUserInteractionEnabled = false

        logoImageView = UIImageView(image: UIImage(named: "launchscreen_logo"))
        if let logoImageView = logoImageView {
            logoImageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(logoImageView)
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -32).isActive = true
        }

        backgroundView.alpha = 0
        sectionLabel.alpha = 0
        filterLabel.alpha = 0
        collectionView.alpha = 0
        infoNameLabel.alpha = 0
        infoRatingLabel.alpha = 0
        infoGenresLabel.alpha = 0
        scrollToTopContainer.alpha = 0
        toggleLayoutBtn.alpha = 0
        filtersBtn.alpha = 0
    }

    func showViewsAfterLoadingDataOnAppLaunch() {

        guard let logoImageView = logoImageView  else { return }

        UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseOut], animations: {
            logoImageView.alpha = 0
            logoImageView.transform = CGAffineTransform(translationX: 0, y: -64)
        }) { (success) in
            self.removeLogo()
        }

        sectionLabel.transform = CGAffineTransform(translationX: 0, y: 32)
        filterLabel.transform = CGAffineTransform(translationX: 0, y: 32)
        collectionView.transform = CGAffineTransform(translationX: 0, y: 56)
        infoNameLabel.transform = CGAffineTransform(translationX: 0, y: 66)
        infoRatingLabel.transform = CGAffineTransform(translationX: 0, y: 66)
        infoGenresLabel.transform = CGAffineTransform(translationX: 0, y: 74)
        scrollToTopContainer.transform = CGAffineTransform(translationX: 0, y: 80)
        toggleLayoutBtn.transform = CGAffineTransform(translationX: 0, y: 80)
        filtersBtn.transform = CGAffineTransform(translationX: 0, y: 80)

        UIView.animate(withDuration: 0.8, delay: 0.6, options: [.curveEaseOut], animations: {
            self.sectionLabel.alpha = 1
            self.sectionLabel.transform = .identity
            self.filterLabel.alpha = 1
            self.filterLabel.transform = .identity
            self.collectionView.alpha = 1
            self.collectionView.transform = .identity
            self.infoNameLabel.alpha = 1
            self.infoNameLabel.transform = .identity
            self.infoRatingLabel.alpha = 1
            self.infoRatingLabel.transform = .identity
            self.infoGenresLabel.alpha = 1
            self.infoGenresLabel.transform = .identity
            self.scrollToTopContainer.alpha = 1
            self.scrollToTopContainer.transform = .identity
            self.toggleLayoutBtn.alpha = 1
            self.toggleLayoutBtn.transform = .identity
            self.filtersBtn.alpha = 1
            self.filtersBtn.transform = .identity
        }, completion: nil)

        UIView.animate(withDuration: 1.2, delay: 1, options: [.curveEaseOut], animations: {
            self.backgroundView.alpha = 1
        }) { (success) in
            self.isUserInteractionEnabled = true
        }

        // For testing fade in animation on app launch
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { self.hideViewsAndShowLogoWhileLoadingOnAppLaunch() }
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { self.showViewsAfterLoadingDataOnAppLaunch() }
    }

    private func removeLogo() {

        guard let logoImageView = logoImageView  else { return }
        willRemoveSubview(logoImageView)
        self.logoImageView = nil
    }

    func showInfo() {

        guard isCoverFlowLayout, isFilterHidden else { return }
        stopInfoAnimation()

        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            self.infoNameLabel.alpha = 1
            self.infoRatingLabel.alpha = 1
            self.infoGenresLabel.alpha = 1
            self.infoNameLabel.transform = .identity
            self.infoRatingLabel.transform = .identity
            self.infoGenresLabel.transform = .identity
        })
    }

    func hideInfo() {

        guard isCoverFlowLayout else { return }
        stopInfoAnimation()

        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            self.infoNameLabel.alpha = 0
            self.infoRatingLabel.alpha = 0
            self.infoGenresLabel.alpha = 0
            self.infoNameLabel.transform = CGAffineTransform(translationX: 0, y: 8)
            self.infoRatingLabel.transform = CGAffineTransform(translationX: 0, y: 8)
            self.infoGenresLabel.transform = CGAffineTransform(translationX: 0, y: 8)
        })
    }

    private func stopInfoAnimation() {

        infoNameLabel.layer.removeAllAnimations()
        infoRatingLabel.layer.removeAllAnimations()
        infoGenresLabel.layer.removeAllAnimations()
    }

    func showFilter(duration: TimeInterval = 0.45) {

        if isFilterHidden {

            isFilterHidden = false

            filterView.isUserInteractionEnabled = true
            filterViewTopConstraint.constant = -filterView.frame.height - filterViewMargin

            collectionViewBottomConstraint.constant = collectionViewBottomMarginFilters
            if !isCoverFlowLayout {
                collectionViewHeightConstraint.constant = safeAreaFrame.height - collectionViewHeightFlowFiltersMargin
                collectionView.collectionViewLayout.invalidateLayout()
            }

            scrollToTopContainer.isUserInteractionEnabled = false
            toggleLayoutBtn.isUserInteractionEnabled = false
            filtersBtn.isUserInteractionEnabled = false

            UIView.animate(withDuration: duration / 2, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
                self.infoNameLabel.alpha = 0
                self.infoGenresLabel.alpha = 0
                self.infoRatingLabel.alpha = 0
            }, completion: nil)

            //UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: { }, completion: nil)
            UIView.animate(withDuration: duration,
                           delay: 0,
                           usingSpringWithDamping: 0.75,
                           initialSpringVelocity: 0,
                           options: [.curveEaseOut, .allowUserInteraction],
                           animations: {
                self.sectionLabel.alpha = 0
                self.sectionLabel.transform = CGAffineTransform(translationX: 0, y: -32)
                self.filterLabel.alpha = 0
                self.filterLabel.transform = CGAffineTransform(translationX: 0, y: -32)
                self.scrollToTopContainer.alpha = 0
                self.toggleLayoutBtn.alpha = 0
                self.filtersBtn.alpha = 0
                self.filterView.alpha = 1
                self.layoutIfNeeded()
            })
        }
    }

    func hideFilter(duration: TimeInterval = 0.45) {
        if !isFilterHidden {

            isFilterHidden = true

            filterView.isUserInteractionEnabled = false
            filterViewTopConstraint.constant = 0

            collectionViewBottomConstraint.constant = isCoverFlowLayout ? collectionViewBottomMarginCoverFlow : collectionViewBottomMarginFlow
            if !isCoverFlowLayout {
                collectionViewHeightConstraint.constant = safeAreaFrame.height - collectionViewHeightFlowMargin
                collectionView.collectionViewLayout.invalidateLayout()
            }

            scrollToTopContainer.isUserInteractionEnabled = true
            toggleLayoutBtn.isUserInteractionEnabled = true
            filtersBtn.isUserInteractionEnabled = true

            if self.isCoverFlowLayout {
                UIView.animate(withDuration: duration / 2, delay: duration / 2, options: [.curveEaseOut, .allowUserInteraction], animations: {
                    self.infoNameLabel.alpha = 1
                    self.infoGenresLabel.alpha = 1
                    self.infoRatingLabel.alpha = 1
                }, completion: nil)
            }

            UIView.animate(withDuration: duration,
                           delay: 0,
                           usingSpringWithDamping: 0.75,
                           initialSpringVelocity: 0,
                           options: [.curveEaseOut, .allowUserInteraction],
                           animations: {
                self.sectionLabel.alpha = 1
                self.sectionLabel.transform = .identity
                self.filterLabel.alpha = 1
                self.filterLabel.transform = .identity
                self.scrollToTopContainer.alpha = 1
                self.toggleLayoutBtn.alpha = 1
                self.filtersBtn.alpha = 1
                self.filterView.alpha = 0
                self.layoutIfNeeded()
            })
        }
    }

    @objc func handleFilterShowHidePanGesture(recognizer: UIPanGestureRecognizer) {

        switch recognizer.state {
        case .began:
            let velocity = recognizer.velocity(in: self)
            if !filterStartDrag, velocity.y != 0 && abs(velocity.y) > abs(velocity.x) {
                filterStartDrag = true
                filterDragShift = filterViewTopConstraint.constant
            }

        case .changed:
            if filterStartDrag {
                dragVertical(recognizer: recognizer)
            }

        case .ended, .cancelled, .failed:
            if filterStartDrag {
                stopDraging()
            }

        default: break
        }
    }

    private func dragVertical(recognizer: UIPanGestureRecognizer) {

        let translationY = recognizer.translation(in: self).y + filterDragShift
        let velocityY = recognizer.velocity(in: self).y
        let limitDown: CGFloat = 16
        let limitUp = -filterView.frame.height - filterViewMargin

        if velocityY < 0 {
            filterDragDirectionUp = true
        } else if velocityY > 0 {
            filterDragDirectionUp = false
        }

        if translationY >= limitDown {
            let rubberEffect: CGFloat = limitDown * (1 + log10(translationY / limitDown))
            filterViewTopConstraint.constant = rubberEffect
        } else if translationY <= limitUp {
            let rubberEffect: CGFloat = limitUp * (1 + log10(translationY / limitUp))
            filterViewTopConstraint.constant = rubberEffect
        } else {
            filterViewTopConstraint.constant = translationY
        }

        // 0.0 -> 1.0
        let progress = min(0, max(limitUp, filterViewTopConstraint.constant)) / limitUp

        if isCoverFlowLayout {
            infoNameLabel.alpha = 1 - min(1, progress * 2)
            infoGenresLabel.alpha = 1 - min(1, progress * 2)
            infoRatingLabel.alpha = 1 - min(1, progress * 2)
        }
        sectionLabel.alpha = 1 - progress
        filterLabel.alpha = 1 - progress
        scrollToTopContainer.alpha = 1 - progress
        toggleLayoutBtn.alpha = 1 - progress
        filtersBtn.alpha = 1 - progress
        filterView.alpha = progress

        sectionLabel.transform = CGAffineTransform(translationX: 0, y: -32 * progress)
        filterLabel.transform = CGAffineTransform(translationX: 0, y: -32 * progress)

        let startConstant = isCoverFlowLayout ? collectionViewBottomMarginCoverFlow : collectionViewBottomMarginFlow
        let endConstant = collectionViewBottomMarginFilters
        collectionViewBottomConstraint.constant = startConstant + (endConstant - startConstant) * progress

        if !isCoverFlowLayout {
            let startConstant = safeAreaFrame.height - collectionViewHeightFlowMargin
            let endConstant = safeAreaFrame.height - collectionViewHeightFlowFiltersMargin
            collectionViewHeightConstraint.constant = startConstant - (startConstant - endConstant) * progress
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    private func stopDraging() {
        filterStartDrag = false
        if filterDragDirectionUp {
            isFilterHidden = true
            showFilter(duration: 0.35)
        } else {
            isFilterHidden = false
            hideFilter(duration: 0.35)
        }
    }

}
