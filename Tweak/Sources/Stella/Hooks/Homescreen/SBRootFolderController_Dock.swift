import Shook
import CydiaSubstrate
import StellaC

@ClassHook("SBRootFolderController", type: SBRootFolderController.self)
class SBRootFolderController_DockHook {
    @Property var dockEmitterLayer: CAEmitterLayer? = nil
    @Property var dockBounds: CGRect = .zero
    
    @Hook("viewDidLoad")
    func viewDidLoad() {
        orig.viewDidLoad()

        setupDockSnowLayer()
    }

    @New("setupDockSnowLayer")
    @objc func setupDockSnowLayer() {
        if let dockView = target.dockIconListView?.superview {
            dockEmitterLayer = SnowFactory.createStaticSnowEmitterLayer()
            guard let dockEmitterLayer = dockEmitterLayer else { return }

            dockView.layer.addSublayer(dockEmitterLayer)
            StellaManager.shared.dockEmitterLayer = dockEmitterLayer
        }
    }

    @Hook("viewDidLayoutSubviews")
    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()

        if let dockView = target.dockIconListView?.superview {
            if (!CGRectEqualToRect(dockView.bounds, dockBounds)) {
                dockBounds = dockView.bounds
                dockEmitterLayer?.emitterSize = CGSizeMake(dockBounds.size.width * 0.8, 0)
                dockEmitterLayer?.emitterPosition = CGPoint(x: dockBounds.midX, y: 0)
            }
        }
    }
}