import Shook
import CydiaSubstrate
import StellaC

@ClassHook("CSMainPageContentViewController", type: CSMainPageContentViewController.self)
class CSMainPageContentViewControllerHook {
    @Property var snowEmitterLayer: CAEmitterLayer? = nil
    @Property var currentBounds: CGRect = .zero
    
    @Property var manager: StellaManager = StellaManager.shared

    @Hook("viewDidLoad")
    func viewDidLoad() {
        orig.viewDidLoad()

        snowEmitterLayer = SnowFactory.createSnowEmitterLayer(configuration: manager.lockscreenConfig!)
        guard let snowEmitterLayer = snowEmitterLayer else { return }

        manager.lockscreenEmitterLayer = snowEmitterLayer
        
        target.view.layer.addSublayer(snowEmitterLayer)
    }

    @Hook("viewWillAppear:")
    func viewWillAppear(_ animated: Bool) {
        orig.viewWillAppear(animated)

        if manager.lockscreenPaused {
            manager.resumeAllLockscreenViews()
        }
    }

    @Hook("viewDidDisappear:")
    func viewDidDisappear(_ animated: Bool) {
        orig.viewDidDisappear(animated)

        if !manager.lockscreenPaused {
            manager.pauseAllLockscreenViews()
        }
    }

    @Hook("viewDidLayoutSubviews")
    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()

        if (!CGRectEqualToRect(target.view.bounds, currentBounds)) {
            currentBounds = target.view.bounds
            snowEmitterLayer?.emitterSize = CGSizeMake(currentBounds.size.width, 0)
            snowEmitterLayer?.emitterPosition = CGPoint(x: currentBounds.midX, y: -30)
        }
    }
}