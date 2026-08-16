import Shook
import CydiaSubstrate
import StellaC

@ClassHook("SBBacklightController", type: SBBacklightController.self)
class SBBacklightControllerHook {
    @Property var manager: StellaManager = StellaManager.shared

    @Hook("turnOnScreenFullyWithBacklightSource:")
    func turnOnScreenFully(_ source: Int64) {
        orig.turnOnScreenFully(source)
        
        if manager.lockscreenPaused {
            manager.resumeAllLockscreenViews()
        }
    }
}