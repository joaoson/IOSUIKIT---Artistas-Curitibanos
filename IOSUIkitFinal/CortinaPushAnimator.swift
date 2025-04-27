//
//  CortinaPushAnimator.swift
//  IOSUIkitFinal
//
//  Created by João Vitor De Freitas on 26/04/25.
//


import UIKit

class CortinaPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let isPushing: Bool
    
    init(isPushing: Bool) {
        self.isPushing = isPushing
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPushing {
            animatePushTransition(using: transitionContext)
        } else {
            animatePopTransition(using: transitionContext)
        }
    }
    
    private func animatePushTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        
        let finalFrame = transitionContext.finalFrame(for: toVC)
        toVC.view.frame = finalFrame
        
        let leftCurtain = UIView(frame: CGRect(x: 0, y: 0, width: finalFrame.width / 2, height: finalFrame.height))
        leftCurtain.backgroundColor = .white
        
        let rightCurtain = UIView(frame: CGRect(x: finalFrame.width / 2, y: 0, width: finalFrame.width / 2, height: finalFrame.height))
        rightCurtain.backgroundColor = .white
        
        containerView.addSubview(leftCurtain)
        containerView.addSubview(rightCurtain)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
            leftCurtain.frame = CGRect(x: -finalFrame.width / 2, y: 0, width: finalFrame.width / 2, height: finalFrame.height)
            rightCurtain.frame = CGRect(x: finalFrame.width, y: 0, width: finalFrame.width / 2, height: finalFrame.height)
        }) { _ in
            leftCurtain.removeFromSuperview()
            rightCurtain.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    private func animatePopTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        let finalFrame = fromVC.view.frame
        
        let leftCurtain = UIView(frame: CGRect(x: -finalFrame.width / 2, y: 0, width: finalFrame.width / 2, height: finalFrame.height))
        leftCurtain.backgroundColor = .white
        
        let rightCurtain = UIView(frame: CGRect(x: finalFrame.width, y: 0, width: finalFrame.width / 2, height: finalFrame.height))
        rightCurtain.backgroundColor = .white
        
        containerView.addSubview(leftCurtain)
        containerView.addSubview(rightCurtain)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
            leftCurtain.frame = CGRect(x: 0, y: 0, width: finalFrame.width / 2, height: finalFrame.height)
            rightCurtain.frame = CGRect(x: finalFrame.width / 2, y: 0, width: finalFrame.width / 2, height: finalFrame.height)
        }) { _ in
            leftCurtain.removeFromSuperview()
            rightCurtain.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

class CortinaNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            return CortinaPushAnimator(isPushing: true)
        } else if operation == .pop {
            return CortinaPushAnimator(isPushing: false)
        }
        
        return nil
    }
}
