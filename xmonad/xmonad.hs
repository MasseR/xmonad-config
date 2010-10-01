-- xmonad config used by Vic Fryzel
-- Author: Vic Fryzel
-- http://github.com/vicfryzel/xmonad-config
 
import System.IO
import System.Exit
import XMonad
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.PerWorkspace
import XMonad.Util.Run(spawnPipe, safeSpawn)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.NamedWindows
import XMonad.Prompt
import XMonad.Prompt.Input

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- Zenburn colors from http://github.com/davidbeckingsale/xmonad-config/blob/master/xmonad.hs
-- Main Colours
myFgColor = "#DCDCCC"
myBgColor = "#3f3f3f"
myHighlightedFgColor = "#DCDCCC"
myHighlightedBgColor = "#7F9F7F"
myInactiveFgColor = "#333333"

--- Borders
myActiveBorderColor = myHighlightedBgColor
myInactiveBorderColor = "#262626"
myBorderWidth = 2

--- Urgency
myUrgencyHintFgColor = "#333333"
myUrgencyHintBgColor = "#F18C96"

myFont = "xft:Inconsolata-9"

scrot = "scrot"
scrotWindow = scrot ++ " -s"

fPrintScreen :: String -> String -> X ()
fPrintScreen s f = spawn $ s ++ " $HOME/.screenshot/" ++ f

printScreen :: String -> X ()
printScreen s = inputPrompt defaultXPConfig "Print screen to file" ?+ (fPrintScreen s)
 
-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "urxvtc"
 
-- Width of the window border in pixels.
--
-- myBorderWidth   = 1
 
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod1Mask
 
-- The mask for the numlock key. Numlock status is "masked" from the
-- current modifier status, so the keybindings will work with numlock on or
-- off. You may need to change this on some systems.
--
-- You can find the numlock modifier by running "xmodmap" and looking for a
-- modifier with Num_Lock bound to it:
--
-- > $ xmodmap | grep Num
-- > mod2        Num_Lock (0x4d)
--
-- Set numlockMask = 0 if you don't have a numlock key, or want to treat
-- numlock status separately.
--
myNumlockMask   = mod2Mask
 
-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1:im","2:web","3:code","4:pdf","5:vid"] ++ map show [6..12]
 
-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#7c7c7c"
myFocusedBorderColor = "#ffb6b0"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
 
    -- launch a terminal
    [ ((modMask, xK_Return), spawn $ XMonad.terminal conf)

    , ((modMask .|. controlMask, xK_l     ), spawn "xscreensaver-command -lock")

    -- launch scrot (e.g take a screenshot
    , ((0, xK_Print                 ), printScreen scrot)
    , ((modMask, xK_Print                 ), printScreen scrotWindow)

    -- launch dmenu
    , ((modMask,               xK_p     ), spawn "exe=`~/bin/dmenu_path | /home/masse/.cabal/bin/yeganesh` && eval \"exec $exe\"")
    -- , ((modMask,               xK_p     ), spawn "exe=`~/bin/dmenu_path | /usr/bin/dmenu -fn '-*-terminus-*-r-normal-*-*-120-*-*-*-*-iso8859-*' -nf '#FFFFFF' -sb '#7C7C7C' -sf '#CEFFAC'` && eval \"exec $exe\"")
 
    -- close focused window 
    , ((modMask .|. shiftMask, xK_c     ), kill)
 
     -- Rotate through the available layout algorithms
    , ((modMask,               xK_space ), sendMessage NextLayout)
 
    --  Reset the layouts on the current workspace to default
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
 
    -- Resize viewed windows to the correct size
    , ((modMask,               xK_n     ), refresh)
 
    -- Move focus to the next window
    , ((modMask,               xK_Tab   ), windows W.focusDown)
 
    -- Move focus to the next window
    , ((modMask,               xK_j     ), windows W.focusDown)
 
    -- Move focus to the previous window
    , ((modMask,               xK_k     ), windows W.focusUp  )
 
    -- Move focus to the master window
    , ((modMask,               xK_m     ), windows W.focusMaster  )
 
    -- Swap the focused window and the master window
    , ((shiftMask .|. modMask,               xK_Return), windows W.swapMaster)
 
    -- Swap the focused window with the next window
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  )
 
    -- Swap the focused window with the previous window
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    )
 
    -- Shrink the master area
    , ((modMask,               xK_h     ), sendMessage Shrink)
 
    -- Expand the master area
    , ((modMask,               xK_l     ), sendMessage Expand)
 
    -- Push window back into tiling
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink)
 
    -- Increment the number of windows in the master area
    , ((modMask              , xK_comma ), sendMessage (IncMasterN 1))
 
    -- Deincrement the number of windows in the master area
    , ((modMask              , xK_period), sendMessage (IncMasterN (-1)))
 
    -- Quit xmonad
    , ((modMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
 
    -- Restart xmonad
    , ((modMask              , xK_q     ), restart "xmonad" True)
    ]
    ++
 
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_F1 .. xK_F12]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
 
 
------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
 
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))
 
    -- mod-button2, Set the window to floating mode and resize by dragging
    , ((modMask, button2), (\w -> focus w >> mouseResizeWindow w))
    ]
 
------------------------------------------------------------------------
-- Layouts:
 
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myTabConfig = defaultTheme {   activeBorderColor = myHighlightedFgColor
                             , activeTextColor = myFgColor
                             , activeColor = myBgColor
			     , fontName = myFont
                             , inactiveBorderColor = myInactiveBorderColor
                             , inactiveTextColor = myInactiveFgColor
                             , inactiveColor = myInactiveBorderColor 
			   }
myLayout = onWorkspace "4:pdf" pdfLayout $ defLayout
  where
     pdfLayout = avoidStruts $ tabbed shrinkText myTabConfig
     defLayout = avoidStruts (tiled ||| Mirror tiled ||| tabbed shrinkText myTabConfig ||| Full)
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
 
     -- The default number of windows in the master pane
     nmaster = 1
 
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
 
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100
 
------------------------------------------------------------------------
-- Window rules:
 
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Smplayer"       --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "Firefox"       --> doShift "2:web"
    , className =? "Gvim"       --> doShift "3:code"
    , className =? "Evince"       --> doShift "4:pdf"
    , className =? "Kpdf"       --> doShift "4:pdf"
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore 
    ]
 
-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False -- Not good with touchpad
 
data NotifyUrgencyHook = NotifyUrgencyHook deriving (Read, Show)

instance UrgencyHook NotifyUrgencyHook where
  urgencyHook _ w = do
    name <- getName w
    ws <- gets windowset
    whenJust (W.findTag w ws) (notify name)
    where notify n w = safeSpawn "notify-send" $ ["XMonad", show n ++ " requests your attention on " ++ show w]
 
------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.
 
xmobarPath = "/usr/local/bin/xmobar ~/.xmonad/xmobar"
xmobarDevelPath = "/home/masse/git/xmobar/dist/build/xmobar/xmobar ~/.xmonad/xmobar"
-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
        xmproc <- spawnPipe xmobarPath
        xmonad $ withUrgencyHook NotifyUrgencyHook defaults {
                logHook            = dynamicLogWithPP $ xmobarPP {
                                ppOutput = hPutStrLn xmproc
                                , ppTitle = xmobarColor "#FFB6B0" "" . shorten 100
                                , ppCurrent = xmobarColor "#CEFFAC" ""
                                , ppSep = "   "
				, ppUrgent = xmobarColor myUrgencyHintFgColor myUrgencyHintBgColor . xmobarStrip
                                }
                , manageHook = manageDocks <+> myManageHook
                , startupHook = setWMName "LG3D"
        }
 
-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will 
-- use the defaults defined in xmonad/XMonad/Config.hs
-- 
-- No need to modify this.
--
defaults = defaultConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        numlockMask        = myNumlockMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myInactiveBorderColor,
        focusedBorderColor = myActiveBorderColor,
 
      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,
 
      -- hooks, layouts
        layoutHook         = smartBorders $ myLayout
    }
