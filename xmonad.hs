import qualified Data.Map as M
import XMonad
import XMonad.Actions.Navigation2D
import XMonad.Config.Desktop
import XMonad.Config.Kde
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Fullscreen
import XMonad.Layout.Maximize
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.Tabbed
import XMonad.Util.Run
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName

main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $
    fullscreenSupport $
    desktopConfig
    { terminal = "konsole"
    , focusedBorderColor = "#aaaaaa"
    , normalBorderColor = "#000000"
    , manageHook = isFullscreen --> doFullFloat <+> manageHook desktopConfig -- <+> manageDocks
    , layoutHook =
        fullscreenFull
          (avoidStruts
            (smartBorders
              (smartSpacing 5 (maximize (layoutHook desktopConfig ||| Grid ||| simpleTabbedBottom)))))
    , logHook =
        dynamicLogWithPP
          xmobarPP
          { ppOutput = hPutStrLn xmproc
          , ppTitle = xmobarColor "green" "" . shorten 50
          }
    , startupHook = setWMName "LG3D" 
    , keys = myKeys <+> keys def
    }

myKeys conf@(XConfig{modMask = modm}) =
  M.fromList [((modm,xK_equal),withFocused (sendMessage . maximizeRestore))]
