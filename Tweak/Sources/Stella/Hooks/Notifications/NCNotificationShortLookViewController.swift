import Shook
import CydiaSubstrate
import StellaC

@ClassHook("NCNotificationShortLookViewController", type: NCNotificationShortLookViewController.self)
class NCNotificationShortLookViewControllerHook {
    @Property var snowEmitterLayer: CAEmitterLayer? = nil

    @Property var currentBounds: CGRect = .zero
    @Property var uniqueID: String = ""

    @Property var manager: StellaManager = StellaManager.shared

    @Hook("viewDidAppear:")
    func viewDidAppear(_ animated: Bool) {
        orig.viewDidAppear(animated)

        if target.view.layer.sublayers?.contains(where: { $0 is CAEmitterLayer }) == true { return }

        if uniqueID.isEmpty {
            uniqueID = UUID().uuidString
        }

        let snowEmitterLayer = manager.getEmitterLayer(withBounds: target.view.bounds, uniqueID: uniqueID)

        target.view.layer.addSublayer(snowEmitterLayer!)
    }

    @Hook("viewDidLayoutSubviews")
    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()

        if (!CGRectEqualToRect(target.view.bounds, currentBounds)) {
            currentBounds = target.view.bounds
            snowEmitterLayer?.emitterSize = CGSizeMake(currentBounds.size.width * 0.9, 0)
            snowEmitterLayer?.emitterPosition = CGPoint(x: currentBounds.midX, y: -30)
        }
    }
}