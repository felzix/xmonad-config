--
-- xmonad example config file for xmonad-0.9
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--
-- NOTE: Those updating from earlier xmonad versions, who use
-- EwmhDesktops, safeSpawn, WindowGo, or the simple-status-bar
-- setup functions (dzen, xmobar) probably need to change
-- xmonad.hs, please see the notes below, or the following
-- link for more details:
--
-- http://www.haskell.org/haskellwiki/Xmonad/Notable_changes_since_0.8
--

import Data.Monoid
import Data.Tuple
import qualified Data.Map        as M
import System.Exit
import System.IO
import System.Posix.Unistd

import XMonad
import qualified XMonad.StackSet as W
import XMonad.Actions.Volume
import XMonad.Actions.SpawnOn
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Util.Run(spawnPipe)
import XMonad.Layout.ResizableTile
import XMonad.Layout.PerWorkspace
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import XMonad.Actions.TopicSpace
import XMonad.Prompt
import XMonad.Prompt.Workspace

host = fmap nodeName getSystemID

scriptBin  = "~/.xmonad/bin/"
myBrowser  = scriptBin ++ "browser.sh"
myTerminal = "gnome-terminal" --probably must name this myTerminal
myEmail    = "thunderbird"
javaOracle = "export PATH=/usr/lib/jvm/java-7-oracle/jre/bin/java/:$PATH;"
javaOpen   = "export PATH=/usr/lib/jvm/java-7-openjdk-amd64/bin/:$PATH;"
pyCharm    = javaOracle ++ "~/pycharm-2.6.3/bin/pycharm.sh"
eclipse    = javaOpen ++ "eclipse"
leksah     = "leksah"
dmenuExec  = "exe=`dmenu_path | dmenu` && eval \"exec $exe\""
dmenuWhite = "exe=`cat " ++ scriptBin ++ "dmenu_whitelist|dmenu` && eval \"exec $exe\""

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Width of the window border in pixels.
--
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

spawnShell :: X ()
spawnShell = currentTopicDir myTopicConfig >>= spawnShellIn

spawnShellIn :: Dir -> X ()
spawnShellIn dir = spawn $ "urxvt '(cd ''" ++ dir ++ "'' && " ++ myTerminal ++ " )'"

-- The list of all topics/workspaces of your xmonad configuration.
-- The order is important, new topics must be inserted
-- at the end of the list if you want hot-restarting
-- to work.
data TI = TI
  { topic  :: Topic
  , keySym :: KeySym
  , fn     :: X()
  }
tiT :: TI -> Topic
tiT (TI topic _ _) = topic
tiK :: TI -> KeySym
tiK (TI _ keySym _) = keySym
tiF :: TI -> X()
tiF (TI _ _ fn) = fn

topics :: [TI]
topics =
  --   Main list
  [ TI "home"           xK_F1  $ return ()
  , TI "media"          xK_m   $ return () -- TODO bring up media list somehow
  , TI "talk"           xK_t   $ spawnHere "pidgin"
  , TI "email"          xK_e   $ spawnHere myEmail
  , TI "journal"        xK_j   $ spawnHere "gedit ~/journal/`date +'%y-%m-%d'`"
  , TI "internet"       xK_i   $ spawnHere myBrowser
  , TI "gaming"         xK_g   $ return () -- TODO bring up game list somehow
  , TI "eclipse1"       xK_1   $ spawnHere eclipse
  , TI "pycharm3"       xK_3   $ spawnHere pyCharm
  , TI "leksah5"        xK_5   $ spawnHere leksah
  , TI "documentation"  xK_d   $ spawnHere myBrowser
  --   Secondary list
  , TI "eclipse2"       xK_2   $ spawnHere eclipse
  , TI "pycharm4"       xK_4   $ spawnHere pyCharm
  , TI "leksah6"        xK_6   $ spawnHere leksah
  , TI "misc2"          xK_F2  $ return ()
  , TI "misc3"          xK_F3  $ return ()
  , TI "misc4"          xK_F4  $ return ()
  , TI "misc5"          xK_F5  $ return ()
  , TI "misc6"          xK_F6  $ return ()
  , TI "misc7"          xK_F7  $ return ()
  , TI "misc8"          xK_F8  $ return ()
  , TI "misc9"          xK_F9  $ return ()
  , TI "misc10"         xK_F10 $ return ()
  , TI "misc11"         xK_F11 $ return ()
  , TI "misc12"         xK_F12 $ return ()
  -- Put hot-added workspaces after here. Organize later.
  ]

myTopics = map tiT topics
myTopicKeys = map tiK topics
myTopicFns = zip myTopics (map tiF topics)

myTopicConfig :: TopicConfig
myTopicConfig = defaultTopicConfig
  { topicDirs = M.fromList []
  , defaultTopicAction = const $ spawnShell >*> 3
  , defaultTopic = "home"
  , topicActions = M.fromList myTopicFns
  }

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#ff0000"

-- Keys
noModMask         = 0
altMaskLeft       = mod1Mask
altMaskRight      = mod3Mask
audioRaiseVolume :: KeySym
audioRaiseVolume  = 0x1008FF13
audioLowerVolume :: KeySym
audioLowerVolume  = 0x1008FF11
audioMute        :: KeySym
audioMute         = 0x1008FF12
audioPrev        :: KeySym
audioPrev         = 0x1008FF16
audioNext        :: KeySym
audioNext         = 0x1008FF17
audioPlay        :: KeySym
audioPlay         = 0x1008FF14
calculator       :: KeySym
calculator        = 0x1008FF1D

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    [
    -- Media
      ((noModMask, audioLowerVolume), lowerVolume 4 >> return ())
    , ((noModMask, audioRaiseVolume), raiseVolume 4 >> return ())
    , ((noModMask, audioMute       ), spawn $ scriptBin ++ "mute.rb")
    , ((noModMask, audioPrev       ), spawn $ scriptBin ++ "prev.sh")
    , ((noModMask, audioNext       ), spawn $ scriptBin ++ "next.sh")
    , ((noModMask, audioPlay       ), spawn $ scriptBin ++ "play.sh")

    -- Window launching
    , ((noModMask,          calculator), spawnHere $ myTerminal ++ " -e python")
    -- terminal
    , ((modm .|. shiftMask, xK_Return ), spawnHere $ XMonad.terminal conf)
    -- browser
    , ((modm,               xK_KP_Subtract), spawnHere myBrowser)
    -- Launch dmenu w/ whitelist
    , ((modm,                  xK_grave ), spawn dmenuWhite)
    -- Launch dmenu w/o whitelist
    , ((modm .|. altMaskLeft,  xK_grave ), spawn dmenuExec)
    , ((modm .|. altMaskRight, xK_grave ), spawn dmenuExec)

    -- Layout
    -- Rotate through the available layout algorithms
    , ((modm,                  xK_space   ), sendMessage NextLayout)
    --  Reset the layouts on the current workspace to default
    , ((modm .|. altMaskLeft,  xK_space   ), setLayout $ XMonad.layoutHook conf)
    , ((modm .|. altMaskRight, xK_space   ), setLayout $ XMonad.layoutHook conf)
    -- Shrink the master area horizontally
    , ((modm,                  xK_Down    ), sendMessage Shrink)
    -- Expand the master area horizontally
    , ((modm,                  xK_Up      ), sendMessage Expand)
    -- Shrink the master area vertically
    , ((modm .|. shiftMask,    xK_Down    ), sendMessage MirrorShrink)
    -- Expand the master area vertically
    , ((modm .|. shiftMask,    xK_Up      ), sendMessage MirrorExpand)
    -- Push window back into tiling
    , ((modm .|. shiftMask,    xK_grave   ), withFocused $ windows . W.sink)
    -- Increment the number of windows in the master area
    , ((modm              ,    xK_comma   ), sendMessage (IncMasterN 1))
    -- Deincrement the number of windows in the master area
    , ((modm              ,    xK_period  ), sendMessage (IncMasterN (-1)))

    -- Window
    -- close focused window
    , ((modm,                  xK_backslash   ), kill)
    -- Move focus to the next window
    , ((modm,                  xK_Tab         ), windows W.focusDown)
    -- Move focus to the previous window
    , ((modm .|. shiftMask,    xK_Tab         ), windows W.focusUp)
    -- Move focus to the master window
    , ((modm .|. altMaskLeft,  xK_Tab         ), windows W.focusMaster)
    , ((modm .|. altMaskRight, xK_Tab         ), windows W.focusMaster)
    -- Swap the focused window and the master window
    , ((modm,                  xK_Return      ), windows W.swapMaster)
    -- Swap the focused window with the next window
    , ((modm ,                 xK_bracketright), windows W.swapDown)
    -- Swap the focused window with the previous window
    , ((modm,                  xK_bracketleft ), windows W.swapUp)
    -- Goto workspace
    , ((modm,                  xK_KP_0        ), workspacePrompt defaultXPConfig (switchTopic myTopicConfig))
    , ((modm,                  xK_KP_Insert   ), workspacePrompt defaultXPConfig (switchTopic myTopicConfig))
    -- Shift to workspace
    , ((modm .|. shiftMask,    xK_KP_0        ), workspacePrompt defaultXPConfig $ windows . W.shift)
    , ((modm .|. shiftMask,    xK_KP_Insert   ), workspacePrompt defaultXPConfig $ windows . W.shift)

    -- XMonad
    -- Quit xmonad
    , ((modm .|. shiftMask,    xK_Escape), io (exitWith ExitSuccess))
    -- Restart xmonad
    , ((modm .|. altMaskLeft,  xK_Return), spawn "xmonad --recompile; xmonad --restart")
    , ((modm .|. altMaskRight, xK_Return), spawn "xmonad --recompile; xmonad --restart")
    -- Lock screen
    , ((modm,                  xK_Escape), spawn "gnome-screensaver-command -l")

    ]
    ++

    --
    -- mod-topicKey, Switch to workspace
    -- mod-shift-topicKey, Move client to workspace
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) myTopicKeys
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{keypad1,keypad2,keypad3}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{keypad1,keypad3,keypad3}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_KP_1, xK_KP_2, xK_KP_3] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    [
    -- Left Mouse Button - raise the window to the top of the stack
       ((modm, button1), (\w -> focus w >> windows W.shiftMaster))

    -- Right Mouse Button - set the window to floating mode and move by dragging
    , ((modm, button3), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- Right Mouse Button + Shift - set the window to floating mode and resize by dragging
    , ((modm .|. shiftMask, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--

singletonWorkspaces = ["media", "gaming"]
talkWorkspaces      = ["talk"]

myLayout = onWorkspaces singletonWorkspaces singletonLayout
         $ onWorkspaces talkWorkspaces talkLayout
         $ regularLayouts

regularLayouts = avoidStruts $ tiled ||| Full
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = ResizableTall nmaster delta ratio []

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio   = 1/2

    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

singletonLayout = avoidStruts $ noBorders $ simpleTabbed ||| Full
talkLayout      = avoidStruts $ noBorders $ simpleTabbed

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
    , className =? "Gimp"           --> doFloat
    , className =? "Pidgin"         --> doShift "talk"
    , className =? "Pithos"         --> doShift "media"
    , className =? "Thunderbird"    --> doShift "email"
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , isFullscreen                  --> doFullFloat
    ]

------------------------------------------------------------------------
-- Event handling

-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add EWMH event handling to your custom event hooks by
-- combining them with ewmhDesktopsEventHook.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
myStartupHook =
  -- Fixes java display issue
  setWMName "LG3D"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
    xmproc <- spawnPipe "xmobar"
    xmonad =<< defaults

defaults = do
    checkTopicConfig myTopics myTopicConfig
    return $ defaultConfig
        {
        -- simple stuff
          terminal           = myTerminal
        , focusFollowsMouse  = myFocusFollowsMouse
        , borderWidth        = myBorderWidth
        , modMask            = myModMask
        , workspaces         = myTopics
        , normalBorderColor  = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor

        -- key bindings
        , keys               = myKeys
        , mouseBindings      = myMouseBindings

        -- hooks, layouts
        , layoutHook         = myLayout
        , manageHook         = manageSpawn <+> myManageHook
        , handleEventHook    = myEventHook
        , logHook            = myLogHook
        , startupHook        = myStartupHook
        }

