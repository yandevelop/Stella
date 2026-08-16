import Shook
import CydiaSubstrate
import StellaC

// this may seem redundant because we are already checking the iOS version
// on initiation of the tweak, but this is necessary to ensure
// that the tweak does not crash trying to demangle the class at runtime 
// @available marks a complete class as available iirc so this is necessary!
@available(iOS 16, *)
@ClassHook("CSActivityItemViewController", type: CSActivityItemViewController.self)
class CSActivityItemViewControllerHook {
    @Property var currentBounds: CGRect = .zero
    @Property var snowEmitterLayer: CAEmitterLayer? = nil
    
    @Hook("viewDidLoad")
    func viewDidLoad() {
        orig.viewDidLoad()

        snowEmitterLayer = SnowFactory.createStaticSnowEmitterLayer()

        guard let snowEmitterLayer = snowEmitterLayer else { return }
        
        StellaManager.shared.musicEmitterLayer = snowEmitterLayer

        target.view.layer.addSublayer(snowEmitterLayer)
    }

    @Hook("viewDidLayoutSubviews")
    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()

        if (!CGRectEqualToRect(target.view.bounds, currentBounds)) {
            currentBounds = target.view.bounds
            snowEmitterLayer?.emitterSize = CGSizeMake(currentBounds.size.width * 0.9, 0)
            snowEmitterLayer?.emitterPosition = CGPoint(x: currentBounds.midX, y: 0)
        }
    }
}