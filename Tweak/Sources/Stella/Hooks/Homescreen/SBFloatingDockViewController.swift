import Shook
import CydiaSubstrate
import StellaC

@ClassHook("SBFloatingDockViewController", type: SBFloatingDockViewController.self)
class SBFloatingDockViewControllerHook {
    @Property var dockEmitterLayer: CAEmitterLayer? = nil
    @Property var dockBounds: CGRect = .zero

    @Hook("viewDidLoad")
    func viewDidLoad() {
        orig.viewDidLoad()

        setupDockSnowLayer()
    }

    @New("setupDockSnowLayer")
    @objc func setupDockSnowLayer() {
        guard let platterView = target.dockView.mainPlatterView else { return }

        dockEmitterLayer = SnowFactory.createStaticSnowEmitterLayer(withBounds: platterView.bounds)
        guard let dockEmitterLayer = dockEmitterLayer else { return }

        platterView.layer.addSublayer(dockEmitterLayer)
        StellaManager.shared.dockEmitterLayer = dockEmitterLayer
    }

    @Hook("viewDidAppear:")
    func viewDidAppear(_ animated: Bool) {
        orig.viewDidAppear(animated)

        if (!CGRectEqualToRect(target.dockView.mainPlatterView.bounds, dockBounds)) {
            dockBounds = target.dockView.mainPlatterView.bounds
            dockEmitterLayer?.emitterSize = CGSizeMake(dockBounds.size.width * 0.8, 0)
            dockEmitterLayer?.emitterPosition = CGPoint(x: dockBounds.midX, y: 0)
        }
    }
}