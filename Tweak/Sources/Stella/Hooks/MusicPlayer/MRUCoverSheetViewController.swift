import Shook
import CydiaSubstrate
import StellaC

@ClassHook("MRUCoverSheetViewController", type: MRUCoverSheetViewController.self)
class MRUCoverSheetViewControllerHook {
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