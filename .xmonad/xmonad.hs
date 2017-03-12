import Data.Map    (fromList)
import Data.Monoid (mappend)
import System.IO
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
-- import XMonad.Layout.BinarySpacePartition
import XMonad.Actions.Navigation2D
import XMonad.Layout.Spacing
import XMonad.Util.Dzen
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Paste
import XMonad.Util.Run(spawnPipe)

-----

-- myLayout = emptyBSP

-----

myManagementHooks :: [ManageHook]
myManagementHooks = [
  resource =? "xmobar" --> doIgnore
  , resource =? "stalonetray" --> doIgnore
  -- , resource =? "trayer" --> doIgnore
  , manageDocks
  ]

-----

main = do
    spawn "bash -c 'if ! ( ps -fA | grep -i \" [s]talonetray\" ); then echo \"check\" &&\
    \ \"stalonetray\" & \
    \ export LANG=en_US.UTF-8 &&\
    \ echo \"check\" &&\
    \ xsetroot -cursor_name \"left_ptr&\" &&\
    \ echo \"check\" &&\
    \ feh --bg-scale /home/vatrat/foto/background/wallpaper.png &&\
    \ echo \"check\" &&\
    \ setxkbmap -rules evdev -model evdev -layout us -variant altgr-intl &&\
    \ echo \"check\" &&\
    \ setxkbmap -option \"caps:escape\" &&\
    \ echo \"check\" &&\
    \ xmodmap -e \"keycode 133 = ISO_Level3_Shift\" &&\
    \ echo \"check\" &&\
    \ xmodmap -e \"keycode 135 = ISO_Level3_Shift\" &&\
    \ echo \"check\" &&\
    \ xmodmap -e \"keycode 108 = Alt_L\" &&\
    \ echo \"check\" &&\
    \ xinput set-prop \"SynPS/2 Synaptics TouchPad\" \"libinput Tapping Enabled\" 1 &&\
    \ echo \"check\" &&\
    \ echo xmonad started; else echo xmonad already running, no action; fi' >~/xmlog 2>&1"
    xmproc <- spawnPipe "xmobar"

    xmonad $ def
        { manageHook=manageHook def <+> manageDocks 
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 40
                        }
        , layoutHook=avoidStruts $ layoutHook def
        -- , layoutHook = myLayout
        , terminal = "gnome-terminal"
        --, modMask = mod4Mask     -- Rebind Mod to the Windows key
        -- , startupHook = spawn "xmodmap -e 'add mod4 = Menu'"
        } `additionalKeys`
            [ 
              ((mod1Mask, xK_z), spawn "slock")
              ,((mod1Mask, xK_Print), spawn "scrot -s")
              ,((mod1Mask, xK_p), spawn "rofi -show run")
              -- ,((mod1Mask, xK_d), dzenConfig return "testing")

              ,((mod1Mask, xK_l), windowGo R False)
              ,((mod1Mask, xK_h), windowGo L False)
              ,((mod1Mask, xK_j), windowGo D False)
              ,((mod1Mask, xK_k), windowGo U False)

              ,((mod1Mask .|. shiftMask, xK_l), windowSwap R False)
              ,((mod1Mask .|. shiftMask, xK_h), windowSwap L False)
              ,((mod1Mask .|. shiftMask, xK_j), windowSwap D False)
              ,((mod1Mask .|. shiftMask, xK_k), windowSwap U False)
                
              ,((0, 0x1008FF11), spawn "amixer set Master 7%-")
              ,((0, 0x1008FF13), spawn "amixer set Master 7%+")
              ,((0, 0x1008FF12), spawn "amixer -D pulse set Master toggle")

            ]
