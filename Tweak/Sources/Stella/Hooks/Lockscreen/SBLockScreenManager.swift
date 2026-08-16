import Shook
import CydiaSubstrate
import StellaC

@ClassHook("SBLockScreenManager", type: SBLockScreenManager.self)
class SBLockScreenManagerHook {
    @Property var manager: StellaManager = StellaManager.shared

    @Hook("lockUIFromSource:withOptions:")
    func lockUI(_ source: Int, _ options: AnyObject?) {
        orig.lockUI(source, options)
        
        if !manager.lockscreenPaused {
            manager.pauseAllLockscreenViews()
        }
    }
}
