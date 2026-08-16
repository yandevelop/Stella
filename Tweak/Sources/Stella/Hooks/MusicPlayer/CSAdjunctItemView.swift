import Shook
import CydiaSubstrate
import StellaC

// This hook may seem redundant but it is necessary to ensure that the music player does not clip the snow particles (< iOS 16)
@ClassHook("CSAdjunctItemView", type: CSAdjunctItemView.self)
class CSAdjunctItemViewHook {
    @Hook("didMoveToWindow")
    func didMoveToWindow() {
        orig.didMoveToWindow()
        target.clipsToBounds = false
    }
}