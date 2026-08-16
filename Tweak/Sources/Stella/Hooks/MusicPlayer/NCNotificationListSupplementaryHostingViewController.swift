import Shook
import CydiaSubstrate
import StellaC

// This hook may seem redundant but it is necessary to ensure that the music player does not clip the snow particles (> iOS 16)
@available(iOS 16, *)
@ClassHook("NCNotificationListSupplementaryHostingViewController", type: NCNotificationListSupplementaryHostingViewController.self)
class NCNotificationListSupplementaryHostingViewControllerHook {
    @Hook("viewWillAppear:")
    func viewWillAppear(_ animated: Bool) {
        orig.viewWillAppear(animated)

        target.view.clipsToBounds = false
    }
}