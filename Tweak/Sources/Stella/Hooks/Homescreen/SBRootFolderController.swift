import Shook
import CydiaSubstrate
import StellaC

@ClassHook("SBRootFolderController", type: SBRootFolderController.self)
class SBRootFolderControllerHook {
    @Property var snowEmitterLayer: CAEmitterLayer? = nil
    @Property var currentBounds: CGRect = .zero

    @Property var manager: StellaManager = StellaManager.shared

    @Hook("viewDidLoad")
    func viewDidLoad() {
        orig.viewDidLoad()

        setupHomeSnowLayer()
    }

    @New("setupHomeSnowLayer")
    @objc func setupHomeSnowLayer() {
        snowEmitterLayer = SnowFactory.createSnowEmitterLayer(configuration: StellaManager.shared.homescreenConfig!)

        guard let snowEmitterLayer = snowEmitterLayer else { return }

        target.view.layer.addSublayer(snowEmitterLayer)

        manager.homescreenEmitterLayer = snowEmitterLayer

        if StellaPreferences.shared.settings.homescreenSnowBehindIcons {
            target.view.layer.insertSublayer(snowEmitterLayer, at: 0)
        }
    }

    @Hook("viewWillDisappear:")
    func viewWillDisappear(_ animated: Bool) {
        orig.viewWillDisappear(animated)

        manager.pauseHomescreenView()
    }

    @Hook("viewWillAppear:")
    func viewWillAppear(_ animated: Bool) {
        orig.viewWillAppear(animated)

        manager.resumeHomescreenView()
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