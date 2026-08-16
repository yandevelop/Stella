import UIKit
import Shook
import StellaC

struct SnowflakeConfiguration {
    var name: String = ""
    var particleColor: UIColor
    var particleBirthRate: CGFloat
    var particleSpeed: CGFloat
    var particleWind: CGFloat
}

@objc(Tweak)
@objcMembers
public class Tweak: NSObject {
    public static func setup() {
        if readPrefs(), StellaPreferences.shared.settings.enabled {
            guard let settings = StellaPreferences.shared.settings else { return }

            if settings.lockscreen {
                StellaManager.shared.lockscreenConfig = SnowflakeConfiguration(
                    name: "lockscreen",
                    particleColor: UIColor(hex: settings.lockscreenSnowColor),
                    particleBirthRate: CGFloat(settings.lockscreenSpawnRate),
                    particleSpeed: CGFloat(settings.lockscreenSnowSpeed),
                    particleWind: CGFloat(settings.lockscreenSnowWind)
                )

                CSMainPageContentViewControllerHook.activate()
                SBBacklightControllerHook.activate()
                SBLockScreenManagerHook.activate()
            }
            
            if settings.notifications {
                NCNotificationShortLookViewControllerHook.activate()
            }

            if settings.musicPlayer {
                if #available(iOS 16, *) {
                    CSActivityItemViewControllerHook.activate()
                    CSAdjunctItemViewHook.activate()
                    NCNotificationListSupplementaryHostingViewControllerHook.activate()
                } else {
                    MRUCoverSheetViewControllerHook.activate()
                }
            }

            if !settings.homescreen { return }

            StellaManager.shared.homescreenConfig = SnowflakeConfiguration(
                name: "homescreen",
                particleColor: UIColor(hex: settings.homescreenSnowColor),
                particleBirthRate: CGFloat(settings.homescreenSpawnRate),
                particleSpeed: CGFloat(settings.homescreenSnowSpeed),
                particleWind: CGFloat(settings.homescreenSnowWind)
            )

            SBRootFolderControllerHook.activate()
            
            if !StellaPreferences.shared.settings.homescreenDockEnabled { return }

            if UIDevice.current.model.contains("iPad") {
                SBFloatingDockViewControllerHook.activate()
            } else {
                SBRootFolderController_DockHook.activate()
            }
        }
    }

    private static func readPrefs() -> Bool {
        do {
            try StellaPreferences.shared.loadSettings()
            return true
        } catch {
            print("Error reading prefs: \(error)")
        }
        return false
    }
}